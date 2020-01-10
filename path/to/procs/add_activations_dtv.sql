create procedure "Decisioning_Procs"."Add_Activations_DTV"( 
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
  set "Target_Table" = 'CITeam.Activations_DTV';
  set temporary option "Query_Temp_Space_Limit" = 0;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1",
      "Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
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
     || case when "LOWER"("Product_Type" || '_1st_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_Activation_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Activation_Dt''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_Ever''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Activations_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_Ever''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_NewCust_Activations_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_Ever''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Reinstates_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_Ever''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Reinstates_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_Ever''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Reinstates_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_Ever''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PO_Winbacks_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_Ever''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SC_Winbacks_In_Next_30D''' end
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
       || case when "LOWER"("Product_Type" || '_1st_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Activation_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Activation_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Next_30D tinyint default 0 null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 4. Select columns and insert into Temp table
  set "Dynamic_SQL" = 'DROP TABLE IF EXISTS #Prod_Act';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', '
     || ' MIN(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _1st_Activation_Dt, '
     || ' MAX(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _Last_Activation_Dt, '
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _Activations_In_Last_1D,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Activations_In_Last_30D,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Activations_In_Last_90D ,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Activations_In_Last_180D,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Activations_In_Last_1Yr,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Activations_In_Last_3Yr,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Activations_In_Last_5Yr,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Activations_Ever, '
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Activations_In_Next_7D,'
     || ' sum(Case when trgt.Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Activations_In_Next_30D,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _NewCust_Activations_In_Last_1D,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _NewCust_Activations_In_Last_30D,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _NewCust_Activations_In_Last_90D ,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _NewCust_Activations_In_Last_180D,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _NewCust_Activations_In_Last_1Yr,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _NewCust_Activations_In_Last_3Yr,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _NewCust_Activations_In_Last_5Yr,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _NewCust_Activations_Ever, '
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _NewCust_Activations_In_Next_7D,'
     || ' sum(Case when trgt.NewCust_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _NewCust_Activations_In_Next_30D,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then 1 else 0 end) as _Reinstates_In_Last_1D,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Reinstates_In_Last_30D,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Reinstates_In_Last_90D ,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Reinstates_In_Last_180D,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Reinstates_In_Last_1Yr,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Reinstates_In_Last_3Yr,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Reinstates_In_Last_5Yr,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Reinstates_Ever, '
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Reinstates_In_Next_7D,'
     || ' sum(Case when trgt.Reinstate_Activation > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Reinstates_In_Next_30D,'
     || ' sum(Case when trgt.Event_Dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Last_1D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Last_30D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Last_90D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Last_180D,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Last_1Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Last_3Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Last_5Yr,'
     || ' sum(Case when trgt.Event_Dt <= base.' || "Obs_Dt_Field" || ' then trgt.PO_Reinstate else 0 end) _PO_Reinstates_Ever,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Next_7D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.PO_Reinstate else 0 end) as _PO_Reinstates_In_Next_30D,'
     || ' sum(Case when trgt.Event_Dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Last_1D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Last_30D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Last_90D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Last_180D,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Last_1Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Last_3Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Last_5Yr,'
     || ' sum(Case when trgt.Event_Dt <= base.' || "Obs_Dt_Field" || ' then trgt.SC_Reinstate else 0 end) _SC_Reinstates_Ever,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Next_7D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.SC_Reinstate else 0 end) as _SC_Reinstates_In_Next_30D,'
     || ' sum(Case when trgt.Event_Dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Last_1D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Last_30D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Last_90D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Last_180D,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Last_1Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Last_3Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Last_5Yr,'
     || ' sum(Case when trgt.Event_Dt <= base.' || "Obs_Dt_Field" || ' then trgt.PO_Winback else 0 end) _PO_Winbacks_Ever,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Next_7D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.PO_Winback else 0 end) as _PO_Winbacks_In_Next_30D,'
     || ' sum(Case when trgt.Event_Dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Last_1D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Last_30D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Last_90D,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Last_180D,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Last_1Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Last_3Yr,'
     || ' sum(Case when trgt.Event_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Last_5Yr,'
     || ' sum(Case when trgt.Event_Dt <= base.' || "Obs_Dt_Field" || ' then trgt.SC_Winback else 0 end) _SC_Winbacks_Ever,'
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Next_7D, '
     || ' sum(Case when trgt.Event_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.SC_Winback else 0 end) as _SC_Winbacks_In_Next_30D '
     || ' INTO #Prod_Act '
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || '            AND Trgt.event_dt <= Base.' || "Obs_Dt_Field" || ' + 30 '
     || ' GROUP BY base.account_number,base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  ------------------------------------------------------------------------------------------------------------
  -- 5. Update output table
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_1st_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Activation_Dt   = trgt._1st_Activation_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Activation_Dt   = trgt._Last_Activation_Dt,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1D   = trgt._Activations_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_30D   = trgt._Activations_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_90D   = trgt._Activations_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_180D  = trgt._Activations_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1Yr   = trgt._Activations_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_3Yr   = trgt._Activations_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_5Yr   = trgt._Activations_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_Ever   = trgt._Activations_Ever,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_7D   = trgt._Activations_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_30D   = trgt._Activations_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_1D   = trgt._NewCust_Activations_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_30D   = trgt._NewCust_Activations_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_90D   = trgt._NewCust_Activations_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_180D  = trgt._NewCust_Activations_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_1Yr   = trgt._NewCust_Activations_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_3Yr   = trgt._NewCust_Activations_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Last_5Yr   = trgt._NewCust_Activations_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_Ever   = trgt._NewCust_Activations_Ever,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Next_7D   = trgt._NewCust_Activations_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_NewCust_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_NewCust_Activations_In_Next_30D   = trgt._NewCust_Activations_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1D   = trgt._Reinstates_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_30D   = trgt._Reinstates_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_90D   = trgt._Reinstates_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_180D  = trgt._Reinstates_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1Yr   = trgt._Reinstates_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_3Yr   = trgt._Reinstates_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_5Yr   = trgt._Reinstates_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_Ever   = trgt._Reinstates_Ever,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_7D   = trgt._Reinstates_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_30D   = trgt._Reinstates_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_1D  = trgt._PO_Reinstates_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_30D  = trgt._PO_Reinstates_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_90D  = trgt._PO_Reinstates_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_180D  = trgt._PO_Reinstates_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_1Yr  = trgt._PO_Reinstates_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_3Yr  = trgt._PO_Reinstates_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Last_5Yr  = trgt._PO_Reinstates_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_Ever  = trgt._PO_Reinstates_Ever,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Next_7D  = trgt._PO_Reinstates_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_PO_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Reinstates_In_Next_30D  = trgt._PO_Reinstates_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_1D = trgt._SC_Reinstates_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_30D  = trgt._SC_Reinstates_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_90D  = trgt._SC_Reinstates_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_180D  = trgt._SC_Reinstates_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_1Yr  = trgt._SC_Reinstates_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_3Yr  = trgt._SC_Reinstates_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Last_5Yr  = trgt._SC_Reinstates_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_Ever  = trgt._SC_Reinstates_Ever,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Next_7D  = trgt._SC_Reinstates_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_SC_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Reinstates_In_Next_30D  = trgt._SC_Reinstates_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_1D  = trgt._PO_Winbacks_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_30D  = trgt._PO_Winbacks_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_90D  = trgt._PO_Winbacks_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_180D  = trgt._PO_Winbacks_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_1Yr  = trgt._PO_Winbacks_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_3Yr  = trgt._PO_Winbacks_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Last_5Yr  = trgt._PO_Winbacks_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_Ever  = trgt._PO_Winbacks_Ever,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Next_7D  = trgt._PO_Winbacks_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_PO_Winbacks_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PO_Winbacks_In_Next_30D  = trgt._PO_Winbacks_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_1D  = trgt._SC_Winbacks_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_30D  = trgt._SC_Winbacks_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_90D  = trgt._SC_Winbacks_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_180D  = trgt._SC_Winbacks_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_1Yr  = trgt._SC_Winbacks_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_3Yr  = trgt._SC_Winbacks_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Last_5Yr  = trgt._SC_Winbacks_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_Ever  = trgt._SC_Winbacks_Ever,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Next_7D  = trgt._SC_Winbacks_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_SC_Winbacks_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SC_Winbacks_In_Next_30D  = trgt._SC_Winbacks_In_Next_30D,' end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || '        #Prod_Act as trgt '
     || ' ON trgt.account_number = base.account_number '
     || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' ';
  execute immediate "Dynamic_SQL"
/* ======================================== Queries for Testing ========================================
1. Create base
CALL Decisioning_procs.Create_Model_Base('sti18.DTV_ACTIVATION_PROC', 'DTV', '2017-08-01');

2. Add all fields initially
CALL STI18.Add_Activation_DTV('DTV_ACTIVATION_PROC', 'Base_Dt', 'Drop and Replace')

3. Test few fields
CALL STI18.Add_Activation_DTV('DTV_ACTIVATION_PROC', 'Base_Dt', 'Drop and Replace', 'DTV_1st_Activation_Dt', 'DTV_Last_Activation_Dt');

4. Test queries
SELECT TOP 1000 * FROM STI18.DTV_ACTIVATION_PROC WHERE DTV_Activations_Ever>0;
SELECT TOP 1000 * from STI18.DTV_ACTIVATION_PROC WHERE DTV_Reinstatements_In_Next_30D > 0;

====================================================================================================== */
end
