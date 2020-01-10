create procedure "Decisioning_Procs"."Add_Calls_Answered"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Call_Type" varchar(50),
  in "Field_Update_Type" varchar(30) default 'Drop and Replace', --'Rename and Replace','Update Only'
  in "Field_1" varchar(100) default null,
  in "Field_2" varchar(100) default null,
  in "Field_3" varchar(100) default null,
  in "Field_4" varchar(100) default null,
  in "Field_5" varchar(100) default null,
  in "Field_6" varchar(100) default null,
  in "Field_7" varchar(100) default null,
  in "Field_8" varchar(100) default null,
  in "Field_9" varchar(100) default null,
  in "Field_10" varchar(100) default null,
  in "Field_11" varchar(100) default null,
  in "Field_12" varchar(100) default null,
  in "Field_13" varchar(100) default null,
  in "Field_14" varchar(100) default null,
  in "Field_15" varchar(100) default null,
  in "Field_16" varchar(100) default null,
  in "Field_17" varchar(100) default null,
  in "Field_18" varchar(100) default null,
  in "Field_19" varchar(100) default null,
  in "Field_20" varchar(100) default null,
  in "Field_21" varchar(100) default null,
  in "Field_22" varchar(100) default null,
  in "Field_23" varchar(100) default null,
  in "Field_24" varchar(100) default null,
  in "Field_25" varchar(100) default null,
  in "Field_26" varchar(100) default null,
  in "Field_27" varchar(100) default null,
  in "Field_28" varchar(100) default null,
  in "Field_29" varchar(100) default null,
  in "Field_30" varchar(100) default null,
  in "Where_Cond" long varchar default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Target_Table" varchar(50);
  declare "Dynamic_SQL_Start" long varchar;
  set "Target_Table" = 'CITeam.Calls_Answered';
  set temporary option "Query_Temp_Space_Limit" = 0;
  set "Call_Type" = case "upper"("Call_Type")
    when 'VALUE' then 'Value'
    when 'BBCOE' then 'BBCoE'
    when 'BB' then 'AnyBB'
    when 'ANYBB' then 'AnyBB'
    when 'DORT' then 'DORT'
    when 'SERVICE' then 'Service'
    when 'ALL' then 'All'
    when 'PLATFORM_RETENTION' then 'Platform_Retention'
    when 'PLATFORM RETENTION' then 'Platform_Retention'
    when 'RETENTION' then 'Platform_Retention'
    when 'TA' then 'Platform_Retention'
    when 'PLATFORM_CORE' then 'Platform_Retention'
    when 'PLATFORM CORE' then 'Platform_Retention'
    when 'BILLING' then 'Billing'
    when 'ALL' then 'All' end;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30");
  ------------------------------------------------------------------------------------------------------------
  -- 2. Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL_Start"
     || case when "LOWER"('_1st_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "Call_Type" || '_Call_Dt''' end
     || case when "LOWER"('Last_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Last_' || "Call_Type" || '_Call_Dt''' end
     || case when "LOWER"('Next_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Next_' || "Call_Type" || '_Call_Dt''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Next_1Yr''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Next_180D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Next_30D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Next_7D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_1D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_7D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_30D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_90D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_180D''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_1Yr''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_3Yr''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_In_Last_5Yr''' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Call_Type" || '_Calls_Ever''' end
     || ')';
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 3. Add columns
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ''
       || ' ALTER TABLE ' || "Output_Table_Name" || ' ADD('
       || case when "LOWER"('_1st_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "Call_Type" || '_Call_Dt date default null null,' end
       || case when "LOWER"('Last_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Last_' || "Call_Type" || '_Call_Dt date default null null,' end
       || case when "LOWER"('Next_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Next_' || "Call_Type" || '_Call_Dt date default null null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_1Yr integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_180D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_30D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_7D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_1D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_7D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_30D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_90D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_180D integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_1Yr integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_3Yr integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_5Yr integer default 0 null,' end
       || case when "LOWER"('' || "Call_Type" || '_Calls_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_Ever integer default 0 null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  -----------------------------------------------------------------------------------------------------
  execute immediate 'Select distinct account_number, ' || "Obs_Dt_Field" || ' into #Acc_Obs_Dts from ' || "Output_Table_Name"
     || case when "Where_Cond" is not null then ' where ' || "Where_Cond" end
     || ';';
  commit work;
  create hg index "idx_1" on #Acc_Obs_Dts("Account_number");
  execute immediate 'create date index idx_2 on #Acc_Obs_Dts(' || "Obs_Dt_Field" || ');';
  -- 4. Select columns and insert into Temp table
  set "Dynamic_SQL" = 'DROP TABLE IF EXISTS #Calls_Answered';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', '
     || ' MIN(case when trgt.Interaction_Dt <= base.' || "Obs_Dt_Field" || ' then trgt.Interaction_Dt end) AS _1st_call_Dt, '
     || ' MAX(case when trgt.Interaction_Dt <= base.' || "Obs_Dt_Field" || ' then trgt.Interaction_Dt end) AS Last_call_Dt, '
     || ' Min(case when trgt.Interaction_Dt > base.' || "Obs_Dt_Field" || ' then trgt.Interaction_Dt end) AS Next_call_Dt, '
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' + 1 and dateadd(Year,1,base.' || "Obs_Dt_Field" || ')  then 1 else 0 end) as Calls_In_Next_1Yr,'
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 180 then 1 else 0 end) as Calls_In_Next_180D,'
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as Calls_In_Next_30D,'
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as Calls_In_Next_7D,'
     || ' sum(Case when trgt.Interaction_Dt = base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_1D,'
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_7D,'
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_30D,'
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_90D,'
     || ' sum(Case when trgt.Interaction_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_180D,'
     || ' sum(Case when trgt.Interaction_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_1Yr,'
     || ' sum(Case when trgt.Interaction_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_3Yr,'
     || ' sum(Case when trgt.Interaction_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_In_Last_5Yr,'
     || ' sum(Case when trgt.Interaction_Dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as Calls_Ever '
     || ' INTO #Calls_Answered '
     || ' FROM #Acc_Obs_Dts as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || case "Call_Type" when 'All' then ''
    when 'Value' then ' AND Trgt.Value_Call = 1 '
    when 'BBCoE' then ' AND Trgt.BBCoE_Call = 1 '
    when 'AnyBB' then ' AND Trgt.BB_Call = 1 '
    when 'DORT' then ' AND Trgt.DORT_Call = 1 '
    when 'Service' then ' AND Trgt.Service_Call = 1 '
    when 'Platform_Retention' then ' AND Trgt.Platform_Core_Call = 1 '
    when 'Billing' then ' AND Trgt.Billing_Call = 1 ' end
     || ' GROUP BY base.account_number,base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  --------------------------------------------------------------------------------------------------------------------------------
  -- 5. Update output table
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name"
     || ' SET '
     || case when "LOWER"('_1st_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "Call_Type" || '_Call_Dt = trgt._1st_Call_Dt,' end
     || case when "LOWER"('Last_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Last_' || "Call_Type" || '_Call_Dt = trgt.Last_Call_Dt,' end
     || case when "LOWER"('Next_' || "Call_Type" || '_Call_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Next_' || "Call_Type" || '_Call_Dt = trgt.Next_Call_Dt,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_1Yr = trgt.Calls_In_Next_1Yr,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_180D = trgt.Calls_In_Next_180D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_30D = trgt.Calls_In_Next_30D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Next_7D = trgt.Calls_In_Next_7D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_1D = trgt.Calls_In_Last_1D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_7D = trgt.Calls_In_Last_7D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_30D = trgt.Calls_In_Last_30D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_90D = trgt.Calls_In_Last_90D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_180D = trgt.Calls_In_Last_180D,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_1Yr = trgt.Calls_In_Last_1Yr,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_3Yr = trgt.Calls_In_Last_3Yr,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_In_Last_5Yr = trgt.Calls_In_Last_5Yr,' end
     || case when "LOWER"('' || "Call_Type" || '_Calls_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Call_Type" || '_Calls_Ever = trgt.Calls_Ever,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name"
       || '        INNER JOIN '
       || '        #Calls_Answered as trgt '
       || ' ON trgt.account_number = ' || "Output_Table_Name" || '.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = ' || "Output_Table_Name" || '.' || "Obs_Dt_Field"
       || case when "Where_Cond" is not null then ' where ' || "Where_Cond" end;
    execute immediate "Dynamic_SQL"
  end if
end
