create procedure "Decisioning_Procs"."Add_Simple_Segments"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Populate_Unassigned" varchar(30) default 'Hist Segments Only',
  in "Field_Update_Type" varchar(30) default 'Drop and Replace',
  in "Field_1" varchar(100) default null,
  in "Field_2" varchar(100) default null,
  in "Field_3" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Field_num" integer;
  declare "Interaction_Fieldname" varchar(100);
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1");
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL"
     || case when "LOWER"('_1st_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Country''' end
     || case when "LOWER"('Simple_Segment') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Simple_Segment''' end
     || case when "LOWER"('Simple_Seg_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Simple_Seg_Type''' end
     || ')';
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    execute immediate "Dynamic_SQL"
  end if;
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ''
       || ' Alter Table ' || "Output_Table_Name" || ' Add('
       || case when "LOWER"('Country') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Country varchar(3) default ''UK'',' end
       || case when "LOWER"('Simple_Segment') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Simple_Segment varchar(50) default null,' end
       || case when "LOWER"('Simple_Seg_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Simple_Seg_Type varchar(50) default null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL" = ''
     || ' update ' || "Output_Table_Name" || ' a '
     || ' set Country = Case when b.fin_ph_subs_currency_code  = ''EUR'' then ''ROI'' '
     || ' when b.fin_ph_subs_currency_code  = ''GBP'' then ''UK'' '
     || ' end '
     || ' from ' || "Output_Table_Name" || ' a '
     || '      inner join '
     || '      Cust_Single_Account_View b '
     || '      on a.account_number =  b.account_number ';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = ''
     || ' update ' || "Output_Table_Name" || ' a '
     || ' set a.simple_segment = b.segment, '
     || '     a.simple_seg_type = ''Assigned-R1'' '
     || ' from ' || "Output_Table_Name" || ' a '
     || '      inner join '
     || '      simple_segments_history b '
     || '      on a.account_number =  b.account_number '
     || '         and b.observation_date between a.' || "Obs_Dt_Field" || ' -90 and a.' || "Obs_Dt_Field"
     || '         and a.Country = ''UK'' ';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = ''
     || ' update ' || "Output_Table_Name" || ' a '
     || ' set a.simple_segment = b.segment, '
     || '     a.simple_seg_type = ''Assigned-R1'' '
     || ' from ' || "Output_Table_Name" || ' a '
     || '      inner join '
     || '      simple_segments_history_roi b '
     || '      on a.account_number =  b.account_number '
     || '         and b.observation_date between a.' || "Obs_Dt_Field" || ' -90 and a.' || "Obs_Dt_Field"
     || '         and a.Country = ''ROI'' ';
  execute immediate "Dynamic_SQL";
  if "Populate_Unassigned" = 'Future Segment if Null' then
    set "Dynamic_SQL" = ''
       || ' update ' || "Output_Table_Name" || ' a '
       || ' set a.simple_segment = b.segment, '
       || '     a.simple_seg_type = ''Assigned-R2'' '
       || ' from ' || "Output_Table_Name" || ' a '
       || '      inner join '
       || '      simple_segments_history b '
       || '      on a.account_number =  b.account_number '
       || '         and b.observation_date between a.' || "Obs_Dt_Field" || ' and a.' || "Obs_Dt_Field" || ' +90 '
       || '         and a.simple_segment is null '
       || '         and a.Country = ''UK'' ';
    execute immediate "Dynamic_SQL";
    set "Dynamic_SQL" = ''
       || ' update ' || "Output_Table_Name" || ' a'
       || ' set a.simple_segment = b.segment, '
       || '     a.simple_seg_type = ''Assigned-R2'' '
       || ' from ' || "Output_Table_Name" || ' a '
       || '      inner join '
       || '      simple_segments_history_roi b '
       || '      on a.account_number =  b.account_number '
       || '         and b.observation_date between a.' || "Obs_Dt_Field" || ' and a.' || "Obs_Dt_Field" || ' +90 '
       || '         and a.simple_segment is null '
       || '         and a.Country = ''ROI'' ';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL" = ''
     || ' update ' || "Output_Table_Name" || ' a '
     || ' set a.simple_segment = ''Non Normal'' '
     || ' from ' || "Output_Table_Name" || ' a '
     || '      inner join '
     || '      cust_single_account_view b '
     || '      on a.account_number = b.account_number '
     || '         and a.simple_segment is null '
     || '         and b.acct_sub_type <> ''Normal'' ';
  execute immediate "Dynamic_SQL"
end
