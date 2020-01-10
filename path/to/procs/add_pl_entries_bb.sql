create procedure "Decisioning_Procs"."Add_PL_Entries_BB"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "BB_Cust_Type" varchar(30) default 'All',
  in "ProdPlat_Churn_Type" varchar(30) default 'All',
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
  in "Field_30" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Product_Type" varchar(50);
  declare "Target_Table" varchar(50);
  declare "Dynamic_SQL_Start" long varchar;
  declare "CustType_Prefix" varchar(50);
  declare "ChurnType_Prefix" varchar(50);
  declare "Prefix" varchar(50);
  set "Product_Type" = 'BB';
  set "Target_Table" = 'CITeam.PL_Entries_BB';
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30");
  set "CustType_Prefix"
     = case "lower"("BB_Cust_Type")
    when 'triple play' then 'TP_'
    when 'tp' then 'TP_'
    when 'sabb' then 'SABB_'
    when 'standalone' then 'SABB_'
    when 'bb only' then 'SABB_'
    when 'standalone bb' then 'SABB_' end;
  set "ChurnType_Prefix"
     = case "lower"("ProdPlat_Churn_Type")
    when 'product' then 'Prod_'
    when 'prod' then 'Prod_'
    when 'platform' then 'Plat_'
    when 'plat' then 'Plat_' end;
  set "Prefix" = "CustType_Prefix" || "ChurnType_Prefix";
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL_Start"
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_PL_Entry_Dt''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_PL_Entry_Cust_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_PL_Entry_ProdPlat_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_PL_Entry_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_PL_Entry_Dt''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_PL_Entry_Cust_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_PL_Entry_ProdPlat_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_PL_Entry_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_PL_Entry_Dt''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_PL_Entry_Cust_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_PL_Entry_ProdPlat_Type''' end
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_PL_Entry_Type''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_SysCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_1st_Enter_SysCan_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_SysCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Last_Enter_SysCan_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_CusCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_1st_Enter_CusCan_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_CusCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Last_Enter_CusCan_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_HM_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_1st_Enter_HM_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_HM_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Last_Enter_HM_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_3rd_Party_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_1st_Enter_3rd_Party_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_3rd_Party_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Last_Enter_3rd_Party_Dt''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_30D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_90D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_180D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_3Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_5Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_Ever''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_7D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_30D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_30D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_90D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_180D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_3Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_5Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_Ever''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_7D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_30D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Last_1D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Last_30D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Last_90D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Last_180D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Last_1Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Last_3Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Last_5Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_Ever''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Next_7D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_HM_In_Next_30D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_30D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_90D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_180D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_3Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_5Yr''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_Ever''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_7D''' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_30D''' end
     || ')';
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    execute immediate "Dynamic_SQL"
  end if;
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ''
       || ' ALTER TABLE ' || "Output_Table_Name" || ' ADD('
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_Dt date default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_Cust_Type varchar(20) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_ProdPlat_Type varchar(10) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_1st_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_Type varchar(20) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_Dt date default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_Cust_Type varchar(20) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_ProdPlat_Type varchar(10) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Last_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_Type varchar(20) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_Dt date default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_Cust_Type varchar(20) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_ProdPlat_Type varchar(10) default null,' end
       || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' and "LOWER"("Product_Type" || '_Next_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_Type varchar(20) default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_SysCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_SysCan_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_SysCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_SysCan_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_CusCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_CusCan_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_CusCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_CusCan_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_HM_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_HM_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_HM_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_HM_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_3rd_Party_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_3rd_Party_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_3rd_Party_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_3rd_Party_Dt date default null,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_30D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_90D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_180D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_3Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_5Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_Ever tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_7D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_30D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_30D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_90D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_180D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_3Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_5Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_Ever tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_7D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_30D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_1D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_30D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_90D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_180D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_1Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_3Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_5Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_Ever tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Next_7D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Next_30D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_30D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_90D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_180D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_3Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_5Yr tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_Ever tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_7D tinyint default 0,' end
       || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_30D tinyint default 0,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  drop table if exists #Prod_PL_Churn;
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', '
     || case when "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' then ''
       || ' min(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as _1st_BB_PL_Entry_Dt,'
       || ' max(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as Last_BB_PL_Entry_Dt,'
       || ' min(Case when trgt.event_dt > base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) as Next_BB_PL_Entry_Dt,' end
     || ' min(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_SysCan > 0 then trgt.event_dt end) as _1st_Enter_SysCan_Dt,'
     || ' max(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_SysCan > 0 then trgt.event_dt end) as _Last_Enter_SysCan_Dt,'
     || ' min(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_CusCan > 0 then trgt.event_dt end) as _1st_Enter_CusCan_Dt,'
     || ' max(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_CusCan > 0 then trgt.event_dt end) as _Last_Enter_CusCan_Dt,'
     || ' min(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_HM > 0 then trgt.event_dt end) as _1st_Enter_HM_Dt,'
     || ' max(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_HM > 0 then trgt.event_dt end) as _Last_Enter_HM_Dt,'
     || ' min(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_3rd_Party > 0 then trgt.event_dt end) as _1st_Enter_3rd_Party_Dt,'
     || ' max(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.Enter_3rd_Party > 0 then trgt.event_dt end) as _Last_Enter_3rd_Party_Dt,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.Enter_SysCan else 0 end) as _Enter_SysCan_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_SysCan else 0 end) as _Enter_SysCan_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_SysCan else 0 end) as _Enter_SysCan_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_SysCan else 0 end) as _Enter_SysCan_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_SysCan else 0 end) as _Enter_SysCan_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_SysCan else 0 end) _Enter_SysCan_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_SysCan else 0 end) _Enter_SysCan_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.Enter_SysCan else 0 end) _Enter_SysCan_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.Enter_SysCan else 0 end) as _Enter_SysCan_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.Enter_SysCan else 0 end) as _Enter_SysCan_In_Next_30D,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.Enter_CusCan else 0 end) as _Enter_CusCan_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_CusCan else 0 end) as _Enter_CusCan_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_CusCan else 0 end) as _Enter_CusCan_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_CusCan else 0 end) as _Enter_CusCan_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_CusCan else 0 end) as _Enter_CusCan_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_CusCan else 0 end) _Enter_CusCan_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_CusCan else 0 end) _Enter_CusCan_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.Enter_CusCan else 0 end) _Enter_CusCan_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.Enter_CusCan else 0 end) as _Enter_CusCan_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.Enter_CusCan else 0 end) as _Enter_CusCan_In_Next_30D,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.Enter_HM else 0 end) as _Enter_HM_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_HM else 0 end) as _Enter_HM_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_HM else 0 end) as _Enter_HM_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_HM else 0 end) as _Enter_HM_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_HM else 0 end) as _Enter_HM_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_HM else 0 end) _Enter_HM_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_HM else 0 end) _Enter_HM_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.Enter_HM else 0 end) _Enter_HM_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.Enter_HM else 0 end) as _Enter_HM_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.Enter_HM else 0 end) as _Enter_HM_In_Next_30D,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || ' - 1 then trgt.Enter_3rd_Party else 0 end) as _Enter_3rd_Party_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_3rd_Party else 0 end) as _Enter_3rd_Party_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_3rd_Party else 0 end) as _Enter_3rd_Party_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_3rd_Party else 0 end) as _Enter_3rd_Party_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_3rd_Party else 0 end) as _Enter_3rd_Party_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_3rd_Party else 0 end) _Enter_3rd_Party_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Enter_3rd_Party else 0 end) _Enter_3rd_Party_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.Enter_3rd_Party else 0 end) _Enter_3rd_Party_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.Enter_3rd_Party else 0 end) as _Enter_3rd_Party_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.Enter_3rd_Party else 0 end) as _Enter_3rd_Party_In_Next_30D'
     || ' INTO #Prod_PL_Churn '
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || case when "CustType_Prefix" = 'TP_' then ' and trgt.BB_Cust_Type = ''Triple Play'' '
    when "CustType_Prefix" = 'SABB_' then ' and trgt.BB_Cust_Type = ''SABB'' ' end
     || case when "ChurnType_Prefix" = 'Prod_' then ' and trgt.ProdPlat_Churn_Type = ''Product'' '
    when "ChurnType_Prefix" = 'Plat_' then ' and trgt.ProdPlat_Churn_Type = ''Platform'' ' end
     || ' and enter_cuscan+enter_syscan+enter_3rd_Party+Enter_HM > 0 '
     || ' Group by base.account_number,base.' || "Obs_Dt_Field" || ' ';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_SysCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_SysCan_Dt   = trgt._1st_Enter_SysCan_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_SysCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_SysCan_Dt   = trgt._Last_Enter_SysCan_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_CusCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_CusCan_Dt   = trgt._1st_Enter_CusCan_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_CusCan_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_CusCan_Dt   = trgt._Last_Enter_CusCan_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_HM_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_HM_Dt   = trgt._1st_Enter_HM_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_HM_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_HM_Dt   = trgt._Last_Enter_HM_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_1st_Enter_3rd_Party_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_1st_Enter_3rd_Party_Dt   = trgt._1st_Enter_3rd_Party_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Last_Enter_3rd_Party_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Last_Enter_3rd_Party_Dt   = trgt._Last_Enter_3rd_Party_Dt,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1D  = trgt._Enter_SysCan_In_Last_1D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_30D  = trgt._Enter_SysCan_In_Last_30D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_90D  = trgt._Enter_SysCan_In_Last_90D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_180D  = trgt._Enter_SysCan_In_Last_180D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_1Yr  = trgt._Enter_SysCan_In_Last_1Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_3Yr  = trgt._Enter_SysCan_In_Last_3Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Last_5Yr  = trgt._Enter_SysCan_In_Last_5Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_Ever  = trgt._Enter_SysCan_Ever,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_7D  = trgt._Enter_SysCan_In_Next_7D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_SysCan_In_Next_30D  = trgt._Enter_SysCan_In_Next_30D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1D  = trgt._Enter_CusCan_In_Last_1D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_30D  = trgt._Enter_CusCan_In_Last_30D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_90D  = trgt._Enter_CusCan_In_Last_90D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_180D  = trgt._Enter_CusCan_In_Last_180D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_1Yr  = trgt._Enter_CusCan_In_Last_1Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_3Yr  = trgt._Enter_CusCan_In_Last_3Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Last_5Yr  = trgt._Enter_CusCan_In_Last_5Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_Ever   = trgt._Enter_CusCan_Ever,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_7D  = trgt._Enter_CusCan_In_Next_7D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_CusCan_In_Next_30D  = trgt._Enter_CusCan_In_Next_30D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_1D  = trgt._Enter_HM_In_Last_1D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_30D  = trgt._Enter_HM_In_Last_30D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_90D  = trgt._Enter_HM_In_Last_90D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_180D  = trgt._Enter_HM_In_Last_180D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_1Yr  = trgt._Enter_HM_In_Last_1Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_3Yr  = trgt._Enter_HM_In_Last_3Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Last_5Yr  = trgt._Enter_HM_In_Last_5Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_Ever  = trgt._Enter_HM_Ever,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Next_7D  = trgt._Enter_HM_In_Next_7D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_HM_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_HM_In_Next_30D  = trgt._Enter_HM_In_Next_30D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1D  = trgt._Enter_3rd_Party_In_Last_1D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_30D  = trgt._Enter_3rd_Party_In_Last_30D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_90D  = trgt._Enter_3rd_Party_In_Last_90D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_180D  = trgt._Enter_3rd_Party_In_Last_180D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_1Yr  = trgt._Enter_3rd_Party_In_Last_1Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_3Yr  = trgt._Enter_3rd_Party_In_Last_3Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Last_5Yr  = trgt._Enter_3rd_Party_In_Last_5Yr,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_Ever  = trgt._Enter_3rd_Party_Ever,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_7D  = trgt._Enter_3rd_Party_In_Next_7D,' end
     || case when "LOWER"("Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Prefix" || "Product_Type" || '_Enter_3rd_Party_In_Next_30D  = trgt._Enter_3rd_Party_In_Next_30D,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Prod_PL_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' ';
    execute immediate "Dynamic_SQL"
  end if;
  if "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' then
    drop table if exists #_1st_PL_Entry;
    set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', base._1st_BB_PL_Entry_Dt, '
       || ' BB_Cust_Type,ProdPlat_Churn_Type, '
       || ' Case when Enter_SysCan > 0 then ''Enter SysCan'' '
       || '      when Enter_CusCan > 0 then ''Enter CusCan'' '
       || '      when Enter_HM > 0 then ''Enter Home Move'' '
       || '      when Enter_3rd_Party > 0 then ''Enter 3rd Party'' '
       || ' end Churn_PL, '
       || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by trgt.event_dt) as Rnk '
       || ' INTO #_1st_PL_Entry '
       || ' FROM #Prod_PL_Churn as base '
       || '        INNER JOIN '
       || "Target_Table" || ' as Trgt '
       || '        ON Trgt.account_number = base.account_number '
       || '            and Trgt.event_dt = Base._1st_BB_PL_Entry_Dt '
       || '            and enter_cuscan+enter_syscan+enter_3rd_Party+Enter_HM > 0 ';
    execute immediate "Dynamic_SQL";
    set "Dynamic_SQL"
       = ' UPDATE ' || "Output_Table_Name" || ' AS base '
       || ' SET '
       || case when "LOWER"("Product_Type" || '_1st_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_Dt   = trgt._1st_BB_PL_Entry_Dt,' end
       || case when "LOWER"("Product_Type" || '_1st_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_Cust_Type   = trgt.BB_Cust_Type,' end
       || case when "LOWER"("Product_Type" || '_1st_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_ProdPlat_Type   = trgt.ProdPlat_Churn_Type,' end
       || case when "LOWER"("Product_Type" || '_1st_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_PL_Entry_Type   = trgt.Churn_PL,' end;
    if "right"("Dynamic_SQL",1) = ',' then
      set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
         || ' FROM ' || "Output_Table_Name" || ' as base '
         || '        INNER JOIN '
         || '        #_1st_PL_Entry as trgt '
         || ' ON trgt.account_number = base.account_number '
         || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' '
         || '    and trgt.Rnk = 1 ';
      execute immediate "Dynamic_SQL"
    end if end if;
  if "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' then
    drop table if exists #Last_PL_Entry;
    set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', base.Last_BB_PL_Entry_Dt, '
       || ' BB_Cust_Type,ProdPlat_Churn_Type, '
       || ' Case when Enter_SysCan > 0 then ''Enter SysCan'' '
       || '      when Enter_CusCan > 0 then ''Enter CusCan'' '
       || '      when Enter_HM > 0 then ''Enter Home Move'' '
       || '      when Enter_3rd_Party > 0 then ''Enter 3rd Party'' '
       || ' end Churn_PL, '
       || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by trgt.event_dt desc) as Rnk '
       || ' INTO #Last_PL_Entry '
       || ' FROM #Prod_PL_Churn as base '
       || '        INNER JOIN '
       || "Target_Table" || ' as Trgt '
       || '        ON Trgt.account_number = base.account_number '
       || '            and Trgt.event_dt = Base.Last_BB_PL_Entry_Dt '
       || '            and enter_cuscan+enter_syscan+enter_3rd_Party+Enter_HM > 0 ';
    execute immediate "Dynamic_SQL";
    set "Dynamic_SQL"
       = ' UPDATE ' || "Output_Table_Name" || ' AS base '
       || ' SET '
       || case when "LOWER"("Product_Type" || '_Last_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_Dt   = trgt.Last_BB_PL_Entry_Dt,' end
       || case when "LOWER"("Product_Type" || '_Last_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_Cust_Type   = trgt.BB_Cust_Type,' end
       || case when "LOWER"("Product_Type" || '_Last_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_ProdPlat_Type   = trgt.ProdPlat_Churn_Type,' end
       || case when "LOWER"("Product_Type" || '_Last_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PL_Entry_Type   = trgt.Churn_PL,' end;
    if "right"("Dynamic_SQL",1) = ',' then
      set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
         || ' FROM ' || "Output_Table_Name" || ' as base '
         || '        INNER JOIN '
         || '        #Last_PL_Entry as trgt '
         || ' ON trgt.account_number = base.account_number '
         || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' '
         || '    and trgt.Rnk = 1 ';
      execute immediate "Dynamic_SQL"
    end if end if;
  if "BB_Cust_Type" = 'All' and "ProdPlat_Churn_Type" = 'All' then
    drop table if exists #Next_PL_Entry;
    set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', base.Next_BB_PL_Entry_Dt, '
       || ' BB_Cust_Type,ProdPlat_Churn_Type, '
       || ' Case when Enter_SysCan > 0 then ''Enter SysCan'' '
       || '      when Enter_CusCan > 0 then ''Enter CusCan'' '
       || '      when Enter_HM > 0 then ''Enter Home Move'' '
       || '      when Enter_3rd_Party > 0 then ''Enter 3rd Party'' '
       || ' end Churn_PL, '
       || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by trgt.event_dt) as Rnk '
       || ' INTO #Next_PL_Entry '
       || ' FROM #Prod_PL_Churn as base '
       || '        INNER JOIN '
       || "Target_Table" || ' as Trgt '
       || '        ON Trgt.account_number = base.account_number '
       || '            and Trgt.event_dt = Base.Next_BB_PL_Entry_Dt '
       || '            and enter_cuscan+enter_syscan+enter_3rd_Party+Enter_HM > 0 ';
    execute immediate "Dynamic_SQL";
    set "Dynamic_SQL"
       = ' UPDATE ' || "Output_Table_Name" || ' AS base '
       || ' SET '
       || case when "LOWER"("Product_Type" || '_Next_PL_Entry_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_Dt   = trgt.Next_BB_PL_Entry_Dt,' end
       || case when "LOWER"("Product_Type" || '_Next_PL_Entry_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_Cust_Type   = trgt.BB_Cust_Type,' end
       || case when "LOWER"("Product_Type" || '_Next_PL_Entry_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_ProdPlat_Type   = trgt.ProdPlat_Churn_Type,' end
       || case when "LOWER"("Product_Type" || '_Next_PL_Entry_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PL_Entry_Type   = trgt.Churn_PL,' end;
    if "right"("Dynamic_SQL",1) = ',' then
      set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
         || ' FROM ' || "Output_Table_Name" || ' as base '
         || '        INNER JOIN '
         || '        #Next_PL_Entry as trgt '
         || ' ON trgt.account_number = base.account_number '
         || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' '
         || '    and trgt.Rnk = 1 ';
      execute immediate "Dynamic_SQL"
    end if
  end if
end
