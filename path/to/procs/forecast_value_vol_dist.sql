create procedure "Decisioning_Procs"."Forecast_Value_Vol_Dist"( in "Forecast_Start_Wk" integer,in "Num_Wks" integer ) 
sql security invoker
begin
  set temporary option "Query_Temp_Space_Limit" = 0;
  drop table if exists #Value;
  select "account_number","interaction_dt" as "event_dt",
    cast("event_dt"-"datepart"("weekday","event_dt"+2) as date) as "event_end_dt",
    cast(null as varchar(100)) as "CusCan_Forecast_Segment"
    into #Value
    from "citeam"."Calls_Answered" as "crr"
    where "interaction_dt" between(select "max"("calendar_date"-7-6*7+1) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and(select "max"("calendar_date"-7) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and "Value_Call" > 0;
  commit work;
  create hg index "idx_1" on #Value("Account_Number");
  create date index "idx_2" on #Value("event_dt");
  create date index "idx_3" on #Value("event_end_dt");
  update #Value as "crr"
    set "CusCan_ForeCast_Segment" = "base"."CusCan_ForeCast_Segment" from
    #Value as "crr"
    join "CITeam"."DTV_Fcast_Weekly_Base" as "base"
    on "crr"."account_number" = "base"."account_number"
    and "crr"."event_end_dt" = "base"."end_date"
    and "base"."downgrade_view" = 'Actuals';
  drop table if exists #Acc_Value_Call_Vol;
  select "event_end_dt" as "end_date",
    "CusCan_ForeCast_Segment",
    "count"() as "Value_Call_Count"
    into #Acc_Value_Call_Vol
    from #Value
    where "CusCan_ForeCast_Segment" is not null
    group by "end_date","account_number","CusCan_ForeCast_Segment";
  commit work;
  drop table if exists "Value_Call_Dist";
  select "CusCan_ForeCast_Segment",
    "Value_Call_Count",
    cast("count"() as integer) as "Value_Custs",
    "Sum"("Value_Custs") over(partition by "CusCan_ForeCast_Segment") as "Total_Value_Custs",
    "Sum"("Value_Custs") over(partition by "CusCan_ForeCast_Segment" order by
    "Value_Custs"*10000000000 desc) as "Cum_Value_Custs",
    cast("Cum_Value_Custs"-"Value_Custs" as numeric(30,18))/"Total_Value_Custs" as "Value_Dist_Lower_Pctl",
    cast("Cum_Value_Custs" as numeric(30,18))/"Total_Value_Custs" as "Value_Dist_Upper_Pctl"
    into "Value_Call_Dist"
    from #Acc_Value_Call_Vol
    group by "CusCan_ForeCast_Segment",
    "Value_Call_Count";
  commit work;
  create lf index "idx_1" on "Value_Call_Dist"("CusCan_ForeCast_Segment")
end
