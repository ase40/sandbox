create procedure "Decisioning_Procs"."Forecast_PC_Conversion_Rates"( in "Srt_Wk" integer,in "End_Wk" integer ) 
sql security invoker
begin
  set temporary option "Query_Temp_Space_Limit" = 0;
  select "account_number",
    "subs_week_and_year",
    "event_dt",
    "sum"("Voice_Turnaround_Saved"+"Voice_Turnaround_Not_Saved") as "TA_Events",
    "sum"("LiveChat_Turnaround_Saved"+"LiveChat_Turnaround_Not_Saved") as "LiveChat_Events",
    cast(0 as tinyint) as "TA_Event_DTV_PCs",
    cast(0 as tinyint) as "TA_Event_DTV_SDCs",
    cast(0 as tinyint) as "LiveChat_DTV_PCs",
    cast(0 as tinyint) as "LiveChat_DTV_SDCs"
    into #PCs_By_Channel
    from "CITeam"."Turnaround_Attempts" as "crr"
    where "crr"."Subs_Week_And_Year" between "Srt_Wk" and "End_Wk"
    and "Voice_Turnaround_Saved"+"Voice_Turnaround_Not_Saved"+"LiveChat_Turnaround_Saved"+"LiveChat_Turnaround_Not_Saved" > 0
    group by "account_number",
    "subs_week_and_year",
    "event_dt";
  update #PCs_By_Channel as "crr"
    set "TA_Event_DTV_PCs" = case when "crr"."TA_Events" > 0 and "mor"."PC_Pipeline_Cancellation" > 0 then "mor"."PC_Pipeline_Cancellation" else 0 end,
    "TA_Event_DTV_SDCs" = case when "crr"."TA_Events" > 0 and "mor"."Same_Day_Cancel" > 0 then "mor"."Same_Day_Cancel" else 0 end,
    "LiveChat_DTV_PCs" = case when "crr"."TA_Events" = 0 and "crr"."LiveChat_Events" > 0 and "mor"."PC_Pipeline_Cancellation" > 0 then "mor"."PC_Pipeline_Cancellation" else 0 end,
    "LiveChat_DTV_SDCs" = case when "crr"."TA_Events" = 0 and "crr"."LiveChat_Events" > 0 and "mor"."Same_Day_Cancel" > 0 then "mor"."Same_Day_Cancel" else 0 end from
    #PCs_By_Channel as "crr"
    join "CITeam"."PL_Entries_DTV" as "mor"
    on "mor"."account_number" = "crr"."account_number"
    and "mor"."event_dt" = "crr"."event_dt"
    and "mor"."PC_Pipeline_Cancellation"+"mor"."Same_Day_Cancel" > 0;
  select "account_number",
    "subs_week_and_year",
    "event_dt",
    "sum"("PC_Pipeline_Cancellation") as "PC_Pending_Cancellations",
    "sum"("Same_Day_Cancel") as "Same_Day_Cancels"
    into #Total_PCs
    from "CITeam"."PL_Entries_DTV" as "mor"
    where("Subs_Week_And_Year" between "Srt_Wk" and "End_Wk"
    and "mor"."PC_Pipeline_Cancellation" > 0 or "mor"."Same_Day_Cancel" > 0)
    group by "account_number",
    "subs_week_and_year",
    "event_dt";
  insert into #PCs_By_Channel
    select "tpc"."account_number",
      "tpc"."subs_week_and_year",
      "tpc"."event_dt",
      0 as "TA_Events",
      0 as "LiveChat_Events",
      cast(0 as tinyint) as "TA_Event_DTV_PCs",
      cast(0 as tinyint) as "TA_Event_DTV_SDCs",
      cast(0 as tinyint) as "LiveChat_DTV_PCs",
      cast(0 as tinyint) as "LiveChat_DTV_SDCs"
      from #Total_PCs as "tpc"
        left outer join #PCs_By_Channel as "pcc"
        on "pcc"."account_number" = "tpc"."account_number"
        and "pcc"."event_dt" = "tpc"."event_dt"
      where "pcc"."event_dt" is null;
  select "subs_week_and_year","account_number",
    "sum"("TA_Events") as "TA_Events",
    "sum"("LiveChat_Events") as "LiveChat_Events",
    "sum"("TA_Event_DTV_PCs") as "TA_Event_DTV_PCs",
    "sum"("TA_Event_DTV_SDCs") as "TA_Event_DTV_SDCs",
    "sum"("LiveChat_DTV_PCs") as "LiveChat_DTV_PCs",
    "sum"("LiveChat_DTV_SDCs") as "LiveChat_DTV_SDCs"
    into #Weekly_TA_Events
    from #PCs_By_Channel as "crr"
    group by "subs_week_and_year","account_number";
  drop table if exists "TA_DTV_PC_Vol";
  select "Cuscan_forecast_segment",
    "sum"("TA_Events") as "TA_Events",
    "sum"("LiveChat_Events") as "LiveChat_Events",
    "sum"("TA_Event_DTV_PCs") as "Total_TA_DTV_PC",
    "sum"("TA_Event_DTV_PCs") as "Total_TA_DTV_PC_Adj",
    "sum"("TA_Event_DTV_SDCs") as "Total_TA_DTV_SDC",
    "sum"("LiveChat_DTV_PCs") as "Total_WC_DTV_PC",
    "sum"("LiveChat_DTV_SDCs") as "Total_WC_DTV_SDC",
    "Sum"(case when "TA"."TA_Events" > 0 then 1 else 0 end) as "Total_TA_Cust",
    "Sum"(case when "TA"."LiveChat_Events" > 0 then 1 else 0 end) as "Total_WC_Cust",
    "Count"() as "Total_Cust",
    case when "Total_TA_Cust" > 0 then cast("Total_TA_DTV_PC" as real)/"Total_TA_Cust" else 0 end as "Raw_TA_DTV_PC_Conv_Rate",
    case when "Total_TA_Cust" > 0 then cast("Total_TA_DTV_PC" as real)/"Total_TA_Cust" else 0 end as "Norm_TA_DTV_PC_Conv_Rate",
    case when "Total_TA_Cust" > 0 then cast("Total_TA_DTV_SDC" as real)/"Total_TA_Cust" else 0 end as "Raw_TA_DTV_SDC_Conv_Rate",
    case when "Total_WC_Cust" > 0 then cast("Total_WC_DTV_PC" as real)/"Total_WC_Cust" else 0 end as "WC_DTV_PC_Conv_Rate",
    case when "Total_WC_Cust" > 0 then cast("Total_WC_DTV_SDC" as real)/"Total_WC_Cust" else 0 end as "WC_DTV_SDC_Conv_Rate"
    into "TA_DTV_PC_Vol"
    from "CITeam"."DTV_Fcast_Weekly_Base" as "base"
      left outer join #Weekly_TA_Events as "TA"
      on "base"."account_number" = "TA"."account_number"
      and "base"."subs_week_and_year" = "TA"."subs_week_and_year"
    where "base"."Subs_Week_And_Year" between "Srt_Wk" and "End_Wk"
    and "base"."Downgrade_View" = 'Actuals'
    and "DTV_Active" > 0
    group by "Cuscan_forecast_segment";
  commit work;
  create hg index "idx_1" on "TA_DTV_PC_Vol"("Cuscan_forecast_segment")
end
