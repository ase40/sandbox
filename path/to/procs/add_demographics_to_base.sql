create procedure "Decisioning_procs"."Add_Demographics_To_Base"( in "Output_Table_Name" varchar(100),in "Obs_Dt_Field" varchar(100) default null,
  in "Where_Cond" long varchar default null,
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
  declare "Target_Table" varchar(100);
  declare "Update_Fields_SQL" long varchar;
  declare "Field_Num" integer;
  set temporary option "Query_Temp_Space_Limit" = 0;
  drop table if exists #Update_Fields;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20");
  -- Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when 'cb_key_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_key_household''' end
       || case when 'country' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''country''' end
       || case when 'h_affluence' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_affluence''' end
       || case when 'h_age_coarse' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_age_coarse''' end
       || case when 'h_age_fine' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_age_fine''' end
       || case when 'h_equivalised_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_equivalised_income_band''' end
       || case when 'h_equivalised_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_equivalised_income_value''' end
       || case when 'financial_strategy' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''financial_strategy''' end
       || case when 'h_household_composition' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_household_composition''' end
       || case when 'h_property_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_property_type''' end
       || case when 'h_residence_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_residence_type''' end
       || case when 'h_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_income_band''' end
       || case when 'h_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_income_value''' end
       || case when 'h_family_lifestage' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_family_lifestage''' end
       || case when 'h_mosaic_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_mosaic_group''' end
       || case when 'h_number_of_adults' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_number_of_adults''' end
       || case when 'h_number_of_bedrooms' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_number_of_bedrooms''' end
       || case when 'h_number_of_children_in_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_number_of_children_in_household''' end
       || case when 'h_presence_of_child_aged_0_4' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_child_aged_0_4''' end
       || case when 'h_presence_of_child_aged_12_17' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_child_aged_12_17''' end
       || case when 'h_presence_of_child_aged_5_11' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_child_aged_5_11''' end
       || case when 'h_presence_of_young_person_at_address' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_young_person_at_address''' end
       || case when 'p_true_touch_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''p_true_touch_group''' end
       || case when 'p_true_touch_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''p_true_touch_type''' end
       || case when 'cb_address_postcode_area' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_area''' end
       || case when 'cb_address_postcode_incode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_incode''' end
       || case when 'cb_address_postcode_outcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_outcode''' end
       || case when 'cb_address_postcode_sector' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_sector''' end
       || case when 'cb_address_town' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_town''' end
       || case when 'cb_address_county' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_county''' end
       || case when 'age' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Age''' end
       || case when 'home_owner_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Home_Owner_Status''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when 'cb_key_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_key_household''' end
       || case when 'country' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''country''' end
       || case when 'h_affluence' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_affluence''' end
       || case when 'h_age_coarse' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_age_coarse''' end
       || case when 'h_age_fine' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_age_fine''' end
       || case when 'h_equivalised_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_equivalised_income_band''' end
       || case when 'h_equivalised_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_equivalised_income_value''' end
       || case when 'financial_strategy' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''financial_strategy''' end
       || case when 'h_household_composition' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_household_composition''' end
       || case when 'h_property_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_property_type''' end
       || case when 'h_residence_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_residence_type''' end
       || case when 'h_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_income_band''' end
       || case when 'h_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_income_value''' end
       || case when 'h_family_lifestage' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_family_lifestage''' end
       || case when 'h_mosaic_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_mosaic_group''' end
       || case when 'h_number_of_adults' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_number_of_adults''' end
       || case when 'h_number_of_bedrooms' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_number_of_bedrooms''' end
       || case when 'h_number_of_children_in_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_number_of_children_in_household''' end
       || case when 'h_presence_of_child_aged_0_4' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_child_aged_0_4''' end
       || case when 'h_presence_of_child_aged_12_17' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_child_aged_12_17''' end
       || case when 'h_presence_of_child_aged_5_11' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_child_aged_5_11''' end
       || case when 'h_presence_of_young_person_at_address' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''h_presence_of_young_person_at_address''' end
       || case when 'p_true_touch_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''p_true_touch_group''' end
       || case when 'p_true_touch_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''p_true_touch_type''' end
       || case when 'cb_address_postcode_area' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_area''' end
       || case when 'cb_address_postcode_incode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_incode''' end
       || case when 'cb_address_postcode_outcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_outcode''' end
       || case when 'cb_address_postcode_sector' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode_sector''' end
       || case when 'cb_address_town' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_town''' end
       || case when 'cb_address_county' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_county''' end
       || case when 'age' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Age''' end
       || case when 'home_owner_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Home_Owner_Status''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  -- Add Fields
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL"
       = ' Alter table ' || "Output_Table_Name"
       || ' Add( '
       || case when 'cb_key_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'cb_key_household bigint default null null,' end
       || case when 'country' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Country varchar(3) default null null,' end
       || case when 'age' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Age integer default null null,' end
       || case when 'home_owner_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Home_Owner_Status varchar(30) default ''UNKNOWN'' null,' end
       || case when 'h_affluence' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_affluence varchar(50) default null null,' end
       || case when 'h_age_coarse' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_age_coarse varchar(10) default null null,' end
       || case when 'h_age_fine' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_age_fine varchar(10) default null null,' end
       || case when 'h_equivalised_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_equivalised_income_band varchar(30) default null null,' end
       || case when 'h_equivalised_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_equivalised_income_value decimal(20,2) default null null,' end
       || case when 'financial_strategy' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'financial_strategy varchar(50) default null null,' end
       || case when 'h_household_composition' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_household_composition varchar(50) default null null,' end
       || case when 'h_property_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_property_type varchar(50) default null null,' end
       || case when 'h_residence_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_residence_type varchar(50) default null null,' end
       || case when 'h_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_income_band varchar(30) default null null,' end
       || case when 'h_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_income_value decimal(20,2) default null null,' end
       || case when 'h_family_lifestage' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_family_lifestage varchar(50) default null null,' end
       || case when 'h_mosaic_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_mosaic_group varchar(50) default null null,' end
       || case when 'h_number_of_adults' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_number_of_adults smallint default null null,' end
       || case when 'h_number_of_bedrooms' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_number_of_bedrooms smallint default null null,' end
       || case when 'h_number_of_children_in_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_number_of_children_in_household smallint default null null,' end
       || case when 'h_presence_of_child_aged_0_4' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_presence_of_child_aged_0_4 varchar(10) default null null,' end
       || case when 'h_presence_of_child_aged_5_11' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_presence_of_child_aged_5_11 varchar(10) default null null,' end
       || case when 'h_presence_of_child_aged_12_17' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_presence_of_child_aged_12_17 varchar(10) default null null,' end
       || case when 'h_presence_of_young_person_at_address' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'h_presence_of_young_person_at_address varchar(10) default null null,' end
       || case when 'p_true_touch_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'p_true_touch_group varchar(50) default null null,' end
       || case when 'p_true_touch_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'p_true_touch_type smallint default null null,' end
       || case when 'cb_address_postcode_area' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'cb_address_postcode_area varchar(4) default null null,' end
       || case when 'cb_address_postcode_incode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'cb_address_postcode_incode varchar(4) default null null,' end
       || case when 'cb_address_postcode_outcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'cb_address_postcode_outcode varchar(4) default null null,' end
       || case when 'cb_address_postcode_sector' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'cb_address_postcode_sector varchar(6) default null null,' end
       || case when 'cb_address_town' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'cb_address_town varchar(30) default null null,' end
       || case when 'cb_address_county' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'cb_address_county varchar(30) default null null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  drop table if exists #Dem_Accs;
  execute immediate 'Create table #Dem_Accs(Account_Number varchar(20) default null)';
  create hg index "idx_1" on #Dem_Accs("Account_Number");
  execute immediate 'Insert into #Dem_Accs Select distinct base.account_number '
     || ' from ' || "Output_Table_Name" || ' base '
     || "Where_Cond";
  drop table if exists #experian_consumerview;
  --exp.*
  select "sav"."account_number","sav"."fin_ph_subs_currency_code","sav"."cust_birth_date","sav"."cb_key_household","exp"."h_tenure_v2","exp"."h_property_type_v2","exp"."h_residence_type_v2","exp"."h_age_coarse","exp"."h_age_fine","exp"."h_equivalised_income_band","exp"."h_equivalised_income_value",
    "exp"."h_household_composition","exp"."h_affluence_v2","exp"."h_fss_v3_group","exp"."h_family_lifestage_2011","exp"."h_mosaic_uk_group","exp"."p_true_touch_group","exp"."h_income_band_v2",
    "exp"."h_presence_of_child_aged_0_4_2011","exp"."h_presence_of_child_aged_5_11_2011","exp"."h_presence_of_child_aged_12_17_2011","exp"."h_presence_of_young_person_at_address","exp"."h_number_of_children_in_household_2011",
    "exp"."h_income_value_v2","exp"."h_number_of_adults","exp"."h_number_of_bedrooms","exp"."p_true_touch_type","exp"."cb_address_postcode_area","exp"."cb_address_postcode_incode","exp"."cb_address_postcode_outcode",
    "exp"."cb_address_postcode_sector","exp"."cb_address_town","exp"."cb_address_county",
    "roi_mos"."mosaic_type_code"
    into #experian_consumerview
    from "cust_single_account_view" as "sav"
      left outer join "experian_consumerview" as "exp"
      on "exp"."cb_key_household" = "sav"."cb_key_household"
      left outer join "SKY_ROI_MOSAIC_2013" as "roi_mos"
      on "sav"."roi_building_id" = "roi_mos"."building_id"
    where "account_number" = any(select "Account_Number" from #Dem_Accs);
  commit work;
  create hg index "idx_1" on #experian_consumerview("account_number");
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name"
     || ' Set '
     || case when 'cb_key_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' cb_key_household = exp.cb_key_household,'
    else ''
    end
     || case when 'country' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' Country = Case when exp.fin_ph_subs_currency_code  = ''EUR'' then ''ROI'' '
       || ' when exp.fin_ph_subs_currency_code  = ''GBP'' then ''UK'' '
       || ' end,'
    else ''
    end
     || case when 'age' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' Age = datediff(yy,exp.cust_birth_date,' || case when "Obs_Dt_Field" is null then 'today()' else "Obs_Dt_Field" end || '),'
    else ''
    end
     || case when 'home_owner_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' home_owner_status = CASE WHEN h_tenure_v2 = ''0'' THEN ''Owner'' '
       || '                                        WHEN h_tenure_v2 = ''1'' THEN ''Private Rent'' '
       || '                                        WHEN h_tenure_v2 = ''2'' THEN ''Council Rent'' '
       || '                                        ELSE ''UNKNOWN'' '
       || '                                   END,'
    else ''
    end
     || case when 'h_property_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_property_type = Case exp.h_property_type_v2 '
       || '                             when ''0'' then ''Purpose Built Flats'' '
       || '                             when ''1'' then ''Converted Flats'' '
       || '                             when ''2'' then ''Farm'' '
       || '                             when ''3'' then ''Named Building'' '
       || '                             when ''4'' then ''Other Type'' '
       || '                             else ''Unknown'' end,'
    else ''
    end
     || case when 'h_residence_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_residence_type = Case exp.h_residence_type_v2 '
       || '                             when ''0'' then ''Detached'' '
       || '                             when ''1'' then ''Semi-detached'' '
       || '                             when ''2'' then ''Bungalow'' '
       || '                             when ''3'' then ''Terraced'' '
       || '                             when ''4'' then ''Flat'' '
       || '                             else ''Unknown'' end,'
    else ''
    end
     || case when 'h_household_composition' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' h_household_composition = CASE exp.h_household_composition '
       || '                                    WHEN ''00'' THEN ''Families'' '
       || '                                    WHEN ''01'' THEN ''Extended Family'' '
       || '                                    WHEN ''02'' THEN ''Extended Household'' '
       || '                                    WHEN ''03'' THEN ''Pseudo Family'' '
       || '                                    WHEN ''04'' THEN ''Single Male'' '
       || '                                    WHEN ''05'' THEN ''Single Female'' '
       || '                                    WHEN ''06'' THEN ''Male Homesharers'' '
       || '                                    WHEN ''07'' THEN ''Female Homesharers'' '
       || '                                    WHEN ''08'' THEN ''Mixed Homesharers'' '
       || '                                    WHEN ''09'' THEN ''Abbreviated Male Families'' '
       || '                                    WHEN ''10'' THEN ''Abbreviated Female Families'' '
       || '                                    WHEN ''11'' THEN ''Multi-occupancy Dwelling'' '
       || '                                    WHEN ''U''  THEN ''Unclassified'' '
       || '                                    else ''Unclassified'' '
       || '                                 END,'
    else ''
    end
     || case when 'h_affluence' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_affluence = CASE WHEN exp.h_affluence_v2 in (''00'',''01'',''02'')   THEN ''Very Low'' '
       || '                         WHEN exp.h_affluence_v2 in (''03'',''04'',''05'')   THEN ''Low'' '
       || '                         WHEN exp.h_affluence_v2 in (''06'',''07'',''08'')   THEN ''Mid Low'' '
       || '                         WHEN exp.h_affluence_v2 in (''09'',''10'',''11'')   THEN ''Mid'' '
       || '                         WHEN exp.h_affluence_v2 in (''12'',''13'',''14'')   THEN ''Mid High'' '
       || '                         WHEN exp.h_affluence_v2 in (''15'',''16'',''17'')   THEN ''High'' '
       || '                         WHEN exp.h_affluence_v2 in (''18'',''19'')        THEN ''Very High'' '
       || '                         ELSE                                               ''Unknown'' '
       || '                    END,'
    else ''
    end
     || case when 'financial_strategy' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'financial_strategy = CASE exp.h_fss_v3_group '
       || '                                 WHEN ''A'' THEN ''Bright Futures'' '
       || '                                 WHEN ''B'' THEN ''Single Endeavours'' '
       || '                                 WHEN ''C'' THEN ''Young Essentials'' '
       || '                                 WHEN ''D'' THEN ''Growing Rewards'' '
       || '                                 WHEN ''E'' THEN ''Family Interest'' '
       || '                                 WHEN ''F'' THEN ''Accumulated Wealth'' '
       || '                                 WHEN ''G'' THEN ''Consolidating Assets'' '
       || '                                 WHEN ''H'' THEN ''Balancing Budgets'' '
       || '                                 WHEN ''I'' THEN ''Stretched Finances'' '
       || '                                 WHEN ''J'' THEN ''Established Reserves'' '
       || '                                 WHEN ''K'' THEN ''Seasoned Economy'' '
       || '                                 WHEN ''L'' THEN ''Platinum Pensions'' '
       || '                                 WHEN ''M'' THEN ''Sunset Security'' '
       || '                                 WHEN ''N'' THEN ''Traditional Thrift'' '
       || '                                 WHEN ''U'' THEN ''Unallocated'' '
       || '                                 ELSE ''Unallocated'' '
       || '                                 END,'
    else ''
    end
     || case when 'h_family_lifestage' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_family_lifestage = CASE exp.h_family_lifestage_2011 '
       || '                                 WHEN ''00'' THEN ''Young singles/homesharers'' '
       || '                                 WHEN ''01'' THEN ''Young family no children <18'' '
       || '                                 WHEN ''02'' THEN ''Young family with children <18'' '
       || '                                 WHEN ''03'' THEN ''Young household with children <18'' '
       || '                                 WHEN ''04'' THEN ''Mature singles/homesharers'' '
       || '                                 WHEN ''05'' THEN ''Mature family no children <18'' '
       || '                                 WHEN ''06'' THEN ''Mature family with children <18'' '
       || '                                 WHEN ''07'' THEN ''Mature household with children <18'' '
       || '                                 WHEN ''08'' THEN ''Older single'' '
       || '                                 WHEN ''09'' THEN ''Older family no children <18'' '
       || '                                 WHEN ''10'' THEN ''Older family/household with children <18'' '
       || '                                 WHEN ''11'' THEN ''Elderly single'' '
       || '                                 WHEN ''12'' then ''Elderly family no children <18'' '
       || '                                 WHEN ''U'' then ''Unclassified'' '
       || '                                 ELSE ''Unclassified'' '
       || '                                 END,'
    else ''
    end
     || case when 'h_mosaic_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_mosaic_group = CASE '
       || '                                 WHEN exp.h_mosaic_uk_group = ''A'' THEN ''Alpha Territory'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''B'' THEN ''Professional Rewards'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''C'' THEN ''Rural Solitude'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''D'' THEN ''Small Town Diversity'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''E'' THEN ''Active Retirement'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''F'' THEN ''Suburban Mindsets'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''G'' THEN ''Careers and Kids'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''H'' THEN ''New Homemakers'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''I'' THEN ''Ex-Council Community'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''J'' THEN ''Claimant Cultures'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''K'' THEN ''Upper Floor Living'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''L'' THEN ''Elderly Needs'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''M'' THEN ''Industrial Heritage'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''N'' THEN ''Terraced Melting Pot'' '
       || '                                 WHEN exp.h_mosaic_uk_group = ''O'' THEN ''Liberal Opinions'' '
       || '                                 WHEN exp.fin_ph_subs_currency_code = ''EUR'' then ''ROI - '' || exp.mosaic_type_code '
       || '                                 ELSE ''Unclassified'' '
       || '                                 END,'
    else ''
    end
     || case when 'p_true_touch_group' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'p_true_touch_group = case exp.p_true_touch_group '
       || '                                 when ''1'' then ''Experienced Netizen'' '
       || '                                 when ''2'' then ''Cyber Tourist'' '
       || '                                 when ''3'' then ''Digital Culture'' '
       || '                                 when ''4'' then ''Modern Media Margins'' '
       || '                                 when ''5'' then ''Traditional Approach'' '
       || '                                 when ''6'' then ''New Tech Novices'' '
       || '                                 when ''U'' then ''Unknown'' '
       || '                                 else ''Unknown'' '
       || '                        end,'
    else ''
    end
     || case when 'h_presence_of_child_aged_0_4' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_presence_of_child_aged_0_4 = case exp.h_presence_of_child_aged_0_4_2011 when ''0'' then ''No'' '
       || '                                                                                  when ''1'' then ''Yes'' '
       || '                                                                                  when ''U'' then ''Unknown'' '
       || '                                                                                  else ''Unknown'' end,'
    else ''
    end
     || case when 'h_presence_of_child_aged_5_11' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_presence_of_child_aged_5_11 = case exp.h_presence_of_child_aged_5_11_2011 when ''0'' then ''No'' '
       || '                                                                                  when ''1'' then ''Yes'' '
       || '                                                                                  when ''U'' then ''Unknown'' '
       || '                                                                                  else ''Unknown'' end,'
    else ''
    end
     || case when 'h_presence_of_child_aged_12_17' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_presence_of_child_aged_12_17 =  case exp.h_presence_of_child_aged_12_17_2011 when ''0'' then ''No'' '
       || '                                                                                     when ''1'' then ''Yes'' '
       || '                                                                                     when ''U'' then ''Unknown'' '
       || '                                                                                     else ''Unknown'' end,'
    else ''
    end
     || case when 'h_presence_of_young_person_at_address' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_presence_of_young_person_at_address = Case exp.h_presence_of_young_person_at_address when ''0'' then ''No'' '
       || '                                                                                     when ''1'' then ''Yes'' '
       || '                                                                                     when ''U'' then ''Unknown'' '
       || '                                                                                     else ''Unknown'' end,'
    else ''
    end
     || case when 'h_number_of_children_in_household' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_number_of_children_in_household = exp.h_number_of_children_in_household_2011,'
    else ''
    end
     || case when 'h_age_coarse' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_age_coarse = Case exp.h_age_coarse '
       || '                            when ''0'' then ''18-25'' '
       || '                            when ''1'' then ''26-35'' '
       || '                            when ''2'' then ''36-45'' '
       || '                            when ''3'' then ''46-55'' '
       || '                            when ''4'' then ''56-65'' '
       || '                            when ''5'' then ''66+'' '
       || '                            else ''Unknown'' end,'
    else ''
    end
     || case when 'h_age_fine' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_age_fine = Case exp.h_age_fine '
       || '                            when ''00'' then ''18-25'' '
       || '                            when ''01'' then ''26-30'' '
       || '                            when ''02'' then ''31-35'' '
       || '                            when ''03'' then ''36-40'' '
       || '                            when ''04'' then ''41-45'' '
       || '                            when ''05'' then ''46-50'' '
       || '                            when ''06'' then ''51-55'' '
       || '                            when ''07'' then ''56-60'' '
       || '                            when ''08'' then ''61-65'' '
       || '                            when ''09'' then ''66-70'' '
       || '                            when ''10'' then ''71-75'' '
       || '                            when ''11'' then ''76+'' '
       || '                            else ''Unknown'' end,'
    else ''
    end
     || case when 'h_equivalised_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_equivalised_income_band = Case exp.h_equivalised_income_band '
       || '                             when ''0'' then ''< £10,000 '' '
       || '                             when ''1'' then ''£10,000 - £14,999'' '
       || '                             when ''2'' then ''£15,000 - £19,999'' '
       || '                             when ''3'' then ''£20,000 - £24,999'' '
       || '                             when ''4'' then ''£25,000 - £29,999'' '
       || '                             when ''5'' then ''£30,000 - £39,999'' '
       || '                             when ''6'' then ''£40,000 - £49,999'' '
       || '                             when ''7'' then ''£50,000 - £59,999'' '
       || '                             when ''8'' then ''£60,000 - £74,999'' '
       || '                             when ''9'' then ''£75,000 +'' '
       || '                            else ''Unknown'' end,'
    else ''
    end
     || case when 'h_equivalised_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_equivalised_income_value = exp.h_equivalised_income_value,'
    else ''
    end
     || case when 'h_income_band' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_income_band = Case exp.h_income_band_v2 '
       || '                             when ''0'' then ''< �10,000'' '
       || '                             when ''1'' then ''�10,000 - �14,999'' '
       || '                             when ''2'' then ''�15,000 - �19,999'' '
       || '                             when ''3'' then ''�20,000 - �24,999'' '
       || '                             when ''4'' then ''�25,000 - �29,999'' '
       || '                             when ''5'' then ''�30,000 - �39,999'' '
       || '                             when ''6'' then ''�40,000 - �49,999'' '
       || '                             when ''7'' then ''�50,000 - �59,999'' '
       || '                             when ''8'' then ''�60,000 - �74,999'' '
       || '                             when ''9'' then ''�75,000 +'' '
       || '                            else ''Unknown'' end,'
    else ''
    end
     || case when 'h_income_value' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_income_value = exp.h_income_value_v2,'
    else ''
    end
     || case when 'h_number_of_adults' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_number_of_adults = exp.h_number_of_adults,'
    else ''
    end
     || case when 'h_number_of_bedrooms' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'h_number_of_bedrooms = exp.h_number_of_bedrooms,'
    else ''
    end
     || case when 'p_true_touch_type' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'p_true_touch_type = exp.p_true_touch_type,'
    else ''
    end
     || case when 'cb_address_postcode_area' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'cb_address_postcode_area = exp.cb_address_postcode_area,'
    else ''
    end
     || case when 'cb_address_postcode_incode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'cb_address_postcode_incode = exp.cb_address_postcode_incode,'
    else ''
    end
     || case when 'cb_address_postcode_outcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'cb_address_postcode_outcode = exp.cb_address_postcode_outcode,'
    else ''
    end
     || case when 'cb_address_postcode_sector' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'cb_address_postcode_sector = exp.cb_address_postcode_sector,'
    else ''
    end
     || case when 'cb_address_town' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'cb_address_town = exp.cb_address_town,'
    else ''
    end
     || case when 'cb_address_county' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'cb_address_county = exp.cb_address_county,'
    else ''
    end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' from ' || "Output_Table_Name" || ' as base'
     || '     inner join'
     || '     #experian_consumerview exp'
     || '     on exp.account_number = base.account_number';
  execute immediate "Dynamic_SQL";
  drop table if exists #Dem_Accs
end
