create procedure "Decisioning_Procs"."Forecast_CusCan_Rates"( in "Forecast_Start_Wk" integer,in "Hist_Wks" integer default 52 ) 
sql security invoker
begin
  declare "_1st_End_Date" date;
  declare "_Lst_End_Date" date;
  set temporary option "Query_Temp_Space_Limit" = 0;
  set "_1st_End_Date" = (select "min"("calendar_date"-("Hist_Wks"-1)*7-1) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Wk");
  set "_Lst_End_Date" = (select "min"("calendar_date"-1) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Wk");
  drop table if exists #Offers_Applied_Sample;
  select *,"subscription_sub_type" as "subs_type",
    cast("Whole_Offer_Created_Dt"-"datepart"("weekday","Whole_Offer_Created_Dt"+2) as date) as "End_Date",
    cast(0 as integer) as "TAs_in_last_24hrs",
    cast(0 as integer) as "Value_Calls_In_Last_1D",
    cast(null as integer) as "order_DTV_added_in_last_24hrs",
    cast(null as integer) as "order_DTV_removed_in_last_24hrs",
    cast(null as integer) as "DTV_PC_Reactivations_In_Last_1D",
    cast(null as integer) as "DTV_AB_Reactivations_In_Last_1D",
    cast(null as varchar(30)) as "Overall_Offer_Segment"
    into #Offers_Applied_Sample
    from "citeam"."offers_software" as "oua"
    where "Whole_Offer_Created_Dt" between "_1st_End_Date"+1 and "_Lst_End_Date"+7
    and "offer_leg" = 1
    and "subscription_sub_type" in( 'DTV Primary Viewing','SPORTS','CINEMA','Broadband DSL Line','SKY TALK LINE RENTAL' ) 
    and "lower"("offer_dim_description") not like '%price protection%';
  commit work;
  create hg index "idx_1" on #Offers_Applied_Sample("account_number");
  create date index "idx_2" on #Offers_Applied_Sample("Whole_Offer_Created_Dt");
  create lf index "idx_3" on #Offers_Applied_Sample("Overall_Offer_Segment");
  create date index "idx_4" on #Offers_Applied_Sample("end_date");
  delete from #Offers_Applied_Sample as "oas" from
    #Offers_Applied_Sample as "oas"
    left outer join "citeam"."cust_weekly_base" as "base"
    on "base"."account_number" = "oas"."account_number"
    and "base"."end_date" = "oas"."end_date"
    where "base"."account_number" is null;
  call "Decisioning_Procs"."Add_Turnaround_Attempts"('#Offers_Applied_Sample','Whole_Offer_Created_Dt','TA','Update Only','TAs_in_last_24hrs');
  call "Decisioning_Procs"."Add_Calls_Answered"('#Offers_Applied_Sample','Whole_Offer_Created_Dt','Value','Update Only','Value_Calls_In_Last_1D');
  call "Decisioning_Procs"."Add_Software_Orders"('#Offers_Applied_Sample','Whole_Offer_Created_Dt','DTV',null,'Account_Number','','Update Only','order_DTV_added_in_last_24hrs','order_DTV_removed_in_last_24hrs');
  call "Decisioning_Procs"."Add_PL_Entries_DTV"('#Offers_Applied_Sample','Whole_Offer_Created_Dt','Update Only','DTV_PC_Reactivations_In_Last_1D','DTV_AB_Reactivations_In_Last_1D');
  update #Offers_Applied_Sample
    set "overall_offer_segment" = case when "TAs_in_last_24hrs" > 0 then 'TA'
    when "Value_Calls_In_Last_1D" > 0 then 'Other'
    when "DTV_PC_Reactivations_In_Last_1D" > 0 or "DTV_AB_Reactivations_In_Last_1D" > 0 then 'Reactivations'
    else
      'Other'
    end;
  drop table if exists #Other_Offers;
  select "account_number",
    cast("Whole_Offer_Created_Dt"-"Datepart"("weekday","Whole_Offer_Created_Dt"+2) as date) as "End_Date",
    case when "Sum"(case when "Subs_Type" in( 'DTV Primary Viewing','SPORTS','CINEMA' ) then 1 else 0 end) > 0 then 1 else 0 end as "Offers_Applied",
    case when "Sum"(case when "Subs_Type" in( 'Broadband DSL Line','SKY TALK LINE RENTAL' ) then 1 else 0 end) > 0 then 1 else 0 end as "BB_Offers_Applied"
    into #Other_Offers
    from #Offers_Applied_Sample
    where "overall_offer_segment" = 'Other'
    group by "account_number","End_Date";
  commit work;
  create hg index "idx_1" on #Other_Offers("account_number");
  create date index "idx_2" on #Other_Offers("end_date");
  drop table if exists #PCs_Accs;
  select "account_number",
    "pl"."event_dt",
    cast("pl"."event_dt"-"datepart"("weekday","event_dt"+2) as date) as "End_Date",
    "pl"."PC_Pipeline_Cancellation",
    "pl"."Same_Day_Cancel",
    cast(0 as integer) as "TAs_in_last_24hrs",
    cast(0 as integer) as "Value_Calls_In_Last_1D"
    into #PCs_Accs
    from "CITeam"."PL_Entries_DTV" as "pl"
    where "pl"."event_dt" between "_1st_End_Date"+1 and "_Lst_End_Date"+7
    and("pl"."PC_Pipeline_Cancellation" > 0 or "pl"."Same_Day_Cancel" > 0);
  commit work;
  create hg index "idx_1" on #PCs_Accs("account_number");
  create date index "idx_2" on #PCs_Accs("event_dt");
  call "Decisioning_Procs"."Add_Turnaround_Attempts"('#PCs_Accs','Event_Dt','TA','Update Only','TAs_in_last_24hrs');
  call "Decisioning_Procs"."Add_Calls_Answered"('#PCs_Accs','Event_Dt','Value','Update Only','Value_Calls_In_Last_1D');
  select "account_number","End_Date",
    "max"("PC_Pipeline_Cancellation") as "Other_PC",
    "max"("Same_Day_Cancel") as "Other_SDC"
    into #Other_PCs
    from #PCs_Accs
    where "TAs_in_last_24hrs" = 0
    group by "account_number","End_Date";
  commit work;
  create hg index "idx_1" on #Other_PCs("account_number");
  create date index "idx_2" on #Other_PCs("End_Date");
  drop table if exists #Contract_Accs;
  select "contract"."account_number",
    "contract"."agreement_item_type",
    "contract"."agreement_created_reason_code",
    cast("contract"."created_dt" as date) as "Created_Dt",
    cast("contract"."Start_Dt" as date) as "Start_Dt",
    cast("contract"."End_Dt" as date) as "End_Dt",
    cast("End_Dt_Calc" as date) as "End_Dt_Calc",
    cast("Created_Dt"-"datepart"("weekday","Created_Dt"+2) as date) as "Contract_Created_End_Date",
    cast("Start_Dt"-"datepart"("weekday","Start_Dt"+2) as date) as "Contract_Start_End_Date",
    "cs"."ph_subs_subscription_sub_type" as "subscription_sub_type",
    cast(0 as integer) as "TAs_in_last_24hrs",
    cast(0 as integer) as "Value_Calls_In_Last_1D",
    cast(0 as integer) as "DTV_Activations_In_Last_1D",
    cast(0 as integer) as "BB_Subscriber_Activations_In_Last_1D"
    into #Contract_Accs
    from "CUST_CONTRACT_AGREEMENTS" as "contract"
      join "cust_subscriptions" as "cs"
      on "cs"."subscription_id" = "contract"."subscription_id"
    where "contract"."created_dt" between "_1st_End_Date"+1 and "_Lst_End_Date"+7
    and "subscription_sub_type" in( 'DTV Primary Viewing','Broadband DSL Line' ) 
    and "contract"."start_dt" is not null;
  commit work;
  create hg index "idx_1" on #Contract_Accs("account_number");
  create date index "idx_2" on #Contract_Accs("Created_Dt");
  create date index "idx_3" on #Contract_Accs("Start_Dt");
  create date index "idx_4" on #Contract_Accs("Contract_Created_End_Date");
  create date index "idx_5" on #Contract_Accs("Contract_Start_End_Date");
  create lf index "idx_6" on #Contract_Accs("subscription_sub_type");
  delete from #Contract_Accs as "ca" from
    #Contract_Accs as "ca"
    left outer join "citeam"."cust_weekly_base" as "base"
    on "base"."account_number" = "ca"."account_number"
    and "base"."end_date" = "ca"."Contract_Start_End_Date"
    where "base"."account_number" is null;
  call "Decisioning_Procs"."Add_Turnaround_Attempts"('#Contract_Accs','Created_Dt','TA','Update Only','TAs_in_last_24hrs');
  delete from #Contract_Accs where "TAs_in_last_24hrs" > 0;
  call "Decisioning_Procs"."Add_Calls_Answered"('#Contract_Accs','Created_Dt','Value','Update Only','Value_Calls_In_Last_1D');
  drop table if exists #Other_Contracts;
  select "subscription_sub_type","account_number","Contract_Start_End_Date",
    1 as "Other_Contract_Applied"
    into #Other_Contracts
    from #Contract_Accs
    where "TAs_in_last_24hrs" = 0
    group by "subscription_sub_type","account_number","Contract_Start_End_Date";
  commit work;
  create hg index "idx_1" on #Other_Contracts("account_number");
  create date index "idx_2" on #Other_Contracts("Contract_Start_End_Date");
  create lf index "idx_3" on #Other_Contracts("subscription_sub_type");
  drop table if exists #cuscan_weekly_agg;
  select "prem_segment",
    "cuscan_forecast_segment",
    "Count"() as "n",
    "Sum"(case when "agg"."DTV_Status_Code" in( 'AB','PC' ) 
    or "agg"."TA_DTV_PC"+"agg"."WC_DTV_PC"
    +"agg"."Other_PC"+"agg"."DTV_AB" > 0
    or "agg"."Unique_TA_Caller" > 0
    or "agg"."Web_Chat_TA_Customers" > 0 then
      0
    else 1
    end) as "Other_Offer_Base",
    cast("sum"("TAs_In_Next_7D") as real) as "TA_Call_cnt",
    cast("sum"("Unique_TA_Caller") as real) as "TA_Call_Customers",
    cast("sum"("TA_Non_Save_Count") as real) as "TA_Not_Saved",
    cast("sum"("TA_Save_Count") as real) as "TA_Saved",
    cast("sum"("Web_Chat_TA_Cnt") as real) as "Web_Chat_TA_Cnt",
    cast("sum"("Web_Chat_TA_Customers") as real) as "Web_Chat_TA_Customers",
    cast("sum"(case when "Coalesce"("oo"."Offers_Applied",0) > 0 and "DTV_contract"."account_number" is null then 1 else 0 end) as real) as "NonTA_DTV_Offer_Applied",
    cast("sum"(case when "Coalesce"("oo"."Offers_Applied",0) > 0 and "DTV_contract"."account_number" is not null then 1 else 0 end) as real) as "NonTA_DTV_Offer_and_Contract_Applied",
    cast("sum"(case when "Coalesce"("oo"."Offers_Applied",0) = 0 and "DTV_contract"."account_number" is not null then 1 else 0 end) as real) as "NonTA_DTV_Contract_Applied",
    cast("sum"(case when "Coalesce"("oo"."BB_Offers_Applied",0) > 0 and "BB_contract"."account_number" is null then 1 else 0 end) as real) as "NonTA_BB_Offer_Applied",
    cast("sum"(case when "Coalesce"("oo"."BB_Offers_Applied",0) > 0 and "BB_contract"."account_number" is not null then 1 else 0 end) as real) as "NonTA_BB_Offer_and_Contract_Applied",
    cast("sum"(case when "Coalesce"("oo"."BB_Offers_Applied",0) = 0 and "BB_contract"."account_number" is not null then 1 else 0 end) as real) as "NonTA_BB_Contract_Applied",
    cast("sum"("pcs"."Other_PC") as real) as "Other_DTV_PCs",
    cast("sum"("pcs"."Other_SDC") as real) as "Other_DTV_SDCs",
    cast(null as real) as "WebChat_Events_Per_Agent"
    into #cuscan_weekly_agg
    from "CITeam"."DTV_Fcast_Weekly_Base" as "agg"
      left outer join #Other_Offers as "oo"
      on "oo"."account_number" = "agg"."account_number"
      and "oo"."end_date" = "agg"."end_date"
      left outer join #Other_PCs as "pcs"
      on "pcs"."account_number" = "agg"."account_number"
      and "pcs"."end_date" = "agg"."end_date"
      left outer join #Other_Contracts as "DTV_contract"
      on "DTV_contract"."account_number" = "agg"."account_number"
      and "DTV_contract"."Contract_Start_End_Date" = "agg"."end_date"
      and "DTV_contract"."subscription_sub_type" = 'DTV Primary Viewing'
      left outer join #Other_Contracts as "BB_contract"
      on "BB_contract"."account_number" = "agg"."account_number"
      and "BB_contract"."Contract_Start_End_Date" = "agg"."end_date"
      and "BB_contract"."subscription_sub_type" = 'Broadband DSL Line'
    where "agg"."end_date" between "_1st_End_Date" and "_Lst_End_Date"
    and "Downgrade_View" = 'Actuals'
    and "DTV_Active" > 0
    group by "prem_segment",
    "cuscan_forecast_segment";
  drop table if exists #Webchat_Agent_Count;
  select "sum"("LiveChat_Turnaround_Saved"+"LiveChat_Turnaround_Not_Saved") as "WC_Events",
    "count"(distinct("CREATED_BY_ID")) as "WC_agent_count",
    cast("WC_Events" as real)/"WC_Agent_Count" as "Events_Per_Agent"
    into #Webchat_Agent_Count
    from "CITeam"."Turnaround_Attempts" as "CRR"
    where "event_dt" between "_1st_End_Date"+1 and "_Lst_End_Date"+7
    and "LiveChat_Turnaround_Saved"+"LiveChat_Turnaround_Not_Saved" > 0;
  update #cuscan_weekly_agg as "agg"
    set "Web_Chat_TA_Customers" = "Web_Chat_TA_Customers"/"agent"."WC_agent_count",
    "WebChat_Events_Per_Agent" = "agent"."Events_Per_Agent" from
    #Webchat_Agent_Count as "agent";
  drop table if exists "Cuscan_predicted_values";
  select "prem_segment",
    "cuscan_forecast_segment",
    "sum"("n") as "Custs",
    cast("sum"("TA_Call_Customers") as real)/"Custs" as "pred_TA_Call_Cust_rate",
    cast("sum"("Web_Chat_TA_Customers") as real)/"Custs" as "pred_Web_Chat_TA_Cust_rate",
    cast("sum"("NonTA_DTV_Offer_and_Contract_Applied") as real)/"Custs" as "pred_NonTA_DTV_Offer_and_Contract_Applied_rate",
    cast("sum"("NonTA_DTV_Offer_Applied") as real)/"Custs" as "pred_NonTA_DTV_Offer_Applied_rate",
    cast("sum"("NonTA_DTV_Contract_Applied") as real)/"Custs" as "pred_NonTA_DTV_Contract_Applied_rate",
    cast("sum"("NonTA_BB_Offer_and_Contract_Applied") as real)/"Custs" as "pred_NonTA_BB_Offer_and_Contract_Applied_rate",
    cast("sum"("NonTA_BB_Offer_Applied") as real)/"Custs" as "pred_NonTA_BB_Offer_Applied_rate",
    cast("sum"("NonTA_BB_Contract_Applied") as real)/"Custs" as "pred_NonTA_BB_Contract_Applied_rate",
    cast("sum"("Other_DTV_PCs") as real)/"Custs" as "pred_Other_DTV_PC_rate",
    cast("sum"("Other_DTV_SDCs") as real)/"Custs" as "pred_Other_DTV_SDC_rate",
    "WebChat_Events_Per_Agent"
    into "Cuscan_predicted_values"
    from #cuscan_weekly_agg as "agg"
    group by "prem_segment",
    "cuscan_forecast_segment",
    "WebChat_Events_Per_Agent";
  commit work;
  create lf index "idx_1" on "Cuscan_predicted_values"("cuscan_forecast_segment");
  create lf index "idx_2" on "Cuscan_predicted_values"("prem_segment")
end
