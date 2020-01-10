create procedure "decisioning_procs"."Add_Offers_Software"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Prod_Type" varchar(80),
  in "Offer_State" varchar(50) default 'Activated', -- 'Ordered'
  in "Offer_Applied_Type" varchar(50) default 'New', -- 'All','Autotransferred'
  in "Contract_Offer_Type" varchar(30) default null,
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
  in "Field_31" varchar(100) default null,
  in "Field_32" varchar(100) default null,
  in "Field_33" varchar(100) default null,
  in "Field_34" varchar(100) default null,
  in "Field_35" varchar(100) default null,
  in "Field_36" varchar(100) default null,
  in "Field_37" varchar(100) default null,
  in "Field_38" varchar(100) default null,
  in "Field_39" varchar(100) default null,
  in "Field_40" varchar(100) default null,
  in "Where_Cond" long varchar default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Dynamic_SQL_Start" long varchar;
  declare "Prod_Fieldname" varchar(100);
  set temporary option "Query_Temp_Space_Limit" = 0;
  commit work;
  set "Prod_Type" = case "UPPER"("Prod_Type")
    when 'ANY' then 'Any'
    when 'ALL' then 'Any'
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
    when 'TT' then 'TopTier'
    when 'TOPTIER' then 'TopTier'
    when 'TOP TIER' then 'TopTier'
    when 'SKY TALK SELECT' then 'Talk'
    when 'TALK' then 'Talk'
    when 'LR' then 'LR'
    when 'LINE RENTAL' then 'LR'
    when 'LINERENTAL' then 'LR'
    when 'SKY_BOX_SETS' then 'SKY_BOX_SETS'
    when 'SKY BOX SETS' then 'SKY_BOX_SETS'
    when 'BOX SETS' then 'SKY_BOX_SETS'
    when 'MS+' then 'MS+'
    when 'HD PACK' then 'HD Pack'
    when 'HD_PACK' then 'HD Pack'
    when 'SKY_KIDS' then 'SKY_KIDS'
    when 'SPOTIFY' then 'SPOTIFY'
    when 'STANDALONESURCHARGE' then 'STANDALONESURCHARGE'
    when 'STANDALONE SURCHARGE' then 'STANDALONESURCHARGE'
    when 'AUTOMIGRATION' then 'AUTOMIGRATION'
    when 'AUTO-MIGRATION' then 'AUTOMIGRATION' end;
  set "Prod_Fieldname" = case "Prod_Type"
    when 'Any' then 'Any'
    when 'DTV' then 'DTV'
    when 'Sports' then 'Sports'
    when 'Movies' then 'Movies'
    when 'Prems' then 'Prems'
    when 'TT' then 'TopTier'
    when 'MS' then 'MS'
    when 'HD' then 'HD'
    when 'BB' then 'BB'
    when 'LR' then 'LR'
    when 'Talk' then 'Talk'
    when 'SGE' then 'SGE'
    when 'SKY_BOX_SETS' then 'SKY_BOX_SETS'
    when 'MS+' then 'MS_PLUS'
    when 'HD Pack' then 'HD_Pack'
    when 'SKY_KIDS' then 'SKY_KIDS'
    when 'SPOTIFY' then 'SPOTIFY'
    when 'STANDALONESURCHARGE' then 'STANDALONE_SURCHARGE'
    when 'AUTOMIGRATION' then 'AUTOMIGRATION' end;
  set "Contract_Offer_Type" = case "lower"("Contract_Offer_Type")
    when 'contract' then 'Contract_'
    when 'promo' then 'Promo_' end;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  drop table if exists #Update_Fields;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1",
      "Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30",
      "Field_31","Field_32","Field_33","Field_34","Field_35","Field_36","Field_37","Field_38","Field_39","Field_40");
  //Select * from #Update_Fields;
  ------------------------------------------------------------------------------------------------------------
  -- Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname" || '''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Prev_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Curr_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Future_Dated_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname" || '''' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname" || '''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 3. Add columns
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ''
       || ' Alter Table ' || "Output_Table_Name" || ' Add('
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || ' varchar(255) default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || ' integer default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || ' varchar(100) default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || ' varchar(50) default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || ' decimal(20,2) default null null,' end
       || case when "LOWER"('Prev_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || ' varchar(20) default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || ' varchar(255) default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || ' integer default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || ' varchar(100) default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || ' varchar(50) default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || ' decimal(20,2) default null null,' end
       || case when "LOWER"('Curr_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || ' varchar(20) default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || ' varchar(255) default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || ' integer default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || ' varchar(100) default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || ' varchar(50) default null null,' end
       || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || ' decimal(20,2) default null null,' end
       || case when "LOWER"('_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || ' date default null null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname" || ' smallint default 0 null,' end
       || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname" || ' smallint default 0 null,' end;
    set "Dynamic_SQL" = "SUBSTR"("Dynamic_SQL",1,"LEN"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 4. Add Offers Details
  ------------------------------------------------------------------------------------------------------------
  drop table if exists "Acc_Obs_Dts";
  execute immediate 'Select distinct account_number, ' || "Obs_Dt_Field" || ' into Acc_Obs_Dts from ' || "Output_Table_Name" || '' || case when "Where_Cond" is not null then ' Where ' end || "Where_Cond" || ' ' || ';';
  commit work;
  create hg index "idx_1" on "Acc_Obs_Dts"("Account_number");
  execute immediate 'create date index idx_2 on Acc_Obs_Dts(' || "Obs_Dt_Field" || ');';
  select * into #Acc_Obs_Dts from "Acc_Obs_Dts";
  drop table if exists "Acc_Obs_Dts";
  ----------------------------------------------------------
  -- Prev Offer Details
  ----------------------------------------------------------
  set "Dynamic_SQL" = ''
     || ' Select a.account_number, '
     || '        a.' || "Obs_Dt_Field" || ', '
     || '        max(Case when b.Whole_Offer_End_Dt_Actual <= a.' || "Obs_Dt_Field" || ' then b.Whole_Offer_End_Dt_Actual end) as Prev_Offer_End_Dt,'
     || '        min(Case when a.' || "Obs_Dt_Field" || ' between b.offer_leg_start_dt_Actual and b.offer_leg_end_dt_actual - 1 then b.Intended_Offer_End_Dt end) as Curr_Offer_End_Dt,'
     || '        min(Case when b.whole_offer_created_dt <= a.' || "Obs_Dt_Field" || ' and a.' || "Obs_Dt_Field" || ' < b.Whole_offer_start_dt_Actual and b.offer_leg = 1 then b.Whole_offer_start_dt_Actual end) as Future_Dated_Offer_Start_Dt'
     || ' into #Prev_And_Curr_Offers '
     || ' FROM #Acc_Obs_Dts as a '
     || '      inner join '
     || '      CITeam.Offers_Software as b '
     || '      on a.account_number= b.account_number '
    -- || '             and b.offer_leg_start_dt_Actual <= a.' || Obs_Dt_Field || ' '
     || '             and b.activated_offer = 1 '
     || case when "Prod_Type" <> 'AUTOMIGRATION' then ' and b.OFFER_ID not in (90902,90903,90904,90905,90906,90907,90908,90909,90910) ' end
     || case when "Prod_Type" = 'Any' then ''
    when "Prod_Type" = 'AUTOMIGRATION' then ' and b.OFFER_ID in (90902,90903,90904,90905,90906,90907,90908,90909,90910) '
    when "Prod_Type" = 'Prems' then ' and (b.subscription_sub_type in (''SPORTS'',''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'TopTier' then ' and  b.subscription_sub_type = ''DTV Primary Viewing'' '
       || '      and    (upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%'') '
    when "Prod_Type" = 'Sports' then ' and (b.subscription_sub_type in (''SPORTS'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'Movies' then ' and (b.subscription_sub_type in(''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    else
      '             and b.subscription_sub_type in (' || case "Prod_Type"
      when 'DTV' then '''DTV Primary Viewing'''
      when 'MS' then '''DTV Extra Subscription'',''MS+'''
      when 'HD' then '''DTV HD'''
      when 'SGE' then '''Sky Go Extra'''
      when 'BB' then '''Broadband DSL Line'''
      when 'LR' then '''SKY TALK LINE RENTAL'''
      when 'Talk' then '''SKY TALK SELECT'''
      when 'SKY_BOX_SETS' then '''SKY_BOX_SETS'''
      when 'HD Pack' then '''HD Pack'''
      when 'SKY_KIDS' then '''SKY_KIDS'''
      when 'SPOTIFY' then '''SPOTIFY'''
      when 'STANDALONESURCHARGE' then '''STANDALONESURCHARGE''' end
       || ') '
    end
     || '             and upper(b.offer_dim_description) not like ''%PRICE PROTECTION%'' '
     || case "Contract_Offer_Type"
    when 'Contract_' then '             and upper(b.offer_dim_description) like ''%IN-CONTRACT%'' '
    when 'Promo_' then '             and upper(b.offer_dim_description) not like ''%IN-CONTRACT%'' ' end
     || case when "Where_Cond" is not null then ' where ' || "Where_Cond" end
     || ' Group by a.account_number, '
     || '        a.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #Prev_And_Curr_Offers("account_number");
  execute immediate 'create date index idx_2 on #Prev_And_Curr_Offers(' || "Obs_Dt_Field" || ')';
  create date index "idx_3" on #Prev_And_Curr_Offers("Prev_Offer_End_Dt");
  create date index "idx_4" on #Prev_And_Curr_Offers("Curr_Offer_End_Dt");
  set "Dynamic_SQL" = ''
     || ' Select a.account_number, '
     || '        a.' || "Obs_Dt_Field" || ', '
     || '        b.Subscription_Sub_Type, '
     || '        b.Offer_ID, '
     || '        b.Offer_Dim_Description, '
     || '        b.Whole_Offer_Start_Dt_Actual, '
     || '        b.Intended_Offer_End_Dt, '
     || '        b.Whole_Offer_End_Dt_Actual, '
     || '        b.Monthly_offer_amount, '
     || '        Cast(null as varchar(20)) as Offer_Bridged, '
     || '        Row_Number() Over(partition by a.account_number,a.' || "Obs_Dt_Field" || ' order by b.Whole_Offer_End_Dt_Actual desc) Offer_End_Rnk '
     || ' into #Prev_Offers '
    -- || ' FROM ' || Output_Table_Name || ' as a '
     || ' FROM #Prev_And_Curr_Offers as a '
     || '      inner join '
     || '      CITeam.Offers_Software as b '
     || '      on a.account_number= b.account_number '
     || '             and b.Whole_Offer_End_Dt_Actual = a.Prev_Offer_End_Dt '
     || '             and b.offer_leg_start_dt_Actual < a.' || "Obs_Dt_Field" || ' '
     || '             and b.Whole_offer_end_dt_Actual  <= a.' || "Obs_Dt_Field" || ' '
     || '             and b.activated_offer = 1 '
     || '             and b.Offer_leg = b.Total_Offer_Legs '
     || case when "Prod_Type" <> 'AUTOMIGRATION' then ' and b.OFFER_ID not in (90902,90903,90904,90905,90906,90907,90908,90909,90910) ' end
     || case when "Prod_Type" = 'Any' then ''
    when "Prod_Type" = 'AUTOMIGRATION' then ' and b.OFFER_ID in (90902,90903,90904,90905,90906,90907,90908,90909,90910) '
    when "Prod_Type" = 'Prems' then ' and (b.subscription_subscription_sub_type in (''SPORTS'',''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'TopTier' then ' and  b.subscription_sub_type = ''DTV Primary Viewing'' '
       || '      and    (upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%'') '
    when "Prod_Type" = 'Sports' then ' and (b.subscription_sub_type in(''SPORTS'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'Movies' then ' and (b.subscription_sub_type in(''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    else
      '             and b.subscription_sub_type in (' || case "Prod_Type"
      when 'DTV' then '''DTV Primary Viewing'''
      when 'MS' then '''DTV Extra Subscription'',''MS+'''
      when 'HD' then '''DTV HD'''
      when 'SGE' then '''Sky Go Extra'''
      when 'BB' then '''Broadband DSL Line'''
      when 'LR' then '''SKY TALK LINE RENTAL'''
      when 'Talk' then '''SKY TALK SELECT'''
      when 'SKY_BOX_SETS' then '''SKY_BOX_SETS'''
      when 'HD Pack' then '''HD Pack'''
      when 'SKY_KIDS' then '''SKY_KIDS'''
      when 'SPOTIFY' then '''SPOTIFY'''
      when 'STANDALONESURCHARGE' then '''STANDALONESURCHARGE''' end
       || ') '
    end
     || '             and upper(b.offer_dim_description) not like ''%PRICE PROTECTION%'' '
     || case "Contract_Offer_Type"
    when 'Contract_' then '             and upper(b.offer_dim_description) like ''%IN-CONTRACT%'' '
    when 'Promo_' then '             and upper(b.offer_dim_description) not like ''%IN-CONTRACT%'' ' end;
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_account_number" on #Prev_Offers("account_number");
  set "Dynamic_SQL" = 'create date index idx_obs_dt_field on #Prev_Offers(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create lf index "idx_offer_end_rnk" on #Prev_Offers("Offer_End_Rnk");
  update #Prev_Offers as "co"
    set "Offer_Bridged" = "toh"."Treatment_Type" from
    #Prev_Offers as "co"
    join "CITeam"."CQB_Treated_Offer_Hist" as "toh"
    on "toh"."account_number" = "co"."account_number"
    and "toh"."new_offer_end_dt" = "co"."Intended_Offer_End_Dt"
    and "Coalesce"("toh"."new_offer_id","toh"."current_offer_id") = "co"."offer_id";
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as Base '
     || ' SET '
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_start_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || ' =  Source.Whole_offer_start_dt_Actual,' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_intended_end_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || ' = Source.Intended_offer_end_dt,' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_actual_end_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '=source.Whole_Offer_End_Dt_Actual,' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_subscription_sub_type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '  = Source.Subscription_Sub_Type,' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_id_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '  = Source.Offer_ID,' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '  = Source.Offer_Dim_Description,' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || ' = '''' || Datediff(mm,Source.Whole_offer_start_dt_Actual,Source.Intended_offer_end_dt) || ''M'',' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || ' = Source.Monthly_offer_amount,' end
     || case when "LOWER"('prev_' || "Contract_Offer_Type" || 'offer_bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Prev_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || ' = Source.Offer_Bridged,' end;
  if "right"("Dynamic_SQL",5) <> ' SET ' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM #Prev_Offers Source '
       || ' where Base.account_number=Source.account_number '
       || '   and Base.' || "Obs_Dt_Field" || '=Source.' || "Obs_Dt_Field" || ' '
       || '   and Offer_End_Rnk = 1 ';
    execute immediate "Dynamic_SQL"
  end if;
  ----------------------------------------------------------
  -- Current Offer Details
  ----------------------------------------------------------
  set "Dynamic_SQL" = ''
     || ' Select a.account_number, '
     || '        a.' || "Obs_Dt_Field" || ', '
     || '        b.Subscription_Sub_Type, '
     || '        b.Offer_ID, '
     || '        b.Offer_Dim_Description, '
     || '        b.Whole_Offer_Start_Dt_Actual, '
     || '        b.Intended_Offer_End_Dt, '
     || '        b.Whole_Offer_End_Dt_Actual, '
     || '        b.Monthly_Offer_Amount, '
     || '        Cast(null as varchar(20)) as Offer_Bridged, '
     || '        Row_Number() Over(partition by a.account_number,a.' || "Obs_Dt_Field" || ' order by b.Intended_Offer_End_Dt) Offer_End_Rnk '
     || ' into #Curr_Offers '
     || ' FROM #Prev_And_Curr_Offers as a '
     || '      inner join '
     || '      CITeam.Offers_Software as b '
     || '      on a.account_number=b.account_number '
     || '         and b.Intended_Offer_End_Dt = a.Curr_Offer_End_Dt '
     || '         and b.Offer_Leg_Start_Dt_Actual <= a.' || "Obs_Dt_Field" || ' '
     || '         and b.Offer_Leg_End_Dt_Actual > a.' || "Obs_Dt_Field" || ' '
     || '         and b.Activated_Offer = 1 '
     || case when "Prod_Type" <> 'AUTOMIGRATION' then ' and b.OFFER_ID not in (90902,90903,90904,90905,90906,90907,90908,90909,90910) ' end
     || case when "Prod_Type" = 'Any' then ''
    when "Prod_Type" = 'AUTOMIGRATION' then ' and b.OFFER_ID in (90902,90903,90904,90905,90906,90907,90908,90909,90910) '
    when "Prod_Type" = 'Prems' then ' and (b.subscription_sub_type in (''SPORTS'',''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'TopTier' then ' and  b.subscription_sub_type = ''DTV Primary Viewing'' '
       || '      and    (upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%'') '
    when "Prod_Type" = 'Sports' then ' and (b.subscription_sub_type in(''SPORTS'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'Movies' then ' and (b.subscription_sub_type in(''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    else
      '             and b.subscription_sub_type in (' || case "Prod_Type"
      when 'DTV' then '''DTV Primary Viewing'''
      when 'MS' then '''DTV Extra Subscription'',''MS+'''
      when 'HD' then '''DTV HD'',''HD Pack'''
      when 'SGE' then '''Sky Go Extra'''
      when 'BB' then '''Broadband DSL Line'''
      when 'LR' then '''SKY TALK LINE RENTAL'''
      when 'Talk' then '''SKY TALK SELECT'''
      when 'SKY_BOX_SETS' then '''SKY_BOX_SETS'''
      when 'HD Pack' then '''HD Pack'''
      when 'SKY_KIDS' then '''SKY_KIDS'''
      when 'SPOTIFY' then '''SPOTIFY'''
      when 'STANDALONESURCHARGE' then '''STANDALONESURCHARGE''' end
       || ') '
    end
     || '        and upper(b.offer_dim_description) not like ''%PRICE PROTECTION%'' '
     || case "Contract_Offer_Type"
    when 'Contract_' then '             and upper(b.offer_dim_description) like ''%IN-CONTRACT%'' '
    when 'Promo_' then '             and upper(b.offer_dim_description) not like ''%IN-CONTRACT%'' ' end;
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_account_number" on #Curr_Offers("account_number");
  set "Dynamic_SQL" = 'create date index idx_obs_dt_field on #Curr_Offers(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create lf index "idx_offer_end_rnk" on #Curr_Offers("Offer_End_Rnk");
  update #Curr_Offers as "co"
    set "Offer_Bridged" = "toh"."Treatment_Type" from
    #Curr_Offers as "co"
    join "CITeam"."CQB_Treated_Offer_Hist" as "toh"
    on "toh"."account_number" = "co"."account_number"
    and "toh"."new_offer_end_dt" = "co"."Intended_Offer_End_Dt"
    and "Coalesce"("toh"."new_offer_id","toh"."current_offer_id") = "co"."offer_id";
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as Base '
     || ' SET '
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_start_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || ' =  Source.Whole_offer_start_dt_Actual,' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_intended_end_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || ' = Source.Intended_offer_end_dt,' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_actual_end_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '=source.Whole_Offer_End_Dt_Actual,' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_subscription_sub_type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '  = Source.Subscription_Sub_Type,' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_id_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '  = Source.Offer_ID,' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '  = Source.Offer_Dim_Description,' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || ' = '''' || Datediff(mm,Source.Whole_offer_start_dt_Actual,Source.Intended_offer_end_dt) || ''M'',' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || ' = Source.Monthly_Offer_Amount,' end
     || case when "LOWER"('curr_' || "Contract_Offer_Type" || 'offer_bridged_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Curr_' || "Contract_Offer_Type" || 'Offer_Bridged_' || "Prod_Fieldname" || ' = Source.Offer_Bridged,' end;
  if "right"("Dynamic_SQL",5) <> ' SET ' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM #Curr_Offers Source '
       || ' where Base.account_number=Source.account_number '
       || '   and Base.' || "Obs_Dt_Field" || '=Source.' || "Obs_Dt_Field" || ' '
       || '   and Offer_End_Rnk = 1 ';
    execute immediate "Dynamic_SQL"
  end if;
  ----------------------------------------------------------
  -- Future Dated Offer Deatils
  ----------------------------------------------------------
  -- SET Dynamic_SQL = ''
  -- || ' Update ' || Output_Table_Name || ' as Base '
  -- || ' SET '
  -- || CASE WHEN LOWER('Future_Dated_Offer_Start_Dt_' || Prod_Fieldname) IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN 'Future_Dated_Offer_Start_Dt_' || Prod_Fieldname || ' =  Source.Future_Dated_Offer_Start_Dt,' end
  -- ;
  -- -- Select Dynamic_SQL
  -- 
  -- If right(Dynamic_SQL,5) != ' SET ' then
  -- BEGIN
  -- Set Dynamic_SQL = substr(Dynamic_SQL,1,len(Dynamic_SQL) - 1)
  -- || ' FROM #Prev_And_Curr_Offers Source '
  -- || ' where Base.account_number=Source.account_number '
  -- || '   and Base.' || Obs_Dt_Field || '=Source.' || Obs_Dt_Field || ' '
  -- -- || '   and Offer_End_Rnk = 1 '
  -- ;
  --
  -- EXECUTE(Dynamic_SQL);
  -- END
  -- End If;
  set "Dynamic_SQL" = ''
     || ' Select a.account_number, '
     || '        a.' || "Obs_Dt_Field" || ', '
     || '        b.Subscription_Sub_Type, '
     || '        b.Offer_ID, '
     || '        b.Offer_Dim_Description, '
     || '        b.Whole_Offer_Start_Dt_Actual, '
     || '        b.Intended_Offer_End_Dt, '
     || '        b.Whole_Offer_End_Dt_Actual, '
     || '        b.Monthly_Offer_Amount, '
     || '        Row_Number() Over(partition by a.account_number,a.' || "Obs_Dt_Field" || ' order by b.Whole_Offer_Start_Dt_Actual) Offer_End_Rnk '
     || ' into #Future_Offers '
     || ' FROM #Prev_And_Curr_Offers as a '
     || '      inner join '
     || '      CITeam.Offers_Software as b '
     || '      on a.account_number=b.account_number '
     || '         and b.Whole_Offer_Start_Dt_Actual = a.Future_Dated_Offer_Start_Dt '
     || '         and b.Whole_Offer_Created_Dt <= a.' || "Obs_Dt_Field" || ' '
     || '         and b.offer_leg = 1 '
     || '         and b.Activated_Offer = 1 '
     || case when "Prod_Type" <> 'AUTOMIGRATION' then ' and b.OFFER_ID not in (90902,90903,90904,90905,90906,90907,90908,90909,90910) ' end
     || case when "Prod_Type" = 'Any' then ''
    when "Prod_Type" = 'AUTOMIGRATION' then ' and b.OFFER_ID in (90902,90903,90904,90905,90906,90907,90908,90909,90910) '
    when "Prod_Type" = 'Prems' then ' and (b.subscription_sub_type in (''SPORTS'',''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'TopTier' then ' and  b.subscription_sub_type = ''DTV Primary Viewing'' '
       || '      and    (upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%'') '
    when "Prod_Type" = 'Sports' then ' and (b.subscription_sub_type in(''SPORTS'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'Movies' then ' and (b.subscription_sub_type in(''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    else
      '             and b.subscription_sub_type in (' || case "Prod_Type"
      when 'DTV' then '''DTV Primary Viewing'''
      when 'MS' then '''DTV Extra Subscription'',''MS+'''
      when 'HD' then '''DTV HD'',''HD Pack'''
      when 'SGE' then '''Sky Go Extra'''
      when 'BB' then '''Broadband DSL Line'''
      when 'LR' then '''SKY TALK LINE RENTAL'''
      when 'Talk' then '''SKY TALK SELECT'''
      when 'SKY_BOX_SETS' then '''SKY_BOX_SETS'''
      when 'HD Pack' then '''HD Pack'''
      when 'SKY_KIDS' then '''SKY_KIDS'''
      when 'SPOTIFY' then '''SPOTIFY'''
      when 'STANDALONESURCHARGE' then '''STANDALONESURCHARGE''' end
       || ') '
    end
     || '        and upper(b.offer_dim_description) not like ''%PRICE PROTECTION%'' '
     || case "Contract_Offer_Type"
    when 'Contract_' then '             and upper(b.offer_dim_description) like ''%IN-CONTRACT%'' '
    when 'Promo_' then '             and upper(b.offer_dim_description) not like ''%IN-CONTRACT%'' ' end;
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_account_number" on #Future_Offers("account_number");
  set "Dynamic_SQL" = 'create date index idx_obs_dt_field on #Future_Offers(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create lf index "idx_offer_end_rnk" on #Future_Offers("Offer_End_Rnk");
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as Base '
     || ' SET '
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'offer_start_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Start_Dt_' || "Prod_Fieldname" || ' =  Source.Whole_offer_start_dt_Actual,' end
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'offer_intended_end_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Intended_end_Dt_' || "Prod_Fieldname" || ' = Source.Intended_offer_end_dt,' end
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'offer_actual_end_dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Actual_End_Dt_' || "Prod_Fieldname" || '=source.Whole_Offer_End_Dt_Actual,' end
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'Offer_subscription_sub_type_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Subscription_Sub_Type_' || "Prod_Fieldname" || '  = Source.Subscription_Sub_Type,' end
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'offer_id_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_ID_' || "Prod_Fieldname" || '  = Source.Offer_ID,' end
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'offer_description_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Description_' || "Prod_Fieldname" || '  = Source.Offer_Dim_Description,' end
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'offer_length_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Length_' || "Prod_Fieldname" || ' = '''' || Datediff(mm,Source.Whole_offer_start_dt_Actual,Source.Intended_offer_end_dt) || ''M'',' end
     || case when "LOWER"('Future_Dated_' || "Contract_Offer_Type" || 'offer_amount_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Future_Dated_' || "Contract_Offer_Type" || 'Offer_Amount_' || "Prod_Fieldname" || ' = Source.Monthly_Offer_Amount,' end;
  if "right"("Dynamic_SQL",5) <> ' SET ' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM #Future_Offers Source '
       || ' where Base.account_number=Source.account_number '
       || '   and Base.' || "Obs_Dt_Field" || '=Source.' || "Obs_Dt_Field" || ' '
       || '   and Offer_End_Rnk = 1 ';
    execute immediate "Dynamic_SQL"
  end if;
  ----------------------------------------------------------
  -- Offers Applied
  ----------------------------------------------------------
  set "Dynamic_SQL" = ''
     || ' Select a.account_number, '
     || '        a.' || "Obs_Dt_Field" || ', '
     || 'Min(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt <= a.' || "Obs_Dt_Field" || ' THEN b.Whole_Offer_Created_Dt '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt <= a.' || "Obs_Dt_Field" || ' THEN b.Offer_Leg_Created_Dt '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual <= a.' || "Obs_Dt_Field" || ' THEN b.Whole_Offer_Start_Dt_Actual '
    end
     || ' END) as _1st_Offer_Applied,'
     || 'Max(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt <= a.' || "Obs_Dt_Field" || ' THEN b.Whole_Offer_Created_Dt '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt <= a.' || "Obs_Dt_Field" || ' THEN b.Offer_Leg_Created_Dt '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual <= a.' || "Obs_Dt_Field" || ' THEN b.Whole_Offer_Start_Dt_Actual '
    end
     || ' END) as Last_Offer_Applied,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt = a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt = a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual = a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Lst_1D,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between a.' || "Obs_Dt_Field" || ' - 6 and a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between a.' || "Obs_Dt_Field" || ' - 6 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between a.' || "Obs_Dt_Field" || ' - 6 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Lst_7D,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between a.' || "Obs_Dt_Field" || ' - 29 and a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between a.' || "Obs_Dt_Field" || ' - 29 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between a.' || "Obs_Dt_Field" || ' - 29 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Lst_30D,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between a.' || "Obs_Dt_Field" || ' - 89 and a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between a.' || "Obs_Dt_Field" || ' - 89 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between a.' || "Obs_Dt_Field" || ' - 89 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Lst_90D,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between dateadd(mm,-12,a.' || "Obs_Dt_Field" || ') + 1  and a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between dateadd(mm,-12,a.' || "Obs_Dt_Field" || ') + 1 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between dateadd(mm,-12,a.' || "Obs_Dt_Field" || ') + 1 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Lst_12M,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between dateadd(mm,-24,a.' || "Obs_Dt_Field" || ') + 1  and a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between dateadd(mm,-24,a.' || "Obs_Dt_Field" || ') + 1 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between dateadd(mm,-24,a.' || "Obs_Dt_Field" || ') + 1 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Lst_24M,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between dateadd(mm,-36,a.' || "Obs_Dt_Field" || ') + 1  and a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between dateadd(mm,-36,a.' || "Obs_Dt_Field" || ') + 1 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between dateadd(mm,-36,a.' || "Obs_Dt_Field" || ') + 1 and a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Lst_36M,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt <= a.' || "Obs_Dt_Field" || ' THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt <= a.' || "Obs_Dt_Field" || ' THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual <= a.' || "Obs_Dt_Field" || ' THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Ever,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between a.' || "Obs_Dt_Field" || ' + 1 and a.' || "Obs_Dt_Field" || ' + 7 THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between a.' || "Obs_Dt_Field" || ' + 1 and a.' || "Obs_Dt_Field" || ' + 7 THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between a.' || "Obs_Dt_Field" || ' + 1 and a.' || "Obs_Dt_Field" || ' + 7 THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Next_7D,'
     || 'Sum(CASE ' || case when "lower"("Offer_State") = 'ordered' then ' WHEN b.offer_leg = 1 and b.Whole_Offer_Created_Dt between a.' || "Obs_Dt_Field" || ' + 1 and a.' || "Obs_Dt_Field" || ' + 30 THEN 1 '
       || ' WHEN b.offer_leg > 1 and b.Offer_Leg_Created_Dt between a.' || "Obs_Dt_Field" || ' + 1 and a.' || "Obs_Dt_Field" || ' + 30 THEN 1 '
    else ' WHEN b.Whole_Offer_Start_Dt_Actual between a.' || "Obs_Dt_Field" || ' + 1 and a.' || "Obs_Dt_Field" || ' + 30 THEN 1 '
    end
     || ' ELSE 0 '
     || ' END) as Offers_Applied_Next_30D'
     || ' into Offers_Applied '
     || ' FROM ' || "Output_Table_Name" || ' as a '
     || '      inner join '
     || '      CITeam.Offers_Software as b '
     || '      on a.account_number=b.account_number '
     || case "Offer_Applied_Type" when 'New' then '         and b.offer_leg = 1 and b.src_system_id = b.first_portfolio_offer_id '
    when 'Autotransferred' then '         and (b.offer_leg > 1 or (b.offer_leg = 1 and b.src_system_id != b.first_portfolio_offer_id) )' /*2nd condition for unbundled offers*/
    else ''
    end
     || case when "lower"("Offer_State") = 'ordered' then '         and ((b.offer_leg = 1 and b.Whole_Offer_Created_Dt <= a.' || "Obs_Dt_Field" || ' + 30) '
       || '              or  (b.offer_leg > 1 and b.Offer_Leg_Created_Dt <= a.' || "Obs_Dt_Field" || ' + 30)) '
    else '         and b.Activated_Offer = 1 '
       || '         and b.Whole_Offer_Start_Dt_Actual <= a.' || "Obs_Dt_Field" || ' + 30 '
    end
     || case when "Prod_Type" <> 'AUTOMIGRATION' then ' and b.OFFER_ID not in (90902,90903,90904,90905,90906,90907,90908,90909,90910) ' end
     || case when "Prod_Type" = 'Any' then ''
    when "Prod_Type" = 'AUTOMIGRATION' then ' and b.OFFER_ID in (90902,90903,90904,90905,90906,90907,90908,90909,90910) '
    when "Prod_Type" = 'Prems' then ' and (b.subscription_sub_type in (''SPORTS'',''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'TopTier' then ' and  b.subscription_sub_type = ''DTV Primary Viewing'' '
       || '      and    (upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%'') '
    when "Prod_Type" = 'Sports' then ' and (b.subscription_sub_type in(''SPORTS'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''SPORTS'') '
       || '      and (   upper(offer_dim_description) like ''%SPORTS%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    when "Prod_Type" = 'Movies' then ' and (b.subscription_sub_type in(''CINEMA'') '
       || '      or (b.subscription_sub_type in (''DTV Primary Viewing'',''CINEMA'') '
       || '      and (   upper(offer_dim_description) like ''%MOVIES%'' '
       || '             or upper(offer_dim_description) like ''%TOPTIER%'' '
       || '             or upper(offer_dim_description) like ''%TOP TIER%''))) '
    else
      '             and b.subscription_sub_type in (' || case "Prod_Type"
      when 'DTV' then '''DTV Primary Viewing'''
      when 'MS' then '''DTV Extra Subscription'',''MS+'''
      when 'HD' then '''DTV HD'',''HD Pack'''
      when 'SGE' then '''Sky Go Extra'''
      when 'BB' then '''Broadband DSL Line'''
      when 'LR' then '''SKY TALK LINE RENTAL'''
      when 'Talk' then '''SKY TALK SELECT'''
      when 'SKY_BOX_SETS' then '''SKY_BOX_SETS'''
      when 'HD Pack' then '''HD Pack'''
      when 'SKY_KIDS' then '''SKY_KIDS'''
      when 'SPOTIFY' then '''SPOTIFY'''
      when 'STANDALONESURCHARGE' then '''STANDALONESURCHARGE''' end
       || ') '
    end
     || '        and upper(b.offer_dim_description) not like ''%PRICE PROTECTION%'' '
     || case "Contract_Offer_Type"
    when 'Contract_' then '             and upper(b.offer_dim_description) like ''%CONTRACT%'' '
    when 'Promo_' then '             and upper(b.offer_dim_description) not like ''%CONTRACT%'' ' end
     || case when "Where_Cond" is not null then ' where ' || "Where_Cond" end
     || ' Group by a.account_number, '
     || '          a.' || "Obs_Dt_Field" || ' ';
  drop table if exists "Offers_Applied";
  execute immediate "Dynamic_SQL";
  drop table if exists #Offers_Applied;
  select * into #Offers_Applied from "Offers_Applied";
  drop table if exists "Offers_Applied";
  commit work;
  create hg index "idx_account_number" on #Offers_Applied("account_number");
  set "Dynamic_SQL" = 'create date index idx_obs_dt_field on #Offers_Applied(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as Base '
     || ' SET '
     || case when "LOWER"('_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || ' = source._1st_Offer_Applied,' end
     || case when "LOWER"('Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Last_' || "Contract_Offer_Type" || 'Offer_Applied_Dt_' || "Prod_Fieldname" || ' = source.Last_Offer_Applied,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_1D_' || "Prod_Fieldname" || ' = source.Offers_Applied_Lst_1D,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_7D_' || "Prod_Fieldname" || ' = source.Offers_Applied_Lst_7D,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_30D_' || "Prod_Fieldname" || ' = source.Offers_Applied_Lst_30D,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_90D_' || "Prod_Fieldname" || ' = source.Offers_Applied_Lst_90D,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_12M_' || "Prod_Fieldname" || ' = source.Offers_Applied_Lst_12M,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_24M_' || "Prod_Fieldname" || ' = source.Offers_Applied_Lst_24M,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Lst_36M_' || "Prod_Fieldname" || ' = source.Offers_Applied_Lst_36M,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Ever_' || "Prod_Fieldname" || ' = source.Offers_Applied_Ever,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Next_7D_' || "Prod_Fieldname" || ' = source.Offers_Applied_Next_7D,' end
     || case when "LOWER"('' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname") = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then '' || "Contract_Offer_Type" || 'Offers_Applied_Next_30D_' || "Prod_Fieldname" || ' = source.Offers_Applied_Next_30D,' end;
  if "right"("Dynamic_SQL",5) <> ' SET ' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM '
       || "Output_Table_Name" || ' as Base '
       || ' inner join '
       || ' #Offers_Applied Source '
       || ' on Base.account_number=Source.account_number '
       || '   and Base.' || "Obs_Dt_Field" || '=Source.' || "Obs_Dt_Field" || ' ';
    execute immediate "Dynamic_SQL"
  --
  /* ======================================== Queries for Testing ========================================
1. Create base
CALL Decisioning_procs.Create_Model_Base('sti18.Offers_Proc_Test', 'DTV', '2017-08-01');

2. Add all fields initially
CALL STI18.Add_Offers_Software('Offers_Proc_Test', 'Base_Dt', 'DTV', 'Drop and Replace')

3. Test few fields
CALL STI18.Add_Offers_Software('DTV_PL_Entries_PROC', 'Base_Dt', 'PREMS', 'Drop and Replace', 'Offers_Applied_Lst_24Hrs_Prems');

4. Test queries
SELECT TOP 100 * FROM Offers_Proc_Test;
====================================================================================================== */
  end if
end
