create procedure "Decisioning_Procs"."AB_Status_Movement_Probabilities"( in "Forecast_Start_Week" integer,in "Hist_Weeks" integer,
  in "AB_Change_Dist_Table" varchar(100) default 'AB_PL_Status_Change_Dist',
  in "BB_SysCan_Dist_Table" varchar(100) default 'BB_TP_SysCan_Dist' ) 
sql security invoker
begin
  drop table if exists #AB_Intended_Churn;
  select "account_number",
    cast(null as tinyint) as "BB_Active",
    cast(null as varchar(10)) as "BB_Status_SoW",
    cast(0 as tinyint) as "BB_Enter_SysCan",
    cast(null as varchar(10)) as "BB_Status_Code_EoW",
    "event_dt",
    "event_dt"-"datepart"("weekday","event_dt"+2) as "AB_event_end_dt",
    cast(null as integer) as "Days_Since_Last_Payment",
    "AB_Future_Sub_Effective_Dt",
    cast("AB_Future_Sub_Effective_Dt"-"datepart"("weekday","AB_Future_Sub_Effective_Dt"+2)+7 as date) as "AB_Future_Sub_Effective_Dt_End_Dt",
    "AB_Effective_To_Dt",
    "AB_Next_status_code" as "Next_status_code",
    cast(0 as bit) as "AB_ReAC_Offer_Applied"
    into #AB_Intended_Churn
    from "CITeam"."PL_Entries_DTV"
    where "AB_Future_Sub_Effective_Dt" between(select "min"("calendar_date"-"Hist_Weeks"*7-1) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Week")
    and(select "min"("calendar_date"-1) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Week")
    and("AB_Pending_Termination" > 0)
    and "AB_Future_Sub_Effective_Dt" is not null and "AB_Next_status_code" is not null
    and "AB_Effective_To_Dt" <= "AB_Future_Sub_Effective_Dt";
  update #AB_Intended_Churn as "ABs"
    set "AB_ReAC_Offer_Applied" = 1 from
    #AB_Intended_Churn as "ABs"
    join "citeam"."offers_software" as "os"
    on "os"."account_number" = "ABs"."account_number"
    and "os"."Whole_Offer_Created_Dt" = "ABs"."AB_Effective_To_Dt"
    and "os"."subscription_sub_type" = 'DTV Primary Viewing'
    and "os"."offer_leg" = 1
    and "lower"("os"."offer_dim_description") not like '%price protect%';
  update #AB_Intended_Churn as "a"
    set "Days_Since_Last_Payment"
     = cast("end_date"-case when "day"("end_date") < "payment_due_day_of_month" then
      cast('' || "year"("dateadd"("month",-1,"end_date")) || '-' || "month"("dateadd"("month",-1,"end_date")) || '-' || "payment_due_day_of_month" as date)
    when "day"("end_date") >= "payment_due_day_of_month" then
      cast('' || "year"("end_date") || '-' || "month"("end_date") || '-' || "payment_due_day_of_month" as date)
    end as integer) from
    #AB_Intended_Churn as "a"
    left outer join "citeam"."cust_weekly_base" as "base"
    on "a"."account_number" = "base"."account_number"
    and "a"."AB_event_end_dt" = "base"."end_date";
  select "ABs".*,
    case when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 0 then 'Churn in next 1 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 1 then 'Churn in next 2 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 2 then 'Churn in next 3 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 3 then 'Churn in next 4 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 4 then 'Churn in next 5 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 5 then 'Churn in next 6 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 6 then 'Churn in next 7 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 7 then 'Churn in next 8 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 = 8 then 'Churn in next 9 wks'
    when(cast("AB_Future_Sub_Effective_Dt" as integer)-cast("End_Date" as integer))/7 >= 9 then 'Churn in next 10+ wks' end as "Wks_To_Intended_Churn",
    "date"("sc"."Calendar_date") as "End_date",
    case when "sc"."calendar_date"+7 between "event_dt" and "AB_Effective_To_Dt"-1 then 'AB'
    when "sc"."calendar_date"+7 >= "AB_Effective_To_Dt" then "Next_Status_Code" end as "Status_Code_EoW",
    case when "sc"."calendar_date"+7 = "AB_Effective_To_Dt"-"datepart"("weekday","AB_Effective_To_Dt"+2)+7
    and "Status_Code_EoW" = 'AC' then
      "ABs"."AB_ReAC_Offer_Applied"
    else 0
    end as "AB_ReAC_Offer_Applied_EoW",
    (case "Status_Code_EoW" when 'AC' then 1
    when 'AB' then 2
    when 'SC' then 3
    when 'PC' then 4
    when 'PO' then 5 end)
    -"AB_ReAC_Offer_Applied_EoW" as "Status_Code_EoW_Rnk",
    cast(null as tinyint) as "BB_EoW_Status_Code_Rnk"
    into #AB_PL_Status
    from #AB_Intended_Churn as "ABs"
      join "sky_calendar" as "sc"
      on "sc"."calendar_date" between "ABs"."event_dt" and "ABs"."AB_Effective_To_Dt"-1
      and "sc"."subs_last_day_of_week" = 'Y';
  update #AB_PL_Status as "a"
    set "BB_Enter_SysCan" = 1 from
    "citeam"."PL_Entries_BB" as "b"
    where "a"."account_number" = "b"."account_number"
    and "b"."event_dt" between "a"."End_date"+1 and "a"."End_date"+7
    and "b"."enter_syscan" > 0;
  update #AB_PL_Status as "ab"
    set "ab"."BB_Status_SoW" = case when "asr"."account_number" is null then 'XB' else "asr"."Status_code" end,
    "ab"."BB_Active" = case when "asr"."account_number" is not null then 1 else 0 end from
    #AB_PL_Status as "ab"
    left outer join "cust_subs_hist" as "asr"
    on "asr"."account_number" = "ab"."account_number"
    and "ab"."End_date" between "asr"."effective_from_dt" and "asr"."effective_to_dt"-1
    and "asr"."subscription_sub_type" = 'Broadband DSL Line'
    and "asr"."status_code" in( 'AC','AB','BCRQ','PC' ) ;
  update #AB_PL_Status as "a"
    set "a"."BB_Status_Code_EoW" = case when "a"."BB_Status_SoW" <> 'XB' and "b"."account_number" is null then 'CN'
    when "a"."BB_Status_SoW" = 'XB' and "b"."account_number" is null then 'XB'
    else "b"."Status_Code"
    end from
    #AB_PL_Status as "a"
    left outer join "cust_subs_hist" as "b"
    on "a"."account_number" = "b"."account_number"
    and "a"."End_Date"+7 between "b"."effective_from_dt" and "b"."effective_to_dt"-1
    and "b"."subscription_sub_type" = 'Broadband DSL Line'
    and "b"."status_code" in( 'AC','AB','BCRQ','PC' ) ;
  update #AB_PL_Status
    set "BB_EoW_Status_Code_Rnk" = case "BB_Status_Code_EoW" when 'AC' then 1
    when 'AB' then 2
    when 'BCRQ' then 3
    when 'PC' then 4
    when 'CN' then 5
    when 'PO' then 6
    when 'SC' then 7
    when 'XB' then 8
    else 9
    end;
  select "Wks_To_Intended_Churn","Status_Code_EoW",
    "BB_Status_SoW",
    "Status_Code_EoW_Rnk","AB_ReAC_Offer_Applied_EoW",
    "Days_Since_Last_Payment",
    "BB_Active",
    "BB_Enter_SysCan",
    "BB_Status_Code_EoW",
    "count"() as "ABs",
    "Sum"("ABs") over(partition by "Days_Since_Last_Payment","Wks_To_Intended_Churn","BB_Active","BB_Status_SoW" order by "Status_Code_EoW_Rnk"*100+"BB_EoW_Status_Code_Rnk"*10+"BB_Enter_SysCan" asc) as "Cum_Total_Cohort_ABs",
    "Sum"("ABs") over(partition by "Days_Since_Last_Payment","Wks_To_Intended_Churn","BB_Active","BB_Status_SoW") as "Total_Cohort_ABs",
    cast(null as real) as "AB_Percentile_Lower_Bound",
    cast("Cum_Total_Cohort_ABs" as real)/"Total_Cohort_ABs" as "AB_Percentile_Upper_Bound",
    "Row_Number"() over(partition by "Days_Since_Last_Payment","Wks_To_Intended_Churn","BB_Active","BB_Status_SoW" order by "Status_Code_EoW_Rnk"*100+"BB_EoW_Status_Code_Rnk"*10+"BB_Enter_SysCan" asc) as "Row_ID"
    into #AB_Percentiles
    from #AB_PL_Status
    group by "Days_Since_Last_Payment","Wks_To_Intended_Churn","Status_Code_EoW_Rnk","Status_Code_EoW","AB_ReAC_Offer_Applied_EoW","BB_Active",
    "BB_Enter_SysCan","BB_Status_Code_EoW","BB_Status_SoW","BB_EoW_Status_Code_Rnk"
    order by "Days_Since_Last_Payment" asc,"Wks_To_Intended_Churn" asc,"Status_Code_EoW_Rnk" asc,"Status_Code_EoW" asc,"AB_ReAC_Offer_Applied_EoW" asc;
  update #AB_Percentiles as "pcp"
    set "AB_Percentile_Lower_Bound" = cast("Coalesce"("pcp2"."AB_Percentile_Upper_Bound",0) as real) from
    #AB_Percentiles as "pcp"
    left outer join #AB_Percentiles as "pcp2"
    on "pcp2"."Wks_To_Intended_Churn" = "pcp"."Wks_To_Intended_Churn"
    and "pcp2"."Days_Since_Last_Payment" = "pcp"."Days_Since_Last_Payment"
    and "pcp2"."BB_Active" = "pcp"."BB_Active"
    and "pcp2"."BB_Status_SoW" = "pcp"."BB_Status_SoW"
    and "pcp2"."Row_ID" = "pcp"."Row_ID"-1;
  execute immediate 'Drop table if exists ' || "AB_Change_Dist_Table";
  execute immediate 'Select Days_Since_Last_Payment,Wks_To_Intended_Churn,Status_Code_EoW, '
     || ' BB_Active, '
     || ' BB_Enter_SysCan, '
     || ' coalesce(BB_Status_SoW, ''XB'') as BB_Status_Code, '
     || ' BB_Status_Code_EoW, '
     || ' AB_ReAC_Offer_Applied_EoW, '
     || ' ABs,Cum_Total_Cohort_ABs,Total_Cohort_ABs,AB_Percentile_Lower_Bound,AB_Percentile_Upper_Bound '
     || ' into ' || "AB_Change_Dist_Table"
     || ' from #AB_Percentiles';
  select *,
    cast(null as varchar(10)) as "BB_Next_Status_Code",
    cast(null as date) as "BB_Next_Status_Dt",
    cast(null as integer) as "Days_To_BB_Next_Status",
    cast(null as integer) as "Record_Rnk"
    into #BB_PL_Status
    from #AB_PL_Status
    where "Wks_To_Intended_Churn" = 'Churn in next 1 wks' and "BB_Active" = 1 and "Status_Code_EoW" = 'SC' and "BB_Status_Code_EoW" in( 'AB','BCRQ' ) 
    order by "days_since_last_payment" asc;
  update #BB_PL_Status as "BB"
    set "BB_Next_Status_Code" = "csh"."status_code",
    "BB_Next_Status_Dt" = "csh"."status_start_dt",
    "Days_To_BB_Next_Status" = cast("csh"."status_start_dt"-("BB"."End_Date"+7) as integer) from
    "cust_subs_hist" as "csh"
    where "csh"."account_number" = "BB"."account_number"
    and "csh"."prev_status_code" = "BB"."BB_Status_Code_EoW"
    and "BB"."End_Date"+7 between "csh"."prev_status_start_dt" and "csh"."status_start_dt"-1
    and "csh"."subscription_sub_type" = 'Broadband DSL Line';
  update #BB_PL_Status
    set "Record_Rnk" = "Days_To_BB_Next_Status"*10
    +case "BB_Next_Status_Code"
    when 'AC' then 1
    when 'AB' then 2
    when 'PC' then 3
    when 'BCRQ' then 4
    when 'CF' then 5
    when 'PT' then 6
    when 'CN' then 7 end;
  execute immediate 'Drop table if exists ' || "BB_SysCan_Dist_Table";
  execute immediate
    'Select BB_Next_Status_Code,Days_To_BB_Next_Status, '
     || 'Count(*) BB_PL_Subs, '
     || 'Sum(BB_PL_Subs) over(order by Record_Rnk) as Cum_BB_PL_Subs, '
     || 'Sum(BB_PL_Subs) over() as Total_BB_PL_Subs, '
     || 'Cast(Cum_BB_PL_Subs  - BB_PL_Subs as float)/Total_BB_PL_Subs as Act_Pctl_Lower_Bnd, '
     || 'Cast(Cum_BB_PL_Subs as float)/Total_BB_PL_Subs as Act_Pctl_Upper_Bnd '
     || 'into ' || "BB_SysCan_Dist_Table"
     || ' from #BB_PL_Status BB '
     || 'where BB_Next_Status_Code is not null '
     || 'group by BB_Next_Status_Code,Days_To_BB_Next_Status,Record_Rnk '
     || 'having BB_PL_Subs > 10 '
end
