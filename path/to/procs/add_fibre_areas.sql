create procedure "Decisioning_procs"."Add_Fibre_Areas"( in "Output_Table_Name" varchar(100),
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
  in "Field_10" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Target_Table" varchar(100);
  declare "Update_Fields_SQL" long varchar;
  declare "Field_Num" integer;
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10");
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when 'skyfibre_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_enabled''' end
       || case when 'skyfibre_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_enabled_date''' end
       || case when 'skyfibre_enabled_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_enabled_perc''' end
       || case when 'skyfibre_estimated_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_estimated_enabled_date''' end
       || case when 'skyfibre_planned_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_planned_perc''' end
       || case when 'max_speed_uplift' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''max_speed_uplift''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when 'skyfibre_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_enabled''' end
       || case when 'skyfibre_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_enabled_date''' end
       || case when 'skyfibre_enabled_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_enabled_perc''' end
       || case when 'skyfibre_estimated_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_estimated_enabled_date''' end
       || case when 'skyfibre_planned_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''skyfibre_planned_perc''' end
       || case when 'max_speed_uplift' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''max_speed_uplift''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL"
       = ' Alter table ' || "Output_Table_Name"
       || ' Add( '
       || case when 'skyfibre_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'skyfibre_enabled varchar(1) default null,' end
       || case when 'skyfibre_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'skyfibre_enabled_date date default null,' end
       || case when 'skyfibre_enabled_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'skyfibre_enabled_perc decimal(10,2) default null,' end
       || case when 'skyfibre_estimated_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'skyfibre_estimated_enabled_date date default null,' end
       || case when 'skyfibre_planned_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'skyfibre_planned_perc decimal(10,2) default null,' end
       || case when 'max_speed_uplift' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'max_speed_uplift decimal(8,2) default null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name"
     || ' Set '
     || case when 'skyfibre_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' skyfibre_enabled = fibre.x_skyfibre_enabled,'
    else ''
    end
     || case when 'skyfibre_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'skyfibre_enabled_date = fibre.x_skyfibre_enabled_date, '
    else ''
    end
     || case when 'skyfibre_enabled_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' skyfibre_enabled_perc = fibre.x_skyfibre_enabled_perc,'
    else ''
    end
     || case when 'skyfibre_estimated_enabled_date' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'skyfibre_estimated_enabled_date = fibre.x_skyfibre_estimated_enabled_date,'
    else ''
    end
     || case when 'skyfibre_planned_perc' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'skyfibre_planned_perc = fibre.x_skyfibre_planned_perc,'
    else ''
    end
     || case when 'max_speed_uplift' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      ' max_speed_uplift = fibre.max_speed_uplift,'
    else ''
    end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' from ' || "Output_Table_Name" || ' as base'
     || '     inner join'
     || '     cust_single_account_view sav'
     || '     on sav.account_number = base.account_number'
     || '     left join'
     || '     BT_FIBRE_POSTCODE fibre'
     || '     on sav.cb_address_postcode = fibre.cb_address_postcode';
  execute immediate "Dynamic_SQL"
end
