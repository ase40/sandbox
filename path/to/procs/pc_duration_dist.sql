create procedure "Decisioning_Procs"."PC_Duration_Dist"( in "Forecast_Start_Week" integer,in "Hist_Weeks" integer ) 
sql security invoker
begin
  select "event_dt"-"datepart"("weekday","event_dt"+2) as "PC_Event_End_Dt",
    "PC_Effective_To_Dt"-"datepart"("weekday","PC_Effective_To_Dt"+2) as "PC_Effective_To_End_Dt",
    "PC_Future_Sub_Effective_Dt"-"datepart"("weekday","PC_Future_Sub_Effective_Dt"+2) as "PC_Future_Sub_End_Dt",
    "PC_Future_Sub_Effective_Dt"-"PC_Event_End_Dt" as "Days_To_churn"
    into #PC_Events_Days_To_Intended_Churn
    from "citeam"."PL_Entries_DTV"
    where "event_dt" between(select "min"("calendar_date"-"Hist_Weeks"*7) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Week")
    and(select "min"("calendar_date"-1) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Week")
    and "PC_Pipeline_Cancellation" > 0
    and "PC_Future_Sub_Effective_Dt" > "event_dt";
  drop table if exists "DTV_PC_Duration_Dist";
  select "Days_To_churn",
    "Row_number"() over(order by "Days_To_churn" asc) as "Row_ID",
    "count"() as "PCs",
    "sum"("PCs") over() as "Total_PCs",
    "sum"("PCs") over(order by "Days_To_churn" asc) as "Cum_PCs",
    cast("Cum_PCs"-"PCs" as real)/"Total_PCs" as "PC_Days_Lower_Prcntl",
    cast("Cum_PCs" as real)/"Total_PCs" as "PC_Days_Upper_Prcntl"
    into "DTV_PC_Duration_Dist"
    from #PC_Events_Days_To_Intended_Churn
    group by "Days_To_churn"
    order by "Days_To_churn" asc
end
