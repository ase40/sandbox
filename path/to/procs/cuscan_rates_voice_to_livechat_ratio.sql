create procedure "Decisioning_Procs"."CusCan_Rates_Voice_To_LiveChat_Ratio"( in "WebChat_Trend_Start_Wk" integer,in "WebChat_Trend_End_Wk" integer,out "Avg_Normalised_Voice_to_LiveChat_Ratio" real ) 
sql security invoker
begin
  drop table if exists #Actual_Voice_to_LiveChat_Ratio;
  select "crr"."Subs_Week_And_Year",
    cast("Demand_Resource" as real)/"Planned_Resource" as "demand_vs_planned",
    "sum"("LiveChat_Turnaround_Saved"+"LiveChat_Turnaround_Not_Saved") as "WebChat_events",
    "sum"("Voice_Turnaround_Saved"+"Voice_Turnaround_Not_Saved"+"LiveChat_Turnaround_Saved"+"LiveChat_Turnaround_Not_Saved") as "TA_events",
    cast("WebChat_events" as real)/"TA_events" as "Actual_Voice_to_LiveChat_Ratio",
    "Actual_Voice_to_LiveChat_Ratio"*"demand_vs_planned" as "Normalised_Voice_to_LiveChat_Ratio"
    into #Normalised_Voice_to_LiveChat_Ratio
    from "CITeam"."Turnaround_Attempts" as "crr"
      left outer join "CITeam"."Agent_Resource_Plan_vs_Actual" as "arp"
      on "crr"."Subs_Week_And_Year" = "arp"."Subs_Week_And_Year"
    where "crr"."Subs_Week_And_Year" between "WebChat_Trend_Start_Wk" and "WebChat_Trend_End_Wk"
    group by "crr"."Subs_Week_And_Year","demand_vs_planned";
  set "Avg_Normalised_Voice_to_LiveChat_Ratio" = (select "avg"("Normalised_Voice_to_LiveChat_Ratio") from #Normalised_Voice_to_LiveChat_Ratio)
end
