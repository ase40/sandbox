create procedure "Decisioning_Procs"."Add_Activations_Prems"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Product_Type" varchar(100), -- Prems,Sports,Movies,TT
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
  declare "Target_Table" varchar(50);
  declare "Dynamic_SQL_Start" long varchar;
  set "Product_Type" = case "lower"("Product_Type") when 'prems' then 'Prems'
    when 'premiums' then 'Prems'
    when 'sports' then 'Sports'
    when 'movies' then 'Movies'
    when 'cinema' then 'Movies'
    when 'top tier' then 'TT'
    when 'tt' then 'TT' end;
  set "Target_Table" = 'CITeam.Prem_Activations';
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
     || case when "LOWER"("Product_Type" || '_1st_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_Activation_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Activation_Dt''' end
    --Removing the Product Type paramater from sports and making the code static. This will have to change later once we have separate tables for sports and cinema
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
     || case when "LOWER"("Product_Type" || '_New_Addss_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_Ever''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_New_Adds_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_Ever''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Upgrades_In_Next_30D''' end
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
     || ' ) ';
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
      -- Add sports columns
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_30D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_90D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_180D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_3Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_5Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_Ever integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_7D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_30D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_1D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_30D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_90D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_180D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_1Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_3Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_5Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Next_7D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_New_Adds_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Next_30D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_1D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_30D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_90D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_180D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_1Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_3Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_5Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_Ever integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Next_7D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Upgrades_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Next_30D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_30D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_90D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_180D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_3Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_5Yr integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_Ever integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_7D integer default 0 null,' end
       || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_30D integer default 0 null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ');';
    execute immediate "Dynamic_SQL"
  --Select(Dynamic_SQL);
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 4. Select columns and insert into Temp table
  set "Dynamic_SQL" = 'DROP TABLE IF EXISTS #Prod_Activations';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', '
     || ' MIN(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS ' || "Product_Type" || '_1st_Activation_Dt, '
     || ' MAX(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS ' || "Product_Type" || '_Last_Activation_Dt, '
    -- Activations
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' -1  then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Last_1D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Last_30D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Last_90D ,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Last_180D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Last_1Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Last_3Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Last_5Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_Ever, '
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Next_7D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Activations_In_Next_30D,'
    -- New Adds
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' -1  then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Last_1D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Last_30D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Last_90D ,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Last_180D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Last_1Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Last_3Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Last_5Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_Ever, '
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Next_7D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_New_Add ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_New_Add ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_New_Add ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_New_Adds_In_Next_30D,'
    -- Upgrades
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' -1  then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Last_1D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Last_30D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Last_90D ,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Last_180D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Last_1Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Last_3Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Last_5Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_Ever, '
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Next_7D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Upgrade ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Upgrade ' end
     || case when "Product_Type" in( 'TT' ) then ' +trgt.TT_Upgrade ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Upgrades_In_Next_30D,'
    -- Reinstates
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || ' -1  then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Last_1D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Last_30D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Last_90D ,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' -179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Last_180D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Last_1Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Last_3Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Last_5Yr,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_Ever, '
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Next_7D,'
     || ' sum(Case when '
     || case when "Product_Type" in( 'Sports','Prems' ) then ' trgt.Sports_Reinstate ' end
     || case when "Product_Type" in( 'Prems' ) then ' + ' end
     || case when "Product_Type" in( 'Movies','Prems' ) then ' trgt.Movies_Reinstate ' end
     || case when "Product_Type" in( 'TT' ) then ' trgt.TT_Reinstate ' end
     || ' > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end'
     || ') as ' || "Product_Type" || '_Reinstates_In_Next_30D '
     || ' INTO #Prod_Activations '
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || '            AND Trgt.event_dt <= Base.' || "Obs_Dt_Field" || ' + 30 '
     || case when "Product_Type" in( 'Sports' ) then ' AND trgt.Sports_New_Add+trgt.Sports_Upgrade+trgt.Sports_Reinstate > 0 '
    when "Product_Type" in( 'Movies' ) then ' AND trgt.Movies_New_Add+trgt.Movies_Upgrade+trgt.Movies_Reinstate > 0 '
    when "Product_Type" in( 'TT' ) then ' AND trgt.TT_New_Add+trgt.TT_Upgrade+trgt.TT_Reinstate > 0 '
    when "Product_Type" in( 'Prems' ) then '' end
     || ' GROUP BY base.account_number, base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #Prod_Activations("account_number");
  execute immediate 'create date index idx_2 on #Prod_Activations(' || "Obs_Dt_Field" || ')';
  --select(Dynamic_SQL);
  -- SELECT TOP 10 * FROM #Prod_Activations;
  -- END
  ------------------------------------------------------------------------------------------------------------
  -- 5. Update output table
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_1st_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Activation_Dt = trgt.' || "Product_Type" || '_1st_Activation_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Activation_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Activation_Dt = trgt.' || "Product_Type" || '_Last_Activation_Dt,' end
    -- No product type variable here
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1D    = trgt.' || "Product_Type" || '_Activations_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_30D   = trgt.' || "Product_Type" || '_Activations_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_90D   = trgt.' || "Product_Type" || '_Activations_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_180D  = trgt.' || "Product_Type" || '_Activations_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_1Yr   = trgt.' || "Product_Type" || '_Activations_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_3Yr   = trgt.' || "Product_Type" || '_Activations_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Last_5Yr   = trgt.' || "Product_Type" || '_Activations_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Activations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_Ever   = trgt.' || "Product_Type" || '_Activations_Ever,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_7D   = trgt.' || "Product_Type" || '_Activations_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Activations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Activations_In_Next_30D   = trgt.' || "Product_Type" || '_Activations_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_1D    = trgt.' || "Product_Type" || '_New_Adds_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_30D   = trgt.' || "Product_Type" || '_New_Adds_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_90D   = trgt.' || "Product_Type" || '_New_Adds_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_180D  = trgt.' || "Product_Type" || '_New_Adds_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_1Yr   = trgt.' || "Product_Type" || '_New_Adds_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_3Yr   = trgt.' || "Product_Type" || '_New_Adds_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Last_5Yr   = trgt.' || "Product_Type" || '_New_Adds_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_Ever   = trgt.' || "Product_Type" || '_New_Adds_Ever, ' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Next_7D   = trgt.' || "Product_Type" || '_New_Adds_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_New_Adds_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_New_Adds_In_Next_30D   = trgt.' || "Product_Type" || '_New_Adds_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_1D    = trgt.' || "Product_Type" || '_Upgrades_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_30D   = trgt.' || "Product_Type" || '_Upgrades_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_90D   = trgt.' || "Product_Type" || '_Upgrades_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_180D  = trgt.' || "Product_Type" || '_Upgrades_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_1Yr   = trgt.' || "Product_Type" || '_Upgrades_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_3Yr   = trgt.' || "Product_Type" || '_Upgrades_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Last_5Yr   = trgt.' || "Product_Type" || '_Upgrades_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_Ever   = trgt.' || "Product_Type" || '_Upgrades_Ever,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Next_7D   = trgt.' || "Product_Type" || '_Upgrades_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Upgrades_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Upgrades_In_Next_30D   = trgt.' || "Product_Type" || '_Upgrades_In_Next_30D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1D    = trgt.' || "Product_Type" || '_Reinstates_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_30D   = trgt.' || "Product_Type" || '_Reinstates_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_90D   = trgt.' || "Product_Type" || '_Reinstates_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_180D  = trgt.' || "Product_Type" || '_Reinstates_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_1Yr   = trgt.' || "Product_Type" || '_Reinstates_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_3Yr   = trgt.' || "Product_Type" || '_Reinstates_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Last_5Yr   = trgt.' || "Product_Type" || '_Reinstates_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_Ever   = trgt.' || "Product_Type" || '_Reinstates_Ever,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_7D   = trgt.' || "Product_Type" || '_Reinstates_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Reinstates_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Reinstates_In_Next_30D   = trgt.' || "Product_Type" || '_Reinstates_In_Next_30D,' end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || '        #Prod_Activations as trgt '
     || ' ON trgt.account_number = base.account_number '
     || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' ';
  execute immediate "Dynamic_SQL"
/* ======================================== Queries for Testing ========================================
1. Create base
CALL Decisioning_procs.Create_Model_Base('DTV_ACTIVATION_PROC', 'DTV', '2017-08-01');

2. Add all fields initially
CALL STI18.Add_Activation_DTV('DTV_ACTIVATION_PROC', 'Base_Dt', 'Drop and Replace')

3. Test few fields
CALL STI18.Add_Activation_DTV('DTV_ACTIVATION_PROC', 'Base_Dt', 'Drop and Replace', 'DTV_1st_Activation_Dt', 'DTV_Last_Activation_Dt');

4. Test queries
SELECT TOP 1000 * FROM DTV_ACTIVATION_PROC WHERE Sports_Activations_Ever >0;
SELECT TOP 100 * from DTV_ACTIVATION_PROC WHERE NewCust_Activation=0;
SELECT DISTINCT subscription_sub_type, count(1) FROM Decisioning.Active_Subscriber_Report group by subscription_sub_type;

====================================================================================================== */
end
