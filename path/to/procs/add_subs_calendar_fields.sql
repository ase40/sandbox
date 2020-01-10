create procedure "Decisioning_Procs"."Add_Subs_Calendar_Fields"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Field_Update_Type" varchar(30) default 'Drop and Replace', --'Rename and Replace','Update Only'
  in "Field_1" varchar(100) default null,
  in "Field_2" varchar(100) default null,
  in "Field_3" varchar(100) default null,
  in "Field_4" varchar(100) default null,
  in "Field_5" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Field_num" integer;
  declare "Field_Name" varchar(100);
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1");
  -- ,Field_2,Field_3,Field_4,Field_5
  -- Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when 'subs_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_year''' end
       || case when 'subs_week_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_week_of_year''' end
       || case when 'subs_quarter_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_quarter_of_year''' end
       || case when 'subs_week_and_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_week_and_year''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when 'subs_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_year''' end
       || case when 'subs_week_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_week_of_year''' end
       || case when 'subs_quarter_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_quarter_of_year''' end
       || case when 'subs_week_and_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''subs_week_and_year''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  -- Add Fields
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL"
       = ' Alter table ' || "Output_Table_Name"
       || ' Add( '
       || case when 'subs_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Subs_Year smallint default null null,' end
       || case when 'subs_week_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Subs_Week_Of_Year smallint default null null,' end
       || case when 'subs_quarter_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Subs_Quarter_Of_Year tinyint default null null,' end
       || case when 'subs_week_and_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Subs_Week_And_Year integer default null null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name"
     || ' Set '
     || case when 'subs_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Subs_Year = sc.Subs_Year,'
    else ''
    end
     || case when 'subs_week_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Subs_Week_Of_Year = sc.Subs_Week_Of_Year,'
    else ''
    end
     || case when 'subs_quarter_of_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Subs_Quarter_Of_Year = sc.Subs_Quarter_Of_Year,'
    else ''
    end
     || case when 'subs_week_and_year' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Subs_Week_And_Year = Cast(sc.Subs_Week_And_Year as integer),'
    else ''
    end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' from ' || "Output_Table_Name" || ' Base '
     || ' inner join '
     || ' sky_calendar sc '
     || ' on sc.calendar_date = ' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL"
end
