create procedure "Decisioning_Procs"."Add_Churn_DTV"( 
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
  set "Target_Table" = 'CITeam.Churn_DTV';
  -- SELECT TOP 100 * FROM Decisioning.Churn_DTV;
  set temporary option "Query_Temp_Space_Limit" = 0;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30");
  ------------------------------------------------------------------------------------------------------------
  -- 2. Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL_Start"
     || case when "LOWER"("Product_Type" || '_1st_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_1st_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_CusCan_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_CusCan_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_CusCan_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_1st_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_SysCan_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_SysCan_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_SysCan_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_Ever''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_Ever''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_CusCan_Churns_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_Ever''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SysCan_Churns_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_Ever''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Cancellations_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_Ever''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SameDayCancels_In_Next_30D''' end
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
      -- || CASE WHEN LOWER(Product_Type || '_Active') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN Product_Type || '_Active tinyint default 0,' END
      -- || CASE WHEN LOWER(Product_Type || '_Status_Code') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN Product_Type || '_Status_Code varchar(10) default null,' END
      -- || CASE WHEN LOWER(Product_Type || '_Product_Holding') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN Product_Type || '_Product_Holding varchar(80) default null,' END
       || case when "LOWER"("Product_Type" || '_1st_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_1st_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_CusCan_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_CusCan_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_CusCan_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_1st_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_SysCan_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_SysCan_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_SysCan_Churn_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_7D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_30D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_90D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_180D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_3Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_5Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_Ever smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_7D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_30D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_1D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_7D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_30D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_90D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_180D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_1Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_3Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_5Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_Ever smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Next_7D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Next_30D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_1D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_7D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_30D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_90D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_180D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_1Yr smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_3Yr smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_5Yr smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_Ever smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Next_7D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Next_30D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_1D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_7D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_30D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_90D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_180D smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_1Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_3Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_5Yr smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_Ever smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Next_7D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Next_30D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_1D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_7D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_30D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_90D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_180D smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_1Yr smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_3Yr smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_5Yr smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_Ever smallint default 0 null, ' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Next_7D  smallint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Next_30D  smallint default 0 null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 4. Select columns and insert into Temp table
  execute immediate 'Select distinct account_number, ' || "Obs_Dt_Field" || ' into #Acc_Obs_Dts from ' || "Output_Table_Name" || ';';
  commit work;
  create hg index "idx_1" on #Acc_Obs_Dts("Account_number");
  execute immediate 'create date index idx_2 on #Acc_Obs_Dts(' || "Obs_Dt_Field" || ');';
  set "Dynamic_SQL" = 'DROP TABLE IF EXISTS #Prod_Churn';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number, base.' || "Obs_Dt_Field" || ', '
     || ' min(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _1st_CusCan_Churn_Dt, '
     || ' max(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _Last_CusCan_Churn_Dt, '
     || ' min(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt > base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _Next_CusCan_Churn_Dt, '
     || ' min(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _1st_SysCan_Churn_Dt, '
     || ' max(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _Last_SysCan_Churn_Dt, '
     || ' min(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt > base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _Next_SysCan_Churn_Dt, '
     || ' min(Case when (trgt.SC_Gross_Termination > 0 or trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _1st_Churn_Dt, '
     || ' max(Case when (trgt.SC_Gross_Termination > 0 or trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _Last_Churn_Dt, '
     || ' min(Case when (trgt.SC_Gross_Termination > 0 or trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt > base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _Next_Churn_Dt, '
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and CAST(trgt.event_dt AS DATE) = CAST(base.' || "Obs_Dt_Field" || ' - 1 AS DATE) then 1 else 0 end) as _Churns_In_Last_1D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_7D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_30D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_90D ,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_180D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_1Yr,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_3Yr,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_5Yr,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_Ever, '
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Churns_In_Next_7D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0 or trgt.SC_Gross_Termination > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Churns_In_Next_30D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and CAST(trgt.event_dt AS DATE) = CAST(base.' || "Obs_Dt_Field" || ' - 1 AS DATE) then 1 else 0 end) as _CusCan_Churns_In_Last_1D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_In_Last_7D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_In_Last_30D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_In_Last_90D ,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_In_Last_180D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_In_Last_1Yr,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_In_Last_3Yr,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_In_Last_5Yr,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _CusCan_Churns_Ever, '
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _CusCan_Churns_In_Next_7D,'
     || ' sum(Case when (trgt.PO_Same_Day_Cancel > 0 or trgt.PO_Cancellation > 0) and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _CusCan_Churns_In_Next_30D,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and CAST(trgt.event_dt AS DATE) = CAST(base.' || "Obs_Dt_Field" || ' - 1 AS DATE) then 1 else 0 end) as _SysCan_Churns_In_Last_1D,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_In_Last_7D,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_In_Last_30D,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_In_Last_90D,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_In_Last_180D,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_In_Last_1Yr,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_In_Last_3Yr,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_In_Last_5Yr,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SysCan_Churns_Ever, '
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _SysCan_Churns_In_Next_7D,'
     || ' sum(Case when trgt.SC_Gross_Termination > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _SysCan_Churns_In_Next_30D,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and CAST(trgt.event_dt AS DATE) = CAST(base.' || "Obs_Dt_Field" || ' - 1 AS DATE) then 1 else 0 end) as _PO_Cancellations_In_Last_1D,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_In_Last_7D,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_In_Last_30D,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_In_Last_90D ,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_In_Last_180D,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_In_Last_1Yr,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_In_Last_3Yr,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_In_Last_5Yr,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _PO_Cancellations_Ever, '
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _PO_Cancellations_In_Next_7D,'
     || ' sum(Case when trgt.PO_Cancellation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _PO_Cancellations_In_Next_30D,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and CAST(trgt.event_dt AS DATE) = CAST(base.' || "Obs_Dt_Field" || ' - 1 AS DATE) then 1 else 0 end) as _SameDayCancels_In_Last_1D,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_In_Last_7D,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_In_Last_30D,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_In_Last_90D ,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_In_Last_180D,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_In_Last_1Yr,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_In_Last_3Yr,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_In_Last_5Yr,'
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _SameDayCancels_Ever, '
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _SameDayCancels_In_Next_7D, '
     || ' sum(Case when trgt.PO_Same_Day_Cancel > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _SameDayCancels_In_Next_30D '
     || ' INTO #Prod_Churn '
     || ' FROM #Acc_Obs_Dts as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || '            AND Trgt.event_dt <= Base.' || "Obs_Dt_Field" || ' + 30 '
     || ' GROUP BY base.account_number, base.' || "Obs_Dt_Field" || ' ';
  execute immediate "Dynamic_SQL";
  ------------------------------------------------------------------------------------------------------------
  -- 5. Update output table
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_1st_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_CusCan_Churn_Dt   = trgt._1st_CusCan_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_CusCan_Churn_Dt  = trgt._Last_CusCan_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_CusCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_CusCan_Churn_Dt  = trgt._Next_CusCan_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_1st_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_SysCan_Churn_Dt   = trgt._1st_SysCan_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_SysCan_Churn_Dt  = trgt._Last_SysCan_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_SysCan_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_SysCan_Churn_Dt  = trgt._Last_SysCan_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_1st_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Churn_Dt   = trgt._1st_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Churn_Dt  = trgt._Last_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Dt  = trgt._Next_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1D   = trgt._Churns_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_7D   = trgt._Churns_In_Last_7D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_30D   = trgt._Churns_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_90D   = trgt._Churns_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_180D  = trgt._Churns_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1Yr   = trgt._Churns_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_3Yr   = trgt._Churns_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_5Yr   = trgt._Churns_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_Ever = trgt._Churns_Ever,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_7D   = trgt._Churns_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_30D   = trgt._Churns_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_1D   = trgt._CusCan_Churns_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_7D   = trgt._CusCan_Churns_In_Last_7D,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_30D   = trgt._CusCan_Churns_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_90D   = trgt._CusCan_Churns_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_180D  = trgt._CusCan_Churns_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_1Yr   = trgt._CusCan_Churns_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_3Yr   = trgt._CusCan_Churns_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Last_5Yr   = trgt._CusCan_Churns_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_Ever = trgt._CusCan_Churns_Ever,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Next_7D   = trgt._CusCan_Churns_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_CusCan_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_CusCan_Churns_In_Next_30D   = trgt._CusCan_Churns_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_1D   = trgt._SysCan_Churns_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_7D   = trgt._SysCan_Churns_In_Last_7D,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_30D   = trgt._SysCan_Churns_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_90D   = trgt._SysCan_Churns_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_180D   = trgt._SysCan_Churns_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_1Yr   = trgt._SysCan_Churns_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_3Yr   = trgt._SysCan_Churns_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Last_5Yr   = trgt._SysCan_Churns_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_Ever = trgt._SysCan_Churns_Ever,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Next_7D   = trgt._SysCan_Churns_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_SysCan_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SysCan_Churns_In_Next_30D   = trgt._SysCan_Churns_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_1D   = trgt._PO_Cancellations_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_7D   = trgt._PO_Cancellations_In_Last_7D,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_30D   = trgt._PO_Cancellations_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_90D   = trgt._PO_Cancellations_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_180D  = trgt._PO_Cancellations_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_1Yr   = trgt._PO_Cancellations_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_3Yr   = trgt._PO_Cancellations_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Last_5Yr   = trgt._PO_Cancellations_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_Ever = trgt._PO_Cancellations_Ever,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Next_7D   = trgt._PO_Cancellations_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_PO_Cancellations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Cancellations_In_Next_30D  = trgt._PO_Cancellations_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_1D   = trgt._SameDayCancels_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_7D   = trgt._SameDayCancels_In_Last_7D,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_30D   = trgt._SameDayCancels_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_90D   = trgt._SameDayCancels_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_180D   = trgt._SameDayCancels_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_1Yr   = trgt._SameDayCancels_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_3Yr   = trgt._SameDayCancels_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Last_5Yr   = trgt._SameDayCancels_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_Ever = trgt._SameDayCancels_Ever,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Next_7D   = trgt._SameDayCancels_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_SameDayCancels_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SameDayCancels_In_Next_30D   = trgt._SameDayCancels_In_Next_30D,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Prod_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' ';
    execute immediate "Dynamic_SQL"
  ------------------------------------------------------------------------------------------------------------
  -- 6. Update output table for Churn Dates
  -- SET Dynamic_SQL =
  --    ' SELECT base.account_number,base.' || Obs_Dt_Field || ', '
  -- || ' MIN(event_dt) as _1st_Churn_Dt, MAX(event_dt) as _Last_Churn_Dt '
  -- || ' INTO #Prod_Churn_Dates '
  -- || ' FROM ' || Output_Table_Name || ' as base '
  -- || '        inner join '
  -- ||          Target_Table || ' as Trgt '
  -- || '        on Trgt.account_number = base.account_number '
  -- || '            and Trgt.event_dt <= Base.' || Obs_Dt_Field || ' '
  -- || ' GROUP BY base.account_number,base.' || Obs_Dt_Field || ' ';
  -- 
  -- EXECUTE(Dynamic_SQL);
  -- 
  -- COMMIT;
  -- CREATE hg INDEX idx_1 ON #Prod_Churn_Dates(account_number);
  -- SET Dynamic_SQL = 'CREATE lf INDEX idx_2 ON #Prod_Churn_Dates(' || Obs_Dt_Field || ')';
  -- EXECUTE(Dynamic_SQL);
  -- 
  -- 
  -- SET Dynamic_SQL =
  --    ' UPDATE ' || Output_Table_Name || ' as base '
  -- || ' SET '
  -- || CASE WHEN LOWER(Product_Type || '_1st_Churn_Dt') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN  Product_Type || '_1st_Churn_Dt =  trgt._1st_Churn_Dt,' END
  -- || CASE WHEN LOWER(Product_Type || '_Last_Churn_Dt') IN (SELECT LOWER(update_fields) FROM #update_fields) OR field_1 IS NULL THEN  Product_Type || '_Last_Churn_Dt = trgt._Last_Churn_Dt,' END
  -- ;
  -- 
  -- If right(Dynamic_SQL,1) = ',' then
  -- BEGIN
  -- SET Dynamic_SQL = substr(Dynamic_SQL,1,len(Dynamic_SQL)-1)
  -- || ' from ' || Output_Table_Name || ' as base '
  -- || '        inner join '
  -- || '        #Prod_Churn_Dates as trgt '
  -- || ' on trgt.account_number = base.account_number '
  -- || '    and trgt.' || Obs_Dt_Field || ' = base.' || Obs_Dt_Field || ' ';
  --
  -- EXECUTE(Dynamic_SQL);
  -- END;
  -- End If;
  /* ======================================== Queries for Testing ========================================
1. Create base
CALL Decisioning_procs.Create_Model_Base('sti18.DTV_CHURN_PROC', 'DTV', '2017-08-01');

2. Add all fields initially
CALL STI18.Add_Churn_DTV('DTV_CHURN_PROC', 'Base_Dt', 'Drop and Replace')

3. Test few fields
CALL STI18.Add_Churn_DTV('DTV_CHURN_PROC', 'Base_Dt', 'Drop and Replace', 'DTV_1st_CusCan_Churn_Dt', 'DTV_Last_CusCan_Churn_Dt');

SELECT TOP 1000 * FROM STI18.DTV_CHURN_PROC WHERE DTV_1st_CusCan_Churn_Dt IS NOT NULL or DTV_1st_SysCan_Churn_Dt IS NOT NULL;
SELECT TOP 1000 * FROM STI18.DTV_CHURN_PROC WHERE DTV_SameDayCancels_In_Next_30D > 0;
SELECT TOP 100 * from Decisioning.Churn_DTV;

====================================================================================================== */
  end if
end
