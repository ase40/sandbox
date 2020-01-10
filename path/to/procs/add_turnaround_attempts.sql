create procedure "Decisioning_Procs"."Add_Turnaround_Attempts"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Interaction_Type" varchar(100),
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
  in "Field_41" varchar(100) default null,
  in "Field_42" varchar(100) default null,
  in "Field_43" varchar(100) default null,
  in "Field_44" varchar(100) default null,
  in "Field_45" varchar(100) default null,
  in "Field_46" varchar(100) default null,
  in "Field_47" varchar(100) default null,
  in "Field_48" varchar(100) default null,
  in "Field_49" varchar(100) default null,
  in "Field_50" varchar(100) default null,
  in "Where_Cond" long varchar default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Field_num" integer;
  declare "Target_Table" varchar(100);
  declare "Target_Events" varchar(200);
  declare "Target_Saves" varchar(200);
  declare "Target_NonSaves" varchar(200);
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30",
      "Field_31","Field_32","Field_33","Field_34","Field_35","Field_36","Field_37","Field_38","Field_39","Field_40",
      "Field_41","Field_42","Field_43","Field_44","Field_45","Field_46","Field_47","Field_48","Field_49","Field_50");
  set "Interaction_Type" = case "Interaction_Type"
    when 'TA Events' then 'TA'
    when 'TA Event' then 'TA'
    when 'TA' then 'TA'
    when 'LiveChats' then 'LiveChat'
    when 'LiveChat' then 'LiveChat'
    when 'WebChats' then 'LiveChat'
    when 'WebChat' then 'LiveChat'
    when 'All' then 'All' end;
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  -- Delete fields
  set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
     || case when 'next_' || "lower"("interaction_type") || '_dt' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''next_' || "interaction_type" || '_dt''' end
     || case when '_1st_' || "lower"("interaction_type") || '_dt' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "interaction_type" || '_dt''' end
     || case when '_1st_' || "lower"("interaction_type") || '_reason' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "interaction_type" || '_reason''' end
     || case when '_1st_' || "lower"("interaction_type") || '_outcome' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "interaction_type" || '_outcome''' end
     || case when '_1st_' || "lower"("interaction_type") || '_site' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "interaction_type" || '_site''' end
     || case when 'last_' || "lower"("interaction_type") || '_dt' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''last_' || "interaction_type" || '_dt''' end
     || case when 'last_' || "lower"("interaction_type") || '_reason' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''last_' || "interaction_type" || '_reason''' end
     || case when 'last_' || "lower"("interaction_type") || '_outcome' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''last_' || "interaction_type" || '_outcome''' end
     || case when 'last_' || "lower"("interaction_type") || '_site' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''last_' || "interaction_type" || '_site''' end
     || case when '_1st_' || "lower"("interaction_type") || '_save_dt' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "interaction_type" || '_save_dt''' end
     || case when 'last_' || "lower"("interaction_type") || '_save_dt' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''last_' || "interaction_type" || '_save_dt''' end
     || case when '_1st_' || "lower"("interaction_type") || '_nonsave_dt' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''_1st_' || "interaction_type" || '_nonsave_dt''' end
     || case when 'last_' || "lower"("interaction_type") || '_nonsave_dt' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''last_' || "interaction_type" || '_nonsave_dt''' end
     || case when "lower"("interaction_type") || 's_in_next_1yr' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_next_1yr''' end
     || case when "lower"("interaction_type") || 's_in_next_180d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_next_180d''' end
     || case when "lower"("interaction_type") || 's_in_next_30d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_next_30d''' end
     || case when "lower"("interaction_type") || 's_in_next_7d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_next_7d''' end
     || case when "lower"("interaction_type") || 's_in_last_24hrs' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_24hrs''' end
     || case when "lower"("interaction_type") || 's_in_last_7d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_7d''' end
     || case when "lower"("interaction_type") || 's_in_last_14d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_14d''' end
     || case when "lower"("interaction_type") || 's_in_last_30d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_30d''' end
     || case when "lower"("interaction_type") || 's_in_last_60d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_60d''' end
     || case when "lower"("interaction_type") || 's_in_last_90d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_90d''' end
     || case when "lower"("interaction_type") || 's_in_last_12m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_12m''' end
     || case when "lower"("interaction_type") || 's_in_last_24m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_24m''' end
     || case when "lower"("interaction_type") || 's_in_last_36m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || 's_in_last_36m''' end
     || case when "lower"("interaction_type") || '_saves_in_next_30d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_next_30d''' end
     || case when "lower"("interaction_type") || '_saves_in_next_7d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_next_7d''' end
     || case when "lower"("interaction_type") || '_saves_in_last_24hrs' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_24hrs''' end
     || case when "lower"("interaction_type") || '_saves_in_last_7d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_7d''' end
     || case when "lower"("interaction_type") || '_saves_in_last_14d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_14d''' end
     || case when "lower"("interaction_type") || '_saves_in_last_30d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_30d''' end
     || case when "lower"("interaction_type") || '_saves_in_last_60d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_60d''' end
     || case when "lower"("interaction_type") || '_saves_in_last_90d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_90d''' end
     || case when "lower"("interaction_type") || '_saves_in_last_12m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_12m''' end
     || case when "lower"("interaction_type") || '_saves_in_last_24m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_24m''' end
     || case when "lower"("interaction_type") || '_saves_in_last_36m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_saves_in_last_36m''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_next_30d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_next_30d''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_next_7d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_next_7d''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_24hrs' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_24hrs''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_7d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_7d''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_14d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_14d''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_30d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_30d''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_60d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_60d''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_90d' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_90d''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_12m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_12m''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_24m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_24m''' end
     || case when "lower"("interaction_type") || '_nonsaves_in_last_36m' = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then ',''' || "interaction_type" || '_nonsaves_in_last_36m''' end
     || ')';
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    execute immediate "Dynamic_SQL"
  end if;
  -- Update fields
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ''
       || ' Alter Table ' || "Output_Table_Name" || ' Add('
       || case when "lower"('Next_' || "interaction_type" || '_dt') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then 'Next_' || "interaction_type" || '_dt date default null null,' end
       || case when "lower"('_1st_' || "interaction_type" || '_dt') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "interaction_type" || '_dt date default null null,' end
       || case when "lower"('_1st_' || "interaction_type" || '_reason') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "interaction_type" || '_reason varchar(255) default null null,' end
       || case when "lower"('_1st_' || "interaction_type" || '_outcome') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "interaction_type" || '_outcome varchar(255) default null null,' end
       || case when "lower"('_1st_' || "interaction_type" || '_site') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "interaction_type" || '_site varchar(255) default null null,' end
       || case when "lower"('last_' || "interaction_type" || '_dt') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then 'last_' || "interaction_type" || '_dt date default null null,' end
       || case when "lower"('last_' || "interaction_type" || '_reason') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then 'last_' || "interaction_type" || '_reason varchar(255) default null null,' end
       || case when "lower"('last_' || "interaction_type" || '_outcome') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then 'last_' || "interaction_type" || '_outcome varchar(255) default null null,' end
       || case when "lower"('last_' || "interaction_type" || '_site') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then 'last_' || "interaction_type" || '_site varchar(255) default null null,' end
       || case when "lower"('_1st_' || "interaction_type" || '_save_dt') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "interaction_type" || '_save_dt date default null null,' end
       || case when "lower"('last_' || "interaction_type" || '_save_dt') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then 'last_' || "interaction_type" || '_save_dt date default null null,' end
       || case when "lower"('_1st_' || "interaction_type" || '_nonsave_dt') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then '_1st_' || "interaction_type" || '_nonsave_dt date default null null,' end
       || case when "lower"('last_' || "interaction_type" || '_nonsave_dt') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then 'last_' || "interaction_type" || '_nonsave_dt date default null null,' end
       || case when "lower"("interaction_type" || 's_in_next_1yr') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_next_1Yr integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_next_180d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_next_180d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_next_30d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_next_30d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_next_7d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_next_7d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_24hrs') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_24hrs integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_7d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_7d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_14d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_14d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_30d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_30d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_60d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_60d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_90d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_90d integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_12m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_12m integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_24m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_24m integer default 0 null,' end
       || case when "lower"("interaction_type" || 's_in_last_36m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || 's_in_last_36m integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_next_30d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_next_30d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_next_7d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_next_7d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_24hrs') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_24hrs integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_7d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_7d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_14d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_14d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_30d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_30d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_60d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_60d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_90d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_90d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_12m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_12m integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_24m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_24m integer default 0 null,' end
       || case when "lower"("interaction_type" || '_saves_in_last_36m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_saves_in_last_36m integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_next_30d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_next_30d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_next_7d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_next_7d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_24hrs') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_24hrs integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_7d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_7d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_14d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_14d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_30d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_30d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_60d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_60d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_90d') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_90d integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_12m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_12m integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_24m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_24m integer default 0 null,' end
       || case when "lower"("interaction_type" || '_nonsaves_in_last_36m') = any(select "lower"("update_fields") from #update_fields) or "field_1" is null then "interaction_type" || '_nonsaves_in_last_36m integer default 0 null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  set "Target_Events" = case "Interaction_Type" when 'TA' then 'crr.Voice_Turnaround_Saved+crr.Voice_Turnaround_Not_Saved'
    when 'LiveChat' then 'crr.LiveChat_Turnaround_Saved+crr.LiveChat_Turnaround_Not_Saved+crr.web_messaging_turnaround_saved+crr.web_messaging_turnaround_not_saved'
    when 'All' then 'crr.Voice_Turnaround_Saved+crr.Voice_Turnaround_Not_Saved+crr.LiveChat_Turnaround_Saved+crr.LiveChat_Turnaround_Not_Saved+crr.web_messaging_turnaround_saved+crr.web_messaging_turnaround_not_saved' end;
  set "Target_Saves" = case "Interaction_Type" when 'TA' then 'crr.Voice_Turnaround_Saved'
    when 'LiveChat' then 'crr.LiveChat_Turnaround_Saved+crr.web_messaging_turnaround_saved'
    when 'All' then 'crr.Voice_Turnaround_Saved+crr.LiveChat_Turnaround_Saved+crr.web_messaging_turnaround_saved' end;
  set "Target_NonSaves" = case "Interaction_Type" when 'TA' then 'crr.Voice_Turnaround_Not_Saved'
    when 'LiveChat' then 'crr.LiveChat_Turnaround_Not_Saved+crr.web_messaging_turnaround_not_saved'
    when 'All' then 'crr.Voice_Turnaround_Not_Saved+crr.LiveChat_Turnaround_Not_Saved+crr.web_messaging_turnaround_not_saved' end;
  execute immediate 'Select distinct account_number, ' || "Obs_Dt_Field" || ' into #Acc_Obs_Dts from ' || "Output_Table_Name" || '' || case when "Where_Cond" is not null then ' Where ' end || "Where_Cond" || ' ' || ';';
  commit work;
  create hg index "idx_1" on #Acc_Obs_Dts("Account_number");
  execute immediate 'create date index idx_2 on #Acc_Obs_Dts(' || "Obs_Dt_Field" || ');';
  set "Dynamic_SQL" = ''
     || ' Select base.account_number,base.' || "Obs_Dt_Field" || ', '
     || 'min(Case when crr.event_dt > base.' || "Obs_Dt_Field" || ' and ' || "Target_Events" || ' > 0 then crr.event_dt end) as Next_Event_Dt, '
     || 'min(Case when crr.event_dt <= base.' || "Obs_Dt_Field" || ' and ' || "Target_Events" || ' > 0 then crr.event_dt end) as _1st_Event_Dt, '
     || 'min(Case when crr.event_dt <= base.' || "Obs_Dt_Field" || ' and ' || "Target_Saves" || ' > 0 then crr.event_dt end) as _1st_Save_Dt, '
     || 'min(Case when crr.event_dt <= base.' || "Obs_Dt_Field" || ' and ' || "Target_NonSaves" || ' > 0 then crr.event_dt end) as _1st_NonSave_Dt, '
     || 'max(Case when crr.event_dt <= base.' || "Obs_Dt_Field" || ' and ' || "Target_Events" || ' > 0 then crr.event_dt end) as _last_Event_Dt, '
     || 'max(Case when crr.event_dt <= base.' || "Obs_Dt_Field" || ' and ' || "Target_Saves" || ' > 0 then crr.event_dt end) as _last_Save_Dt, '
     || 'max(Case when crr.event_dt <= base.' || "Obs_Dt_Field" || ' and ' || "Target_NonSaves" || ' > 0 then crr.event_dt end) as _last_NonSave_Dt, '
    -- Events
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and dateadd(year,1,base.' || "Obs_Dt_Field" || ') ' || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Next_1Yr, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and base.' || "Obs_Dt_Field" || ' + 180 ' || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Next_180D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and base.' || "Obs_Dt_Field" || ' + 30 ' || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Next_30D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and base.' || "Obs_Dt_Field" || ' + 7 ' || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Next_7D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_24Hrs, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 6 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_7D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 13 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_14D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 29 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_30D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 59 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_60D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 89 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_90D,'
     || 'Sum(Case when crr.event_dt between dateadd(mm,-12,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_12M, '
     || 'Sum(Case when crr.event_dt between dateadd(mm,-24,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_24M, '
     || 'Sum(Case when crr.event_dt between dateadd(mm,-36,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Events" || ' else 0 end) as Events_In_Last_36M, '
    --Saves
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and base.' || "Obs_Dt_Field" || ' + 30 ' || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Next_30D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and base.' || "Obs_Dt_Field" || ' + 7 ' || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Next_7D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_24Hrs, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 6 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_7D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 13 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_14D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 29 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_30D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 59 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_60D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 89 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_90D,'
     || 'Sum(Case when crr.event_dt between dateadd(mm,-12,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_12M, '
     || 'Sum(Case when crr.event_dt between dateadd(mm,-24,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_24M, '
     || 'Sum(Case when crr.event_dt between dateadd(mm,-36,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_Saves" || ' else 0 end) as Saves_In_Last_36M, '
    --NonSaves
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and base.' || "Obs_Dt_Field" || ' + 30 ' || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Next_30D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' + 1 ' || ' and base.' || "Obs_Dt_Field" || ' + 7 ' || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Next_7D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_24Hrs, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 6 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_7D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 13 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_14D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 29 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_30D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 59 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_60D, '
     || 'Sum(Case when crr.event_dt between base.' || "Obs_Dt_Field" || ' - 89 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_90D,'
     || 'Sum(Case when crr.event_dt between dateadd(mm,-12,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_12M, '
     || 'Sum(Case when crr.event_dt between dateadd(mm,-24,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_24M, '
     || 'Sum(Case when crr.event_dt between dateadd(mm,-36,base.' || "Obs_Dt_Field" || ') + 1 ' || ' and base.' || "Obs_Dt_Field" || ' then ' || "Target_NonSaves" || ' else 0 end) as NonSaves_In_Last_36M '
     || ' into #Interactions '
     || ' from #Acc_Obs_Dts Base '
     || '        inner join '
     || '        CITeam.Turnaround_Attempts as crr '
     || ' on crr.account_number = base.account_number '
    --                         || '    and crr.event_dt <= base.' || Obs_Dt_Field || ' + 30 '
     || '    and ' || "Target_Events" || ' > 0 '
     || case when "Interaction_Type" = 'TA' then ' and crr.Voice_Turnaround_Saved+crr.Voice_Turnaround_Not_Saved > 0 '
    when "Interaction_Type" = 'LiveChat' then ' and crr.LiveChat_Turnaround_Saved+crr.LiveChat_Turnaround_Not_Saved+crr.web_messaging_turnaround_saved+crr.web_messaging_turnaround_not_saved > 0 '
    when "Interaction_Type" = 'All' then ' and crr.Voice_Turnaround_Saved+crr.Voice_Turnaround_Not_Saved+crr.LiveChat_Turnaround_Saved+crr.LiveChat_Turnaround_Not_Saved+crr.web_messaging_turnaround_saved+crr.web_messaging_turnaround_not_saved > 0 ' end
     || ' Group by base.account_number,base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #Interactions("Account_Number");
  set "Dynamic_SQL" = 'create date index idx_2 on #Interactions(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create date index "idx_3" on #Interactions("_1st_Event_Dt");
  create date index "idx_4" on #Interactions("_Last_Event_Dt");
  create date index "idx_5" on #Interactions("_1st_Save_Dt");
  create date index "idx_6" on #Interactions("_Last_Save_Dt");
  create date index "idx_7" on #Interactions("_1st_NonSave_Dt");
  create date index "idx_8" on #Interactions("_Last_NonSave_Dt");
  set "Dynamic_SQL" = ''
     || ' Select base.account_number,base.' || "Obs_Dt_Field" || ', '
    -- Attributes of events that we're interested in
     || ' crr.Outcome_Level_1_Description,crr.Attempt_Reason_Description_1,crr.Change_Attempt_Source as Site, '
    -- Flag if the record is an event of the required type on the required date
     || ' Case when crr.event_dt = base.Next_event_dt then 1 else 0 end as Is_Next_event_dt, '
     || ' Case when crr.event_dt = base._1st_event_dt then 1 else 0 end as Is_1st_event_dt, '
     || ' Case when crr.event_dt = base._last_event_dt then 1 else 0 end as Is_last_event_dt, '
     || ' Case when crr.event_dt = base._1st_event_dt and ' || "Target_Saves" || ' > 0 then 1 else 0 end as Is_1st_save_dt, '
     || ' Case when crr.event_dt = base._last_event_dt and ' || "Target_Saves" || ' > 0 then 1 else 0 end as Is_last_save_dt, '
     || ' Case when crr.event_dt = base._1st_event_dt and ' || "Target_NonSaves" || ' > 0 then 1 else 0 end as Is_1st_nonsave_dt, '
     || ' Case when crr.event_dt = base._last_event_dt and ' || "Target_NonSaves" || ' > 0 then 1 else 0 end as Is_last_nonsave_dt, '
    -- Rank the records for each type of event
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ',crr.event_dt order by Is_1st_event_dt desc, crr.change_attempt_sk asc)  _1st_Event_Rnk, '
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ',crr.event_dt order by Is_last_event_dt desc, crr.change_attempt_sk desc) Last_Event_Rnk, '
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ',crr.event_dt order by Is_next_event_dt desc, crr.change_attempt_sk desc) Next_Event_Rnk, '
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ',crr.event_dt order by Is_1st_save_dt desc, Case when ' || "Target_Saves" || ' > 0 then 1 else 0 end desc, crr.change_attempt_sk asc) _1st_Save_Rnk, '
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ',crr.event_dt order by Is_last_save_dt desc, Case when ' || "Target_Saves" || ' > 0 then 1 else 0 end desc, crr.change_attempt_sk desc) Last_Save_Rnk,'
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ',crr.event_dt order by Case when ' || "Target_NonSaves" || ' > 0 then 1 else 0 end desc, crr.change_attempt_sk asc) _1st_NonSave_Rnk,'
     || 'Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ',crr.event_dt order by Case when ' || "Target_NonSaves" || ' > 0 then 1 else 0 end desc, crr.change_attempt_sk desc) Last_NonSave_Rnk '
     || ' into #Interaction_Details '
     || ' from #Interactions Base '
     || '      inner join '
     || '      CITeam.Turnaround_Attempts as crr '
     || '      on crr.account_number = base.account_number '
     || '         and (   crr.event_dt = base._1st_event_dt   or crr.event_dt = base._last_event_dt '
     || '              or crr.event_dt = base._1st_save_dt    or crr.event_dt = base._last_save_dt '
    --                         || '              or crr.event_dt = base.Next_event_dt '
     || '              or crr.event_dt = base._1st_nonsave_dt or crr.event_dt = base._last_nonsave_dt) '
     || '         and ' || "Target_Events" || ' > 0 ';
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #Interaction_Details("Account_Number");
  set "Dynamic_SQL" = 'create date index idx_2 on #Interaction_Details(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' Base '
     || ' Set '
     || case when "lower"('Next_' || "Interaction_Type" || '_dt') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Next_' || "Interaction_Type" || '_dt = i.Next_event_dt,' end
     || case when "lower"('_1st_' || "Interaction_Type" || '_dt') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_' || "Interaction_Type" || '_dt = i._1st_event_dt,' end
     || case when "lower"('last_' || "Interaction_Type" || '_dt') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_' || "Interaction_Type" || '_dt = i._Last_event_dt,' end
     || case when "lower"('_1st_' || "Interaction_Type" || '_save_dt') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_' || "Interaction_Type" || '_Save_Dt = i._1st_Save_dt,' end
     || case when "lower"('last_' || "Interaction_Type" || '_save_dt') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_' || "Interaction_Type" || '_Save_Dt = i._Last_Save_dt,' end
     || case when "lower"('_1st_' || "Interaction_Type" || '_nonsave_dt') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_' || "Interaction_Type" || '_NonSave_Dt = i._1st_NonSave_dt,' end
     || case when "lower"('last_' || "Interaction_Type" || '_nonsave_dt') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_' || "Interaction_Type" || '_NonSave_Dt = i._Last_NonSave_dt,' end
     || case when "lower"("Interaction_Type" || 's_in_last_24hrs') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_24Hrs = i.Events_In_Last_24Hrs,' end
     || case when "lower"("Interaction_Type" || 's_in_last_7d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_7D = i.Events_In_Last_7D,' end
     || case when "lower"("Interaction_Type" || 's_in_last_14d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_14D = i.Events_In_Last_14D,' end
     || case when "lower"("Interaction_Type" || 's_in_last_30d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_30D = i.Events_In_Last_30D,' end
     || case when "lower"("Interaction_Type" || 's_in_last_60d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_60D = i.Events_In_Last_60D,' end
     || case when "lower"("Interaction_Type" || 's_in_last_90d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_90D = i.Events_In_Last_90D,' end
     || case when "lower"("Interaction_Type" || 's_in_last_12m') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_12M = i.Events_In_Last_12M,' end
     || case when "lower"("Interaction_Type" || 's_in_last_24m') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_24M = i.Events_In_Last_24M,' end
     || case when "lower"("Interaction_Type" || 's_in_last_36m') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Last_36M = i.Events_In_Last_36M,' end
     || case when "lower"("Interaction_Type" || 's_in_next_7d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Next_7D = i.Events_In_Next_7D,' end
     || case when "lower"("Interaction_Type" || 's_in_next_30d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Next_30D = i.Events_In_Next_30D,' end
     || case when "lower"("Interaction_Type" || 's_in_next_180d') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Next_180D = i.Events_In_Next_180D,' end
     || case when "lower"("Interaction_Type" || 's_in_next_1yr') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || 's_In_Next_1yr = i.Events_In_Next_1yr,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_24Hrs') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_24Hrs = i.Saves_In_Last_24Hrs,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_7D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_7D = i.Saves_In_Last_7D,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_14D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_14D = i.Saves_In_Last_14D,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_30D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_30D = i.Saves_In_Last_30D,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_60D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_60D = i.Saves_In_Last_60D,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_90D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_90D = i.Saves_In_Last_90D,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_12M') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_12M = i.Saves_In_Last_12M,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_24M') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_24M = i.Saves_In_Last_24M,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Last_36M') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Last_36M = i.Saves_In_Last_36M,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Next_7D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Next_7D = i.Saves_In_Next_7D,' end
     || case when "lower"("Interaction_Type" || '_Saves_In_Next_30D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_Saves_In_Next_30D = i.Saves_In_Next_30D,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_24Hrs') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_24Hrs = i.NonSaves_In_Last_24Hrs,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_7D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_7D = i.NonSaves_In_Last_7D,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_14D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_14D = i.NonSaves_In_Last_14D,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_30D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_30D = i.NonSaves_In_Last_30D,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_60D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_60D = i.NonSaves_In_Last_60D,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_90D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_90D = i.NonSaves_In_Last_90D,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_12M') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_12M = i.NonSaves_In_Last_12M,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_24M') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_24M = i.NonSaves_In_Last_24M,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Last_36M') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Last_36M = i.NonSaves_In_Last_36M,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Next_7D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Next_7D = i.NonSaves_In_Next_7D,' end
     || case when "lower"("Interaction_Type" || '_NonSaves_In_Next_30D') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Interaction_Type" || '_NonSaves_In_Next_30D = i.NonSaves_In_Next_30D,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    execute immediate
      "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' Base '
       || ' inner join '
       || ' #Interactions i '
       || ' on i.account_number = base.account_number '
       || '    and i.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
  end if;
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' Base '
     || ' Set '
     || case when '_1st_' || "Interaction_Type" || '_reason' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_' || "Interaction_Type" || '_Reason = i.Attempt_Reason_Description_1,' end
     || case when '_1st_' || "Interaction_Type" || '_outcome' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_' || "Interaction_Type" || '_Outcome = i.Outcome_Level_1_Description,' end
     || case when '_1st_' || "Interaction_Type" || '_site' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_' || "Interaction_Type" || '_site = i.site,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    execute immediate
      "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' Base '
       || ' inner join '
       || ' #Interaction_Details i '
       || ' on i.account_number = base.account_number '
       || '    and i.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    and i.Is_1st_event_dt = 1 '
       || '    and i._1st_Event_Rnk = 1 '
  end if;
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' Base '
     || ' Set '
     || case when '_last_' || "Interaction_Type" || '_reason' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_' || "Interaction_Type" || '_Reason = i.Attempt_Reason_Description_1,' end
     || case when '_last_' || "Interaction_Type" || '_outcome' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_' || "Interaction_Type" || '_Outcome = i.Outcome_Level_1_Description,' end
     || case when '_last_' || "Interaction_Type" || '_site' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_' || "Interaction_Type" || '_site = i.site,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    execute immediate
      "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' Base '
       || ' inner join '
       || ' #Interaction_Details i '
       || ' on i.account_number = base.account_number '
       || '    and i.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    and i.Is_last_event_dt = 1 '
       || '    and i.last_Event_Rnk = 1 '
  end if
end
