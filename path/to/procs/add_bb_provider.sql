create procedure "Decisioning_procs"."Add_BB_Provider"( in "Output_Table_Name" varchar(100),in "Obs_Dt_Field" varchar(100) default null,
  in "Field_Update_Type" varchar(30) default 'Drop and Replace', --'Rename and Replace','Update Only'
  in "Field_1" varchar(100) default null,
  in "Field_2" varchar(100) default null,
  in "Field_3" varchar(100) default null,
  in "Field_4" varchar(100) default null,
  in "Field_5" varchar(100) default null,
  in "Where_Cond" long varchar default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  -- Declare Target_Table varchar(100);
  -- Declare Update_Fields_SQL long varchar;
  -- Declare Field_Num integer;
  declare "DL_Recency_Decay_Coefficient" decimal(20,18);
  declare "Earliest_OD_Dt" date;
  set "DL_Recency_Decay_Coefficient" = .010181008;
  -- =-LN(2/5)/90 the avg weight of each 90 day period is 2/5 the avg weight of the preceding period
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"("Field_1","Field_2","Field_3","Field_4","Field_5");
  -- Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when 'bb_provider' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''bb_provider''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when 'bb_provider' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''bb_provider''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  -- Add Fields
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL"
       = ' Alter table ' || "Output_Table_Name"
       || ' Add( '
       || case when 'bb_provider' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'BB_Provider varchar(20) default null null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ----------------------------------------------------------
  -- Create table of distinct accounts and obs dts
  ----------------------------------------------------------
  drop table if exists #Acc_Obs_Dts;
  execute immediate 'Select distinct account_number, '
     || "Obs_Dt_Field" || ','
     || ' Cast(' || "Obs_Dt_Field" || ' as datetime) as Obs_dttm, '
     || ' Cast(' || "Obs_Dt_Field" || ' - 360 as datetime) as Prev_Yr_Obs_dttm, '
     || ' Cast(null as varchar(20)) as BB_Provider '
     || ' into #Acc_Obs_Dts '
     || ' from ' || "Output_Table_Name" || ' '
     || case when "Where_Cond" is not null then ' Where ' end || "Where_Cond" || ' ' || ';';
  //Select * into #Acc_Obs_Dts from Acc_Obs_Dts;
  commit work;
  create hg index "idx_1" on #Acc_Obs_Dts("Account_number");
  create hg index "idx_2" on #Acc_Obs_Dts("Obs_dttm");
  create hg index "idx_3" on #Acc_Obs_Dts("Prev_Yr_Obs_dttm");
  create lf index "idx_4" on #Acc_Obs_Dts("BB_Provider");
  execute immediate 'create date index idx_5 on #Acc_Obs_Dts(' || "Obs_Dt_Field" || ');';
  //create hg index idx_4 on #Acc_Obs_Dts(end_date); 
  set "Earliest_OD_Dt" = (select cast("min"("Obs_dttm"-360) as date) from #Acc_Obs_Dts);
  -----------------------------------------------------------------
  -- Add Sky BB Subscriber info
  -----------------------------------------------------------------
  execute immediate ''
     || ' Update #Acc_Obs_Dts as base'
     || ' Set BB_Provider = ''BskyB'' '
     || ' from #Acc_Obs_Dts as base '
     || '     inner join '
     || '     Decisioning.Active_Subscriber_Report asr '
     || '     on asr.account_number = base.account_number '
     || '        and base.' || "Obs_Dt_Field" || ' between asr.effective_from_dt and asr.effective_to_dt - 1 '
     || '        and asr.Subscription_Sub_Type = ''Broadband'' ';
  //Select top 1000 * from #Acc_Obs_Dts
  //Select * into #Acc_Obs_Dts from Acc_Obs_Dts
  -----------------------------------------------------------------
  -- Add On Demand Download Provider info
  -----------------------------------------------------------------
  select distinct "account_number" into #Non_Sky_BB from #Acc_Obs_Dts where "BB_Provider" is null;
  commit work;
  create hg index "idx_1" on #Non_Sky_BB("Account_Number");
  select "account_number","date"("last_modified_dt") as "Download_Dt","network_code","count"() as "Downloads"
    into #Acc_Downloads
    from "cust_anytime_plus_downloads"
    where "account_number" = any(select "account_number" from #Non_Sky_BB)
    and "network_code" <> 'bskyb'
    group by "account_number","Download_Dt","network_code";
  //Select * into #Acc_Downloads from Acc_Downloads 
  commit work;
  create hg index "idx_1" on #Acc_Downloads("account_number");
  create date index "idx_2" on #Acc_Downloads("Download_Dt");
  create lf index "idx_3" on #Acc_Downloads("network_code");
  drop table if exists #Acc_Provider;
  execute immediate
    ' Select base.account_number,base.' || "Obs_Dt_Field" || ',capd.network_code,'
     || ' sum(Exp(- DL_Recency_Decay_Coefficient * (base.' || "Obs_Dt_Field" || ' - Cast(capd.Download_dt as date)))) as Total_Provider_Weight, '
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by Total_Provider_Weight desc) as Provider_Rnk '
     || ' into #Acc_Provider '
     || ' from #Acc_Obs_Dts as Base '
     || ' inner join '
     || ' #Acc_Downloads as capd '
     || ' on capd.account_number = base.account_number '
     || '    and capd.Download_dt between base.' || "Obs_Dt_Field" || ' - 365 and base.' || "Obs_Dt_Field"
     || '    and capd.network_code != ''bskyb'' ' -- Remove bskyb as Sky bb will be flagged using subs data
     || ' where capd.network_code != ''bskyb'' '
     || ' group by base.account_number,base.' || "Obs_Dt_Field" || ',capd.network_code ';
  //Select * into #Acc_Provider from Acc_Provider 
  commit work;
  create hg index "idx_1" on #Acc_Provider("account_number");
  create lf index "idx_2" on #Acc_Provider("Provider_Rnk");
  execute immediate 'Create date index idx_3 on #Acc_Provider(' || "Obs_Dt_Field" || ')';
  set "Dynamic_SQL" = ''
     || ' Update #Acc_Obs_Dts aod '
     || ' Set bb_provider = ap.network_code '
     || ' from #Acc_Obs_Dts aod '
     || '      inner join '
     || '      #Acc_Provider ap '
     || '    on ap.account_number = aod.account_number '
     || '        and ap.' || "Obs_Dt_Field" || ' = aod.' || "Obs_Dt_Field"
     || ' where Provider_Rnk = 1';
  execute immediate "Dynamic_SQL";
  //Select top 1000 * from #Acc_Obs_Dts 
  update #Acc_Obs_Dts
    set "bb_provider" = 'Unknown'
    where "bb_provider" is null;
  -----------------------------------------------------------------
  -- Update Target Table BB Provider info
  -----------------------------------------------------------------
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name"
     || ' Set '
     || case when 'bb_provider' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'BB_Provider = ap.bb_provider,'
    else ''
    end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' from ' || "Output_Table_Name" || ' as base '
     || '     inner join '
     || '     #Acc_Obs_Dts ap '
     || '     on ap.account_number = base.account_number '
     || '        and ap.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field";
  //|| '        and ap.Provider_Rnk = 1 '
  execute immediate "Dynamic_SQL"
end
