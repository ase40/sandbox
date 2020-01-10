create procedure "Decisioning_procs"."Add_Active_Subscriber_Product_Holding"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Product_Type" varchar(80),
  in "Field_Update_Type" varchar(30) default 'Drop and Replace',
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
  in "Field_20" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20");
  set "Product_Type" = case "upper"("Product_Type")
    when 'DTV' then 'DTV'
    when 'DTV PRIMARY VIEWING' then 'DTV'
    when 'BROADBAND' then 'BB'
    when 'BB' then 'BB'
    when 'HD' then 'HD'
    when 'DTV HD' then 'HD'
    when 'MULTISCREEN' then 'MS'
    when 'MS' then 'MS'
    when 'DTV_EXTRA_SUBSCRIPTION' then 'MS'
    when 'SGE' then 'SGE'
    when 'SKY GO EXTRA' then 'SGE'
    when 'PREMS' then 'Prems'
    when 'SPORTS' then 'Sports'
    when 'MOVIES' then 'Movies'
    when 'CINEMA' then 'Movies'
    when 'TT' then 'TT'
    when 'TOPTIER' then 'TT'
    when 'TOP TIER' then 'TT'
    when 'SKY TALK SELECT' then 'Talk'
    when 'TALK' then 'Talk'
    when 'LINE RENTAL' then 'LR'
    when 'LR' then 'LR'
    when 'SKY+' then 'SkyPlus'
    when 'SKY +' then 'SkyPlus'
    when 'SKYPLUS' then 'SkyPlus'
    when 'SKY PLUS' then 'SkyPlus'
    when 'SKY KIDS' then 'SkyKids'
    when 'SKY_KIDS' then 'SkyKids'
    when 'SKYKIDS' then 'SkyKids'
    when 'KIDS' then 'SkyKids'
    when 'BOX_SETS' then 'Sky_Box_Sets'
    when 'BOXSETS' then 'Sky_Box_Sets'
    when 'UOD' then 'UOD' end;
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when "lower"("Product_Type") || '_active' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Active'' ' end
       || case when "lower"("Product_Type") || '_status_code' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Status_Code''' end
       || case when "lower"("Product_Type") || '_product_holding' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Product_Holding''' end
       || case when "lower"("Product_Type") || '_current_product_sk' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Current_Product_sk''' end
       || case when "lower"("Product_Type") in( 'prems','tt','sports','movies','ms' ) and("lower"("Product_Type") || '_product_count' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null) then ',''' || "Product_Type" || '_Product_Count''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when "lower"("Product_Type") || '_active' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Active''' end
       || case when "lower"("Product_Type") || '_status_code' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Status_Code''' end
       || case when "lower"("Product_Type") || '_product_holding' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Product_Holding''' end
       || case when "lower"("Product_Type") || '_current_product_sk' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Current_Product_sk''' end
       || case when "lower"("Product_Type") in( 'prems','tt','sports','movies','ms' ) and("lower"("Product_Type") || '_product_count' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null) then ',''' || "Product_Type" || '_Product_Count''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL"
       = ' Alter table ' || "Output_Table_Name"
       || ' Add( '
       || case when "lower"("Product_Type") || '_active' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Active tinyint default null,' end
       || case when "lower"("Product_Type") || '_status_code' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Status_Code varchar(10) default null,' end
       || case when "lower"("Product_Type") || '_product_holding' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Product_Holding varchar(80) default null,' end
       || case when "lower"("Product_Type") || '_current_product_sk' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Current_Product_sk integer default null,' end
       || case when "lower"("Product_Type") in( 'prems','tt','sports','movies','ms' ) and("lower"("Product_Type") || '_product_count' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null) then "Product_Type" || '_Product_Count tinyint default 0,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name"
     || ' Set '
     || case when "lower"("Product_Type") || '_active' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Active = Case when asr.account_number is not null then 1 else 0 end,'
    else ''
    end
     || case when "lower"("Product_Type") || '_status_code' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Status_Code = asr.Status_Code,'
    else ''
    end
     || case when "lower"("Product_Type") || '_product_holding' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Product_Holding = asr.Product_Holding,'
    else ''
    end
     || case when "lower"("Product_Type") || '_current_product_sk' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_current_product_sk = asr.current_product_sk,'
    else ''
    end
     || case when "lower"("Product_Type") in( 'prems','tt','sports','movies' ) 
    and("lower"("Product_Type") || '_product_count' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null) then
      "Product_Type" || '_Product_Count = '
       || ' Coalesce(Case when ''' || "lower"("Product_Type") || ''' in (''prems'',''tt'',''sports'') '
       || ' then Case when asr.Product_Holding like ''%Sky Sports - Complete Pack%'' then 6 '
       || '           when asr.Product_Holding like ''%Sports Mix%'' then 6 '
       || '           when asr.Product_Holding like ''%Sky Sports - 3 Packs%'' then 3 '
       || '           when asr.Product_Holding like ''%Sky Sports - 2 Packs%'' then 2 '
       || '           when asr.Product_Holding like ''%Sky Sports - 1 Pack%'' then 1 '
       || '           when lower(asr.Product_Holding) like ''%sports%'' then 3 '
       || '       end'
       || ' end,0)'
       || ' + '
       || ' Coalesce(Case when ''' || "lower"("Product_Type") || ''' in (''prems'',''tt'',''movies'') '
       || ' then Case when asr.Product_Holding like ''%Cinema%'' then 6 '
       || '           when asr.Product_Holding like ''%Top Tier%'' then 6 '
       || '           when asr.Product_Holding like ''%Movies Mix%'' then 6 '
       || '           when lower(asr.Product_Holding) like ''%movies%'' then 3 '
       || '       end'
       || ' end,0),'
    else ''
    end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' from ' || "Output_Table_Name" || ' as base '
     || '        left join '
     || '        CITeam.Active_Subscriber_Report asr '
     || '        on asr.account_number = base.account_number '
     || '            and base.' || "Obs_Dt_Field" || ' between asr.effective_from_dt and asr.effective_to_dt - 1 '
     || '            and asr.subscription_Sub_type =  ''' || case "Product_Type" when 'SGE' then 'Sky Go Extra'
    when 'MS' then 'Multiscreen'
    when 'DTV' then 'DTV'
    when 'HD' then 'HD'
    when 'Talk' then 'Talk'
    when 'LR' then 'Line Rental'
    when 'BB' then 'Broadband'
    when 'Sports' then 'Sports'
    when 'Movies' then 'Movies'
    when 'TT' then 'Top Tier'
    when 'Prems' then 'Prems'
    when 'SkyPlus' then 'DTV Sky+'
    when 'SkyKids' then 'SKY_KIDS'
    when 'Sky_Box_Sets' then 'SKY_BOX_SETS'
    when 'UOD' then 'ULTIMATE_OD_STREAMING_PRODUCTS' end
     || ''''
     || case "Product_Type" when 'Sports' then ' and asr.Sports_Active = 1 '
    when 'Movies' then ' and asr.Movies_Active = 1 '
    when 'TT' then ' and asr.TT_Active = 1 '
    when 'UOD' then ' and asr.product_holding <> ''UOD'' '
    else ''
    end;
  execute immediate "Dynamic_SQL";
  if "lower"("Product_Type") in( 'ms' ) then
    execute immediate
      ' Select base.account_number,base.' || "Obs_Dt_Field"
       || '        ,sum(asr.MS_Active_Subscription) MS_Subs '
       || ' into #Subscription_Count '
       || ' from ' || "Output_Table_Name" || ' as base '
       || '        left join '
       || '        CITeam.Active_Subscriber_Report asr '
       || '        on asr.account_number = base.account_number '
       || '            and base.' || "Obs_Dt_Field" || ' between asr.effective_from_dt and asr.effective_to_dt - 1 '
       || ' and asr.subscription_sub_Type = ''Multiscreen'' '
       || ' group by base.account_number,base.' || "Obs_Dt_Field";
    commit work;
    create hg index "idx_1" on #Subscription_Count("Account_Number");
    execute immediate 'create date index idx_2 on #Subscription_Count(' || "Obs_Dt_Field" || ');';
    execute immediate
      ' Update ' || "Output_Table_Name" || ' base'
       || ' Set ' || "Product_Type" || '_Product_Count = asr.MS_Subs '
       || ' from ' || "Output_Table_Name" || ' as base '
       || '        inner join '
       || '        #Subscription_Count asr '
       || '        on asr.account_number = base.account_number '
       || '            and base.' || "Obs_Dt_Field" || ' = asr.' || "Obs_Dt_Field"
  end if
end
