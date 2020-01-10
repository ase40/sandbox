create procedure "Decisioning_Procs"."Create_Seasonality_Estimates"( 
  "Input_Metric" varchar(30),
  "Training_Wk_1" integer default null,
  "Training_Wk_2" integer default null,
  "Training_Wk_3" integer default null,
  "Training_Wk_4" integer default null,
  "Training_Wk_5" integer default null,
  "Training_Wk_6" integer default null,
  "Training_Wk_7" integer default null,
  "Training_Wk_8" integer default null,
  "Training_Wk_9" integer default null,
  "Training_Wk_10" integer default null,
  "Training_Wk_11" integer default null,
  "Training_Wk_12" integer default null,
  "Training_Wk_13" integer default null,
  "Training_Wk_14" integer default null,
  "Training_Wk_15" integer default null,
  "Training_Wk_16" integer default null,
  "Training_Wk_17" integer default null,
  "Training_Wk_18" integer default null,
  "Training_Wk_19" integer default null,
  "Training_Wk_20" integer default null,
  "Training_Wk_21" integer default null,
  "Training_Wk_22" integer default null,
  "Training_Wk_23" integer default null,
  "Training_Wk_24" integer default null,
  "Training_Wk_25" integer default null,
  "Training_Wk_26" integer default null ) 
sql security invoker
begin
  declare "Training_Wk_i" integer;
  declare "Dynamic_SQL" long varchar;
  declare "i" integer;
  declare "var" integer;
  create table #TA_Training_Wks(
    "Subs_Wk" integer null,);
  set "i" = 1;
  set "Training_Wk_i" = "Training_Wk_1";
  while "Training_Wk_i" is not null loop
    insert into #TA_Training_Wks
      select "Training_Wk_i";
    set "i" = "i"+1;
    execute immediate 'Set Training_Wk_i = Training_Wk_' || "i"
  end loop;
  if "object_id"('Fcast_Seasonality_Adjustments') is null then
    execute immediate 'Create table ' || current user || '.Fcast_Seasonality_Adjustments (Subs_Week integer);';
    insert into "Fcast_Seasonality_Adjustments" select distinct "subs_week_of_year" as "Subs_Week" from "sky_calendar" where "subs_week_of_year" <= 52;
    commit work;
    execute immediate 'create lf index idx_1 on ' || current user || '.Fcast_Seasonality_Adjustments(Subs_Week);'
  end if;
  drop table if exists #Metric_Vars_In_Table;
  select *,"Row_Number"() over(order by "column_name" asc) as "RowNum" into #Metric_Vars_In_Table from "sp_columns"('Fcast_Seasonality_Adjustments') where "table_owner" = current user and "column_name" like "Input_Metric" || '_Adj:%';
  set "Dynamic_SQL" = 'Alter table ' || current user || '.Fcast_Seasonality_Adjustments ';
  set "i" = 1;
  while "i" <= (select "count"() from #Metric_Vars_In_Table) loop
    set "Dynamic_SQL" = "Dynamic_SQL" || ' Drop '
       || '"' || (select "max"("column_name") from #Metric_Vars_In_Table where "RowNum" = "i") || '",';
    set "i" = "i"+1
  end loop;
  if "Right"("Dynamic_SQL",1) = ',' then execute immediate "left"("Dynamic_SQL","len"("Dynamic_SQL")-1) end if;
  drop table if exists #Metric_Variables;
  select "Variable","Row_Number"() over(order by "Variable" asc) as "Var_ID"
    into #Metric_Variables
    from "Decisioning"."FORECAST_Seasonality_Estimates"
    where "Metric" = "Input_Metric"
    group by "Variable";
  set "Dynamic_SQL" = 'Alter table Fcast_Seasonality_Adjustments Add(';
  set "i" = 1;
  while "i" <= (select "count"() from #Metric_Variables) loop
    set "Dynamic_SQL" = "Dynamic_SQL"
       || '"' || "Input_Metric" || '_Adj: ' || (select "max"("Variable") from #Metric_Variables where "Var_ID" = "i") || '"'
       || ' numeric(12,10) default null,';
    set "i" = "i"+1
  end loop;
  if "Right"("Dynamic_SQL",1) = ',' then execute immediate "left"("Dynamic_SQL","len"("Dynamic_SQL")-1) || ')' end if;
  drop table if exists #TA_Training_Seasonality;
  select "Variable","Avg"("Seasonality_Estimate") as "Avg_Training_Seasonality"
    into #TA_Training_Seasonality
    from #TA_Training_Wks as "tw"
      join "Decisioning"."FORECAST_Seasonality_Estimates" as "fse"
      on "fse"."subs_week" = "remainder"("tw"."subs_wk",100)
    where "Metric" = "Input_Metric"
    group by "Variable";
  set "i" = 1;
  while "i" <= (select "count"() from #Metric_Variables) loop
    set "Dynamic_SQL"
       = ' Update Fcast_Seasonality_Adjustments fsa'
       || ' Set ' || '"' || "Input_Metric" || '_Adj: ' || (select "max"("Variable") from #Metric_Variables where "Var_ID" = "i") || '"'
       || ' = fse.Seasonality_Estimate / ts.Avg_Training_Seasonality - 1'
       || ' from Fcast_Seasonality_Adjustments fsa '
       || '      inner join '
       || '      Decisioning.FORECAST_Seasonality_Estimates fse '
       || '      on fse.subs_week = fsa.Subs_Week '
       || '         and fse.Metric = ''' || "Input_Metric" || ''''
       || '         and fse."variable" = ''' || (select "max"("Variable") from #Metric_Variables where "Var_ID" = "i") || ''''
       || '      inner join '
       || '      #TA_Training_Seasonality ts '
       || '      on ts."Variable" = ''' || (select "max"("Variable") from #Metric_Variables where "Var_ID" = "i") || '''';
    execute immediate "Dynamic_SQL";
    set "i" = "i"+1
  end loop
end
