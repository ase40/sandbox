create procedure "Decisioning_Procs"."Add_Crossgrades_DTV"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
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
  in "Field_30" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Product_Type" varchar(50);
  declare "Target_Table" varchar(50);
  declare "Dynamic_SQL_Start" long varchar;
  set "Product_Type" = 'DTV';
  set "Target_Table" = 'Decisioning.Crossgrades_DTV';
  set temporary option "Query_Temp_Space_Limit" = 0;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30");
  -- Set Addition_Val = 'NEW CUSTOMER ACTIVATION';
  -- Set Existing_Activation_Val = 'EXISTING CUSTOMER ACTIVATION';
  -- Set Prod_Reinstate_Val = 'PRODUCT REACTIVATION';
  -- Set Plat_Reinstate_Val = 'PLATFORM REINSTATE';
  ------------------------------------------------------------------------------------------------------------
  -- 2. Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL_Start"
     || case when "LOWER"("Product_Type" || '_1st_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_Crossgrade_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Crossgrade_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Crossgrade_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Pack_Removed') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Crossgrade_Pack_Removed''' end
     || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Pack_Added') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Crossgrade_Pack_Added''' end
     || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Pack_Removed') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Crossgrade_Pack_Removed''' end
     || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Pack_Added') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Crossgrade_Pack_Added''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_Ever''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Up_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_Ever''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Spin_Down_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_Ever''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Base_Prod_Regrade_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_Ever''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Up_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Up_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_Ever''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Spin_Down_In_Next_30D''' end
     || ')';
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    execute immediate "Dynamic_SQL"
  end if;
  -- SELECT (Dynamic_SQL);
  ------------------------------------------------------------------------------------------------------------
  -- 3. Add columns
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ''
       || ' ALTER TABLE ' || "Output_Table_Name" || ' ADD('
      -- || CASE WHEN LOWER(Product_Type || '_Active') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN  Product_Type || '_Active tinyint default 0,' END
      -- || CASE WHEN LOWER(Product_Type || '_Status_Code') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN  Product_Type || '_Status_Code varchar(10) default null,' END
      -- || CASE WHEN LOWER(Product_Type || '_Product_Holding') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN  Product_Type || '_Product_Holding varchar(80) default null,' END
       || case when "LOWER"("Product_Type" || '_1st_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Crossgrade_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Crossgrade_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Crossgrade_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Pack_Removed') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Crossgrade_Pack_Removed varchar(100) default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Pack_Added') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Crossgrade_Pack_Added varchar(100) default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Pack_Removed') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Crossgrade_Pack_Removed varchar(100) default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Pack_Added') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Crossgrade_Pack_Added varchar(100) default null null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Up_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Base_Prod_Regrade_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Up_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Next_30D tinyint default 0 null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 4. Select columns and insert into Temp table
  set "Dynamic_SQL" = 'DROP TABLE IF EXISTS #Prod_CG';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', '
    -- || ' trgt.Activation AS _Active, '
    -- || ' trgt.Status_Code AS _Status_Code, '
    -- || ' trgt.Product_Holding AS _Product_Holding, '
     || ' MIN(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _1st_Crossgrade_Dt, '
     || ' MAX(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _Last_Crossgrade_Dt, '
     || ' MIN(Case when trgt.event_dt > base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _Next_Crossgrade_Dt, '
     || 'Cast(null as varchar(100)) as _Last_Crossgrade_Pack_Removed, '
     || 'Cast(null as varchar(100)) as _Last_Crossgrade_Pack_Added, '
     || 'Cast(null as varchar(100)) as _Next_Crossgrade_Pack_Removed, '
     || 'Cast(null as varchar(100)) as _Next_Crossgrade_Pack_Added, '
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _Base_Prod_Spin_Up_In_Last_1D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Up_In_Last_30D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Up_In_Last_90D ,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Up_In_Last_180D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Up_In_Last_1Yr,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Up_In_Last_3Yr,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Up_In_Last_5Yr,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Up_Ever, '
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Base_Prod_Spin_Up_In_Next_7D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Base_Prod_Spin_Up_In_Next_30D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _Base_Prod_Spin_Down_In_Last_1D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Down_In_Last_30D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Down_In_Last_90D ,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Down_In_Last_180D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Down_In_Last_1Yr,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Down_In_Last_3Yr,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Down_In_Last_5Yr,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Spin_Down_Ever, '
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Base_Prod_Spin_Down_In_Next_7D,'
     || ' sum(Case when trgt.Base_Prod_Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Base_Prod_Spin_Down_In_Next_30D,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _Base_Prod_Regrade_In_Last_1D,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Regrade_In_Last_30D,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Regrade_In_Last_90D ,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Regrade_In_Last_180D,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Regrade_In_Last_1Yr,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Regrade_In_Last_3Yr,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Regrade_In_Last_5Yr,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Base_Prod_Regrade_Ever, '
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Base_Prod_Regrade_In_Next_7D,'
     || ' sum(Case when trgt.Base_Prod_Regrade > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Base_Prod_Regrade_In_Next_30D,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _Spin_Up_In_Last_1D,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Up_In_Last_30D,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Up_In_Last_90D ,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Up_In_Last_180D,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Up_In_Last_1Yr,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Up_In_Last_3Yr,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Up_In_Last_5Yr,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Up_Ever, '
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Spin_Up_In_Next_7D,'
     || ' sum(Case when trgt.Spin_Up > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Spin_Up_In_Next_30D,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _Spin_Down_In_Last_1D,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Down_In_Last_30D,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Down_In_Last_90D ,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Down_In_Last_180D,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Down_In_Last_1Yr,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Down_In_Last_3Yr,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Down_In_Last_5Yr,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Spin_Down_Ever, '
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Spin_Down_In_Next_7D,'
     || ' sum(Case when trgt.Spin_Down > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Spin_Down_In_Next_30D'
     || ' INTO #Prod_CG '
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
    //|| '            AND Trgt.event_dt <= Base.' || Obs_Dt_Field || ' + 30 '
     || ' GROUP BY base.account_number,base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #Prod_CG("Account_Number");
  execute immediate 'Create date index idx_2 on #Prod_CG(' || "Obs_Dt_Field" || ')';
  create date index "idx_3" on #Prod_CG("_1st_Crossgrade_Dt");
  update #Prod_CG as "base"
    set "_Last_Crossgrade_Pack_Removed" = "cg"."Base_Product_Holding_SoD",
    "_Last_Crossgrade_Pack_Added" = "cg"."Base_Product_Holding_EoD" from
    "Decisioning"."Crossgrades_DTV" as "cg"
    where "cg"."account_number" = "base"."account_number"
    and "cg"."event_dt" = "base"."_Last_Crossgrade_Dt";
  update #Prod_CG as "base"
    set "_Next_Crossgrade_Pack_Removed" = "cg"."Base_Product_Holding_SoD",
    "_Next_Crossgrade_Pack_Added" = "cg"."Base_Product_Holding_EoD" from
    "Decisioning"."Crossgrades_DTV" as "cg"
    where "cg"."account_number" = "base"."account_number"
    and "cg"."event_dt" = "base"."_Next_Crossgrade_Dt";
  ------------------------------------------------------------------------------------------------------------
  -- 5. Update output table
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
    -- ||   Product_Type || '_Status_Code   = trgt._Status_Code, '
    -- ||   Product_Type || '_Active   = trgt._Active, '
    -- ||   Product_Type || '_Product_Holding  = trgt._Product_Holding, '
     || case when "LOWER"("Product_Type" || '_1st_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Crossgrade_Dt   = trgt._1st_Crossgrade_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Crossgrade_Dt   = trgt._Last_Crossgrade_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Crossgrade_Dt   = trgt._Next_Crossgrade_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Pack_Removed') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Crossgrade_Pack_Removed = trgt._Last_Crossgrade_Pack_Removed,' end
     || case when "LOWER"("Product_Type" || '_Last_Crossgrade_Pack_Added') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Crossgrade_Pack_Added  = trgt._Last_Crossgrade_Pack_Added,' end
     || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Pack_Removed') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Crossgrade_Pack_Removed = trgt._Next_Crossgrade_Pack_Removed,' end
     || case when "LOWER"("Product_Type" || '_Next_Crossgrade_Pack_Added') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Crossgrade_Pack_Added  = trgt._Next_Crossgrade_Pack_Added,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_1D   = trgt._Base_Prod_Spin_Up_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_30D   = trgt._Base_Prod_Spin_Up_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_90D   = trgt._Base_Prod_Spin_Up_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_180D  = trgt._Base_Prod_Spin_Up_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_1Yr   = trgt._Base_Prod_Spin_Up_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_3Yr   = trgt._Base_Prod_Spin_Up_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Last_5Yr   = trgt._Base_Prod_Spin_Up_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_Ever   = trgt._Base_Prod_Spin_Up_Ever,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Next_7D   = trgt._Base_Prod_Spin_Up_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Up_In_Next_30D   = trgt._Base_Prod_Spin_Up_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_1D   = trgt._Base_Prod_Spin_Down_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_30D   = trgt._Base_Prod_Spin_Down_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_90D   = trgt._Base_Prod_Spin_Down_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_180D  = trgt._Base_Prod_Spin_Down_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_1Yr   = trgt._Base_Prod_Spin_Down_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_3Yr   = trgt._Base_Prod_Spin_Down_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Last_5Yr   = trgt._Base_Prod_Spin_Down_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_Ever   = trgt._Base_Prod_Spin_Down_Ever,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Next_7D   = trgt._Base_Prod_Spin_Down_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Spin_Down_In_Next_30D   = trgt._Base_Prod_Spin_Down_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_1D   = trgt._Base_Prod_Regrade_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_30D   = trgt._Base_Prod_Regrade_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_90D   = trgt._Base_Prod_Regrade_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_180D  = trgt._Base_Prod_Regrade_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_1Yr   = trgt._Base_Prod_Regrade_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_3Yr   = trgt._Base_Prod_Regrade_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Last_5Yr   = trgt._Base_Prod_Regrade_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_Ever   = trgt._Base_Prod_Regrade_Ever,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Next_7D   = trgt._Base_Prod_Regrade_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Base_Prod_Regrade_In_Next_30D   = trgt._Base_Prod_Regrade_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_1D   = trgt._Spin_Up_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_30D   = trgt._Spin_Up_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_90D   = trgt._Spin_Up_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_180D  = trgt._Spin_Up_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_1Yr   = trgt._Spin_Up_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_3Yr   = trgt._Spin_Up_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Last_5Yr   = trgt._Spin_Up_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_Ever   = trgt._Spin_Up_Ever,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Next_7D   = trgt._Spin_Up_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Up_In_Next_30D   = trgt._Spin_Up_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_1D   = trgt._Spin_Down_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_30D   = trgt._Spin_Down_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_90D   = trgt._Spin_Down_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_180D  = trgt._Spin_Down_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_1Yr   = trgt._Spin_Down_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_3Yr   = trgt._Spin_Down_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Last_5Yr   = trgt._Spin_Down_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_Ever   = trgt._Spin_Down_Ever,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Next_7D   = trgt._Spin_Down_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Spin_Down_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Spin_Down_In_Next_30D   = trgt._Spin_Down_In_Next_30D,' end;
  if "Right"("Dynamic_SQL",1) = ',' then
    execute immediate "Substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Prod_CG as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
  end if
end
