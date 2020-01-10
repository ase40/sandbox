create procedure "Decisioning_Procs"."Add_PL_Entries_DTV"( 
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
  set "Target_Table" = 'CITeam.PL_Entries_DTV';
  set temporary option "Query_Temp_Space_Limit" = 0;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1", --)
      "Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30");
  ------------------------------------------------------------------------------------------------------------
  -- 2. Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL"
     || case when "LOWER"("Product_Type" || '_1st_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_Pending_Cancel_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Pending_Cancel_Dt''' end
     || case when "LOWER"("Product_Type" || '_1st_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_Active_Block_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Active_Block_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_PC_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_PC_Effective_To_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_PC_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_PC_Next_Status_Code''' end
     || case when "LOWER"("Product_Type" || '_Last_PC_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_PC_Future_Sub_Effective_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_AB_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_AB_Effective_To_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_AB_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_AB_Next_Status_Code''' end
     || case when "LOWER"("Product_Type" || '_Last_AB_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_AB_Future_Sub_Effective_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Pending_Cancel_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_PC_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_PC_Effective_To_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_PC_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_PC_Next_Status_Code''' end
     || case when "LOWER"("Product_Type" || '_Next_PC_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_PC_Future_Sub_Effective_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Active_Block_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_AB_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_AB_Effective_To_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_AB_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_AB_Next_Status_Code''' end
     || case when "LOWER"("Product_Type" || '_Next_AB_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_AB_Future_Sub_Effective_Dt''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_PCs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_Ever''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PCs_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_Ever''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PL_Cancels_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_SDCs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_Ever''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_SDCs_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_ABs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_Ever''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_ABs_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_Ever''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_Reactivations_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_Ever''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_AB_Reactivations_In_Next_30D''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_Ever''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_PC_To_ABs_In_Next_30D''' end
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
       || case when "LOWER"("Product_Type" || '_1st_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Pending_Cancel_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Pending_Cancel_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_PC_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PC_Effective_To_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_PC_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PC_Next_Status_Code varchar(10) default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_PC_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PC_Future_Sub_Effective_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Pending_Cancel_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_PC_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PC_Effective_To_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_PC_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PC_Next_Status_Code varchar(10) default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_PC_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PC_Future_Sub_Effective_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_1st_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Active_Block_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Active_Block_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_AB_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_AB_Effective_To_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_AB_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_AB_Next_Status_Code varchar(10) default null null,' end
       || case when "LOWER"("Product_Type" || '_Last_AB_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_AB_Future_Sub_Effective_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Active_Block_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_AB_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_AB_Effective_To_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_AB_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_AB_Next_Status_Code varchar(10) default null null,' end
       || case when "LOWER"("Product_Type" || '_Next_AB_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_AB_Future_Sub_Effective_Dt date default null null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_Ever tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PCs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_SDCs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_ABs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Next_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_1D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_30D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_90D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_180D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_1Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_3Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_5Yr tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_Ever tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Next_7D tinyint default 0 null,' end
       || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Next_30D tinyint default 0 null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 4. Select columns and insert into Temp table
  execute immediate 'Select distinct account_number, ' || "Obs_Dt_Field" || ' into #Acc_Obs_Dts from ' || "Output_Table_Name" || ';';
  commit work;
  create hg index "idx_1" on #Acc_Obs_Dts("Account_number");
  execute immediate 'create date index idx_2 on #Acc_Obs_Dts(' || "Obs_Dt_Field" || ');';
  set "Dynamic_SQL" = 'DROP TABLE IF EXISTS #Prod_PL_Churn';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', '
     || ' min(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.AB_Pending_Termination  > 0 then trgt.event_dt end) as _1st_Active_Block_Dt,'
     || ' max(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.AB_Pending_Termination   > 0 then trgt.event_dt end) as _Last_Active_Block_Dt,'
     || ' min(Case when trgt.event_dt > base.' || "Obs_Dt_Field" || ' and trgt.AB_Pending_Termination  > 0 then trgt.event_dt end) as _Next_Active_Block_Dt,'
     || ' min(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel > 0 then trgt.event_dt end) as _1st_Pending_Cancel_Dt,'
     || ' max(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' and trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel > 0 then trgt.event_dt end) as _Last_Pending_Cancel_Dt,'
     || ' min(Case when trgt.event_dt > base.' || "Obs_Dt_Field" || ' and trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel > 0 then trgt.event_dt end) as _Next_Pending_Cancel_Dt,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || '  then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Last_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) _PCs_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) _PCs_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) _PCs_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel else 0 end) as _PCs_In_Next_30D,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || '  then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Last_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) _PL_Cancels_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) _PL_Cancels_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.PC_Pipeline_Cancellation else 0 end) _PL_Cancels_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.PC_Pipeline_Cancellation else 0 end) as _PL_Cancels_In_Next_30D,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || '  then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Last_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) _SDCs_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) _SDCs_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.Same_Day_Cancel else 0 end) _SDCs_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.Same_Day_Cancel else 0 end) as _SDCs_In_Next_30D,'
     || ' sum(Case when trgt.event_dt = base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Last_1D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Last_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Last_30D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Last_90D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Last_180D,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Last_1Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) _ABs_In_Last_3Yr,'
     || ' sum(Case when trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) _ABs_In_Last_5Yr,'
     || ' sum(Case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.AB_Pending_Termination   else 0 end) _ABs_Ever,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Next_7D,'
     || ' sum(Case when trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.AB_Pending_Termination   else 0 end) as _ABs_In_Next_30D,'
     || ' sum(Case when trgt.PC_Effective_To_Dt = base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Last_1D,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Last_7D,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Last_30D,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Last_90D,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Last_180D,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Last_1Yr,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) _PC_Reactivations_In_Last_3Yr,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) _PC_Reactivations_In_Last_5Yr,'
     || ' sum(Case when trgt.PC_Effective_To_Dt <= base.' || "Obs_Dt_Field" || ' and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) _PC_Reactivations_Ever,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Next_7D,'
     || ' sum(Case when trgt.PC_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 and trgt.PC_Next_Status_Code = ''AC'' then trgt.PC_Pipeline_Cancellation else 0 end) as _PC_Reactivations_In_Next_30D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt = base.' || "Obs_Dt_Field" || '  and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_1D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_7D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_30D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_90D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_180D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_1Yr,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_3Yr,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Last_5Yr,'
     || ' sum(Case when trgt.AB_Effective_To_Dt <= base.' || "Obs_Dt_Field" || ' and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) _AB_Reactivations_Ever,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Next_7D, '
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 and trgt.AB_Next_Status_Code = ''AC'' then trgt.AB_Pending_Termination  else 0 end) as _AB_Reactivations_In_Next_30D, '
     || ' sum(Case when trgt.AB_Effective_To_Dt = base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_1D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_7D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_30D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_90D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_180D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_1Yr,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_3Yr,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Last_5Yr,'
     || ' sum(Case when trgt.AB_Effective_To_Dt <= base.' || "Obs_Dt_Field" || ' then trgt.PC_To_AB else 0 end) _PC_To_ABs_Ever,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Next_7D,'
     || ' sum(Case when trgt.AB_Effective_To_Dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then trgt.PC_To_AB else 0 end) as _PC_To_ABs_In_Next_30D,';
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' INTO #Prod_PL_Churn '
     || ' FROM #Acc_Obs_Dts as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
    -- || '            and Trgt.event_dt <= Base.' || Obs_Dt_Field || ' + 30 '
     || ' Group by base.account_number,base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  -- Select Dynamic_SQL
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', trgt.event_dt as PL_Entries_DTV_Event_Dt,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel>0 then 1 else 0 end as PC,'
     || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by PC desc,PL_Entries_DTV_Event_Dt) PC_Rank,'
     || ' Case when trgt.AB_Pending_Termination >0 then 1 else 0 end as AB,'
     || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by AB desc,PL_Entries_DTV_Event_Dt) AB_Rank,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel>0 then trgt.PC_Effective_To_Dt end as _Next_PC_Effective_To_Dt,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel>0 then trgt.PC_Next_Status_Code end as _Next_PC_Next_Status_Code,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel>0 then trgt.PC_Future_Sub_Effective_Dt end as _Next_PC_Future_Sub_Effective_Dt,'
     || ' Case when trgt.AB_Pending_Termination >0 then trgt.AB_Effective_To_Dt end as _Next_AB_Effective_To_Dt,'
     || ' Case when trgt.AB_Pending_Termination >0 then trgt.AB_Next_Status_Code end as _Next_AB_Next_Status_Code,'
     || ' Case when trgt.AB_Pending_Termination >0 then trgt.AB_Future_Sub_Effective_Dt end as _Next_AB_Future_Sub_Effective_Dt,';
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' INTO #Next_Prod_PL_Churn '
     || ' FROM #Acc_Obs_Dts as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || '            and Trgt.event_dt > Base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', trgt.event_dt as PL_Entries_DTV_Event_Dt,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel > 0 then 1 else 0 end as PC,'
     || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by PC desc,PL_Entries_DTV_Event_Dt desc) PC_Rank,'
     || ' Case when trgt.AB_Pending_Termination >0 then 1 else 0 end as AB,'
     || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by AB desc,PL_Entries_DTV_Event_Dt desc) AB_Rank,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel>0 then trgt.PC_Effective_To_Dt end as _Last_PC_Effective_To_Dt,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel>0 then trgt.PC_Next_Status_Code end as _Last_PC_Next_Status_Code,'
     || ' Case when trgt.PC_Pipeline_Cancellation+trgt.Same_Day_Cancel>0 then trgt.PC_Future_Sub_Effective_Dt end as _Last_PC_Future_Sub_Effective_Dt,'
     || ' Case when trgt.AB_Pending_Termination >0 then trgt.AB_Effective_To_Dt end as _Last_AB_Effective_To_Dt,'
     || ' Case when trgt.AB_Pending_Termination >0 then trgt.AB_Next_Status_Code end as _Last_AB_Next_Status_Code,'
     || ' Case when trgt.AB_Pending_Termination >0 then trgt.AB_Future_Sub_Effective_Dt end as _Last_AB_Future_Sub_Effective_Dt,';
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' INTO #Last_Prod_PL_Churn '
     || ' FROM #Acc_Obs_Dts as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || '            and Trgt.event_dt <= Base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  ------------------------------------------------------------------------------------------------------------
  -- 5. Update output table
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_1st_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Pending_Cancel_Dt   = trgt._1st_Pending_Cancel_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Pending_Cancel_Dt   = trgt._Last_Pending_Cancel_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_Pending_Cancel_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Pending_Cancel_Dt   = trgt._Next_Pending_Cancel_Dt,' end
     || case when "LOWER"("Product_Type" || '_1st_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Active_Block_Dt   = trgt._1st_Active_Block_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Active_Block_Dt   = trgt._Last_Active_Block_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_Active_Block_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Active_Block_Dt   = trgt._Next_Active_Block_Dt,' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_1D  = Coalesce(trgt._PCs_In_Last_1D,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_7D  = Coalesce(trgt._PCs_In_Last_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_30D  = Coalesce(trgt._PCs_In_Last_30D,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_90D  = Coalesce(trgt._PCs_In_Last_90D,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_180D  = Coalesce(trgt._PCs_In_Last_180D,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_1Yr  = Coalesce(trgt._PCs_In_Last_1Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_3Yr  = Coalesce(trgt._PCs_In_Last_3Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Last_5Yr  = Coalesce(trgt._PCs_In_Last_5Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_Ever = Coalesce(trgt._PCs_Ever,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Next_7D = Coalesce(trgt._PCs_In_Next_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PCs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PCs_In_Next_30D  = Coalesce(trgt._PCs_In_Next_30D,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_1D  = Coalesce(trgt._PL_Cancels_In_Last_1D,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_7D  = Coalesce(trgt._PL_Cancels_In_Last_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_30D  = Coalesce(trgt._PL_Cancels_In_Last_30D,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_90D  = Coalesce(trgt._PL_Cancels_In_Last_90D,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_180D  = Coalesce(trgt._PL_Cancels_In_Last_180D,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_1Yr  = Coalesce(trgt._PL_Cancels_In_Last_1Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_3Yr  = Coalesce(trgt._PL_Cancels_In_Last_3Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Last_5Yr  = Coalesce(trgt._PL_Cancels_In_Last_5Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_Ever = Coalesce(trgt._PL_Cancels_Ever,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Next_7D = Coalesce(trgt._PL_Cancels_In_Next_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PL_Cancels_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PL_Cancels_In_Next_30D  = Coalesce(trgt._PL_Cancels_In_Next_30D,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_1D  = Coalesce(trgt._SDCs_In_Last_1D,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_7D  = Coalesce(trgt._SDCs_In_Last_7D,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_30D  = Coalesce(trgt._SDCs_In_Last_30D,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_90D  = Coalesce(trgt._SDCs_In_Last_90D,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_180D  = Coalesce(trgt._SDCs_In_Last_180D,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_1Yr  = Coalesce(trgt._SDCs_In_Last_1Yr,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_3Yr  = Coalesce(trgt._SDCs_In_Last_3Yr,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Last_5Yr  = Coalesce(trgt._SDCs_In_Last_5Yr,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_Ever = Coalesce(trgt._SDCs_Ever,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Next_7D = Coalesce(trgt._SDCs_In_Next_7D,0),' end
     || case when "LOWER"("Product_Type" || '_SDCs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_SDCs_In_Next_30D  = Coalesce(trgt._SDCs_In_Next_30D,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_1D  = Coalesce(trgt._ABs_In_Last_1D,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_7D  = Coalesce(trgt._ABs_In_Last_7D,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_30D  = Coalesce(trgt._ABs_In_Last_30D,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_90D  = Coalesce(trgt._ABs_In_Last_90D,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_180D  = Coalesce(trgt._ABs_In_Last_180D,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_1Yr  = Coalesce(trgt._ABs_In_Last_1Yr,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_3Yr  = Coalesce(trgt._ABs_In_Last_3Yr,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Last_5Yr  = Coalesce(trgt._ABs_In_Last_5Yr,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_Ever  = Coalesce(trgt._ABs_Ever,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Next_7D  = Coalesce(trgt._ABs_In_Next_7D,0),' end
     || case when "LOWER"("Product_Type" || '_ABs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_ABs_In_Next_30D  = Coalesce(trgt._ABs_In_Next_30D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_1D  = Coalesce(trgt._PC_Reactivations_In_Last_1D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_7D  = Coalesce(trgt._PC_Reactivations_In_Last_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_30D  = Coalesce(trgt._PC_Reactivations_In_Last_30D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_90D  = Coalesce(trgt._PC_Reactivations_In_Last_90D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_180D  = Coalesce(trgt._PC_Reactivations_In_Last_180D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_1Yr  = Coalesce(trgt._PC_Reactivations_In_Last_1Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_3Yr  = Coalesce(trgt._PC_Reactivations_In_Last_3Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Last_5Yr  = Coalesce(trgt._PC_Reactivations_In_Last_5Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_Ever   = Coalesce(trgt._PC_Reactivations_Ever,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Next_7D  = Coalesce(trgt._PC_Reactivations_In_Next_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_Reactivations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_Reactivations_In_Next_30D  = Coalesce(trgt._PC_Reactivations_In_Next_30D,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_1D  = Coalesce(trgt._AB_Reactivations_In_Last_1D,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_7D  = Coalesce(trgt._AB_Reactivations_In_Last_7D,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_30D  = Coalesce(trgt._AB_Reactivations_In_Last_30D,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_90D  = Coalesce(trgt._AB_Reactivations_In_Last_90D,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_180D  = Coalesce(trgt._AB_Reactivations_In_Last_180D,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_1Yr  = Coalesce(trgt._AB_Reactivations_In_Last_1Yr,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_3Yr  = Coalesce(trgt._AB_Reactivations_In_Last_3Yr,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Last_5Yr  = Coalesce(trgt._AB_Reactivations_In_Last_5Yr,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_Ever  = Coalesce(trgt._AB_Reactivations_Ever,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Next_7D  = Coalesce(trgt._AB_Reactivations_In_Next_7D,0),' end
     || case when "LOWER"("Product_Type" || '_AB_Reactivations_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_AB_Reactivations_In_Next_30D  = Coalesce(trgt._AB_Reactivations_In_Next_30D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_1D  = Coalesce(trgt._PC_To_ABs_In_Last_1D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_7D  = Coalesce(trgt._PC_To_ABs_In_Last_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_30D  = Coalesce(trgt._PC_To_ABs_In_Last_30D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_90D  = Coalesce(trgt._PC_To_ABs_In_Last_90D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_180D  = Coalesce(trgt._PC_To_ABs_In_Last_180D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_1Yr  = Coalesce(trgt._PC_To_ABs_In_Last_1Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_3Yr  = Coalesce(trgt._PC_To_ABs_In_Last_3Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Last_5Yr  = Coalesce(trgt._PC_To_ABs_In_Last_5Yr,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_Ever  = Coalesce(trgt._PC_To_ABs_Ever,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Next_7D  = Coalesce(trgt._PC_To_ABs_In_Next_7D,0),' end
     || case when "LOWER"("Product_Type" || '_PC_To_ABs_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_PC_To_ABs_In_Next_30D  = Coalesce(trgt._PC_To_ABs_In_Next_30D,0),' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Prod_PL_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' ';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_Next_PC_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PC_Effective_To_Dt   = trgt._Next_PC_Effective_To_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_PC_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PC_Next_Status_Code   = trgt._Next_PC_Next_Status_Code,' end
     || case when "LOWER"("Product_Type" || '_Next_PC_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_PC_Future_Sub_Effective_Dt   = trgt._Next_PC_Future_Sub_Effective_Dt,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Next_Prod_PL_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    AND trgt.PC_Rank = 1 '
       || '    AND trgt.PC = 1 ';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_Next_AB_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_AB_Effective_To_Dt   = trgt._Next_AB_Effective_To_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_AB_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_AB_Next_Status_Code   = trgt._Next_AB_Next_Status_Code,' end
     || case when "LOWER"("Product_Type" || '_Next_AB_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_AB_Future_Sub_Effective_Dt   = trgt._Next_AB_Future_Sub_Effective_Dt,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Next_Prod_PL_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    AND trgt.AB = 1 '
       || '    AND trgt.AB_Rank = 1 ';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_Last_PC_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PC_Effective_To_Dt   = trgt._Last_PC_Effective_To_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_PC_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PC_Next_Status_Code   = trgt._Last_PC_Next_Status_Code,' end
     || case when "LOWER"("Product_Type" || '_Last_PC_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_PC_Future_Sub_Effective_Dt   = trgt._Last_PC_Future_Sub_Effective_Dt,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Last_Prod_PL_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    AND trgt.PC_Rank = 1 '
       || '    AND trgt.PC = 1 ';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_Last_AB_Effective_To_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_AB_Effective_To_Dt   = trgt._Last_AB_Effective_To_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_AB_Next_Status_Code') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_AB_Next_Status_Code   = trgt._Last_AB_Next_Status_Code,' end
     || case when "LOWER"("Product_Type" || '_Last_AB_Future_Sub_Effective_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_AB_Future_Sub_Effective_Dt   = trgt._Last_AB_Future_Sub_Effective_Dt,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Last_Prod_PL_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    AND trgt.AB_Rank = 1 '
       || '    AND trgt.AB = 1 ';
    execute immediate "Dynamic_SQL"
  end if
end
