create procedure "Decisioning_Procs"."Intraweek_PCs_Dist"( in "Forecast_Start_Week" integer,in "Hist_Wks" integer ) 
sql security invoker
begin
  drop table if exists #Acc_PC_Events_Same_Week;
  select "subs_week_and_year",
    "event_dt",
    "event_dt"-"datepart"("weekday","event_dt"+2) as "PC_Event_End_Dt",
    "PC_Effective_To_Dt",
    "PC_Effective_To_Dt"-"datepart"("weekday","PC_Effective_To_Dt"+2) as "PC_Effective_To_End_Dt",
    "mor"."account_number",
    "MoR"."PC_Next_Status_Code" as "Next_Status_Code",
    cast(0 as bit) as "PC_ReAC_Offer_Applied"
    into #Acc_PC_Events_Same_Week
    from "CITeam"."PL_Entries_DTV" as "MoR"
    where "event_dt" between(select "min"("calendar_date"-"Hist_Wks"*7) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Week")
    and(select "min"("calendar_date"-1) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Week")
    and "PC_Pipeline_Cancellation" > 0;
  commit work;
  create hg index "idx_1" on #Acc_PC_Events_Same_Week("account_number");
  create date index "idx_2" on #Acc_PC_Events_Same_Week("PC_Effective_To_Dt");
  update #Acc_PC_Events_Same_Week as "PCs"
    set "PC_ReAC_Offer_Applied" = 1 from
    #Acc_PC_Events_Same_Week as "PCs"
    join "citeam"."offers_software" as "os"
    on "os"."account_number" = "PCs"."account_number"
    and "os"."Whole_Offer_Created_Dt" = "PCs"."PC_Effective_To_Dt"
    and "os"."subscription_sub_type" = 'DTV Primary Viewing'
    and "os"."offer_leg" = 1
    and "lower"("os"."offer_dim_description") not like '%price protect%';
  select "Coalesce"(case when "PC_Effective_To_End_Dt" = "PC_Event_End_Dt" then "MoR"."Next_Status_Code" else null end,'PC') as "Next_Status_Code",
    cast(case "Next_Status_Code"
    when 'AC' then 1
    when 'PO' then 2
    when 'AB' then 3
    else 0
    end as integer) as "Next_Status_Code_Rnk",
    cast(case when "PC_Effective_To_End_Dt" = "PC_Event_End_Dt" then "MoR"."PC_ReAC_Offer_Applied" else 0 end as integer) as "PC_ReAC_Offer_Applied",
    "Row_number"() over(order by "Next_Status_Code_Rnk" asc,"PC_ReAC_Offer_Applied" asc) as "Row_ID",
    "count"() as "PCs"
    into #PC_Events_Same_Week
    from #Acc_PC_Events_Same_Week as "MoR"
    group by "Next_Status_Code","PC_ReAC_Offer_Applied";
  drop table if exists "IntraWk_PC_Pct";
  select "Row_ID","Next_Status_Code","PC_ReAC_Offer_Applied","PCs",
    "sum"("PCs") over(order by "Row_ID" asc) as "Cum_PCs",
    "sum"("PCs") over() as "Total_PCs",
    cast("Cum_PCs"-"PCs" as real)/"Total_PCs" as "IntaWk_PC_Lower_Pctl",
    cast("Cum_PCs" as real)/"Total_PCs" as "IntaWk_PC_Upper_Pctl"
    into "IntraWk_PC_Pct"
    from #PC_Events_Same_Week as "pc1"
    group by "Row_ID","Next_Status_Code","PC_ReAC_Offer_Applied","PCs"
end
