create procedure "Decisioning_Procs"."Forecast_TA_Vol_Dist"( in "Forecast_Start_Wk" integer,in "Num_Wks" integer ) 
sql security invoker
begin
  set temporary option "Query_Temp_Space_Limit" = 0;
  drop table if exists #TA;
  select "account_number","event_dt","Voice_Turnaround_Saved","Voice_Turnaround_Not_Saved",
    cast("event_dt"-"datepart"("weekday","event_dt"+2) as date) as "event_end_dt",
    cast(0 as tinyint) as "Offers_Applied_Lst_1D_DTV",
    cast(0 as tinyint) as "Offers_Applied_Lst_1D_BB",
    cast(0 as tinyint) as "Order_BB_added_in_last_24hrs",
    cast(0 as tinyint) as "Order_BB_removed_in_last_24hrs",
    cast(0 as tinyint) as "BB_Active",
    cast(null as varchar(80)) as "BB_Product_Holding",
    cast(null as varchar(80)) as "Last_Order_BB_Product_Added",
    cast(null as date) as "Last_Order_BB_Added_Dt",
    cast(null as varchar(80)) as "Last_Order_BB_Product_Removed",
    cast(null as date) as "Last_Order_BB_Removed_Dt",
    cast(0 as integer) as "DTV_PCs_In_Last_1D",
    cast(0 as integer) as "DTV_SDCs_In_Last_1D",
    cast(null as varchar(100)) as "CusCan_Forecast_Segment"
    into #TA
    from "citeam"."Turnaround_Attempts" as "crr"
    where "event_dt" between(select "max"("calendar_date"-7-"Num_Wks"*7+1) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and(select "max"("calendar_date"-7) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and "Voice_Turnaround_Saved"+"Voice_Turnaround_Not_Saved" > 0;
  commit work;
  create hg index "idx_1" on #TA("Account_Number");
  create date index "idx_2" on #TA("event_dt");
  create date index "idx_3" on #TA("event_end_dt");
  call "Decisioning_Procs"."Add_Offers_Software"('#TA','event_dt','DTV','Ordered','New','','Update Only','Offers_Applied_Lst_1D_DTV');
  call "Decisioning_Procs"."Add_Offers_Software"('#TA','event_dt','BB','Ordered','New','','Update Only','Offers_Applied_Lst_1D_BB');
  call "Decisioning_Procs"."Add_Software_Orders"('#TA','event_dt','BB','Include Regrades','Account_Number',null,'Update Only',
  'Order_BB_added_in_last_24hrs','Order_BB_removed_in_last_24hrs',
  'Last_Order_BB_Product_Added','Last_Order_BB_Added_Dt',
  'Last_Order_BB_Product_Removed','Last_Order_BB_Removed_Dt');
  call "Decisioning_procs"."Add_Active_Subscriber_Product_Holding"('#TA','event_end_dt','BB','Update Only','BB_Active','BB_Product_Holding');
  call "Decisioning_Procs"."Add_PL_Entries_DTV"('#TA','event_dt','Update Only','DTV_PCs_In_Last_1D','DTV_SDCs_In_Last_1D');
  update #TA
    set "Order_BB_added_in_last_24hrs" = 0,
    "Last_Order_BB_Product_Added" = null,
    "Last_Order_BB_Added_Dt" = null
    where not("Last_Order_BB_Added_Dt" = "event_dt");
  update #TA
    set "Order_BB_removed_in_last_24hrs" = 0,
    "Last_Order_BB_Product_Removed" = null,
    "Last_Order_BB_Removed_Dt" = null
    where not("Last_Order_BB_Removed_Dt" = "event_dt");
  update #TA as "crr"
    set "CusCan_ForeCast_Segment" = "base"."CusCan_ForeCast_Segment" from
    #TA as "crr"
    join "CITeam"."DTV_Fcast_Weekly_Base" as "base"
    on "crr"."account_number" = "base"."account_number"
    and "crr"."event_end_dt" = "base"."end_date"
    and "base"."downgrade_view" = 'Actuals';
  drop table if exists #Acc_TA_Call_Vol;
  select "event_end_dt" as "end_date",
    "CusCan_ForeCast_Segment",
    "Coalesce"("BB_Product_Holding",'Non BB') as "BB_Product_Holding",
    "account_number",
    "sum"("Voice_Turnaround_Saved"+"Voice_Turnaround_Not_Saved") as "TA_Event_Count",
    "Sum"("Voice_Turnaround_Saved") as "TA_Saved_Count",
    "max"(case when "Offers_Applied_Lst_1D_DTV" > 0 then 1 else 0 end) as "TA_DTV_Offer_Applied",
    "max"(case when "Offers_Applied_Lst_1D_BB" > 0 then 1 else 0 end) as "TA_BB_Offer_Applied",
    "max"(case when "DTV_PCs_In_Last_1D" > 0 then 1 else 0 end) as "TA_DTV_PC",
    "max"(case when "DTV_SDCs_In_Last_1D" > 0 then 1 else 0 end) as "TA_DTV_SDC",
    "max"(case when "Order_BB_removed_in_last_24hrs" > 0 then 1 else 0 end) as "BB_Removed",
    "max"("Last_Order_BB_Product_Added") as "BB_Product_Added",
    cast(0 as smallint) as "Prod_Added_ID"
    into #Acc_TA_Call_Vol
    from #TA
    where "CusCan_ForeCast_Segment" is not null
    group by "end_date","account_number","CusCan_ForeCast_Segment","BB_Product_Holding";
  commit work;
  update #Acc_TA_Call_Vol
    set "BB_Product_Added" = "trim"("str_replace"("str_replace"("BB_Product_Added",'Sky ',''),'Broadband ',''));
  update #Acc_TA_Call_Vol
    set "BB_Product_Added" = case "BB_Product_Added" when 'Fibre' then 'Sky Fibre'
    else "BB_Product_Added"
    end;
  select "BB_Product_Added","Row_Number"() over(order by "BB_Product_Added" desc) as "Prod_Added_ID"
    into #Prod_ID
    from #Acc_TA_Call_Vol as "A"
    group by "BB_Product_Added"
    order by "BB_Product_Added" asc;
  update #Acc_TA_Call_Vol as "base"
    set "Prod_Added_ID" = "trgt"."Prod_Added_ID" from
    #Prod_ID as "trgt"
    where "trgt"."BB_Product_Added" = "base"."BB_Product_Added";
  update #Acc_TA_Call_Vol
    set "BB_Removed" = 0,
    "BB_Product_Added" = null
    where "BB_Product_Added" = "BB_Product_Holding";
  update #Acc_TA_Call_Vol as "base"
    set "BB_Removed" = 0
    where "BB_Product_Holding" is null;
  drop table if exists "TA_Call_Dist";
  select "CusCan_ForeCast_Segment","BB_Product_Holding",
    "TA_Event_Count","TA_Saved_Count",
    "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
    "TA_DTV_PC",
    "TA_DTV_SDC",
    "BB_Removed","BB_Product_Added","Prod_Added_ID",
    cast("count"() as integer) as "TA_Custs",
    "Sum"("TA_Custs") over(partition by "CusCan_ForeCast_Segment","BB_Product_Holding") as "Total_TA_Custs",
    "Sum"("TA_Custs") over(partition by "CusCan_ForeCast_Segment","BB_Product_Holding" order by
    "TA_Custs"*10000000000
    +"TA_Event_Count"*100000000
    +"TA_Saved_Count"*1000000
    +"TA_DTV_Offer_Applied"*100000
    +"TA_BB_Offer_Applied"*10000
    +"TA_DTV_PC"*100
    +"TA_DTV_SDC"*10
    +"Prod_Added_ID" desc) as "Cum_TA_Custs",
    cast("Cum_TA_Custs"-"TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Lower_Pctl",
    cast("Cum_TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Upper_Pctl"
    into "TA_Call_Dist"
    from #Acc_TA_Call_Vol
    group by "CusCan_ForeCast_Segment","BB_Product_Holding",
    "TA_Event_Count","TA_Saved_Count",
    "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
    "TA_DTV_PC","TA_DTV_SDC",
    "BB_Removed","BB_Product_Added","Prod_Added_ID";
  insert into "TA_Call_Dist"
    select "CusCan_ForeCast_Segment",
      'All' as "BB_Product_Holding",
      "TA_Event_Count","TA_Saved_Count",
      "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
      "TA_DTV_PC","TA_DTV_SDC",
      "BB_Removed","BB_Product_Added","Prod_Added_ID",
      cast("count"() as integer) as "TA_Custs",
      "Sum"("TA_Custs") over(partition by "CusCan_ForeCast_Segment") as "Total_TA_Custs",
      "Sum"("TA_Custs") over(partition by "CusCan_ForeCast_Segment" order by
      "TA_Custs"*1000000000
      +"TA_Event_Count"*10000000
      +"TA_Saved_Count"*100000
      +"TA_DTV_Offer_Applied"*10000
      +"TA_BB_Offer_Applied"*1000
      +"TA_DTV_PC"*10
      +"Prod_Added_ID" desc) as "Cum_TA_Custs",
      cast("Cum_TA_Custs"-"TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Lower_Pctl",
      cast("Cum_TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Upper_Pctl"
      into "TA_Call_Dist"
      from #Acc_TA_Call_Vol
      group by "CusCan_ForeCast_Segment",
      "TA_Event_Count","TA_Saved_Count",
      "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
      "TA_DTV_PC","TA_DTV_SDC",
      "BB_Removed","BB_Product_Added","Prod_Added_ID";
  insert into "TA_Call_Dist"
    select 'All' as "CusCan_ForeCast_Segment","BB_Product_Holding",
      "TA_Event_Count","TA_Saved_Count",
      "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
      "TA_DTV_PC","TA_DTV_SDC",
      "BB_Removed","BB_Product_Added","Prod_Added_ID",
      cast("count"() as integer) as "TA_Custs",
      "Sum"("TA_Custs") over(partition by "BB_Product_Holding") as "Total_TA_Custs",
      "Sum"("TA_Custs") over(partition by "BB_Product_Holding" order by
      "TA_Custs"*1000000000
      +"TA_Event_Count"*10000000
      +"TA_Saved_Count"*100000
      +"TA_DTV_Offer_Applied"*10000
      +"TA_BB_Offer_Applied"*1000
      +"TA_DTV_PC"*10
      +"Prod_Added_ID" desc) as "Cum_TA_Custs",
      cast("Cum_TA_Custs"-"TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Lower_Pctl",
      cast("Cum_TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Upper_Pctl"
      into "TA_Call_Dist"
      from #Acc_TA_Call_Vol
      group by "BB_Product_Holding",
      "TA_Event_Count","TA_Saved_Count",
      "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
      "TA_DTV_PC","TA_DTV_SDC",
      "BB_Removed","BB_Product_Added","Prod_Added_ID";
  insert into "TA_Call_Dist"
    select 'All' as "CusCan_ForeCast_Segment",
      'All' as "BB_Product_Holding",
      "TA_Event_Count","TA_Saved_Count",
      "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
      "TA_DTV_PC","TA_DTV_SDC",
      "BB_Removed","BB_Product_Added","Prod_Added_ID",
      cast("count"() as integer) as "TA_Custs",
      "Sum"("TA_Custs") over() as "Total_TA_Custs",
      "Sum"("TA_Custs") over(order by "TA_Custs"*1000000000
      +"TA_Event_Count"*10000000
      +"TA_Saved_Count"*100000
      +"TA_DTV_Offer_Applied"*10000
      +"TA_BB_Offer_Applied"*1000
      +"TA_DTV_PC"*10
      +"Prod_Added_ID" desc) as "Cum_TA_Custs",
      cast("Cum_TA_Custs"-"TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Lower_Pctl",
      cast("Cum_TA_Custs" as numeric(30,18))/"Total_TA_Custs" as "TA_Dist_Upper_Pctl"
      into "TA_Call_Dist"
      from #Acc_TA_Call_Vol
      group by "TA_Event_Count","TA_Saved_Count",
      "TA_DTV_Offer_Applied","TA_BB_Offer_Applied",
      "TA_DTV_PC","TA_DTV_SDC",
      "BB_Removed","BB_Product_Added","Prod_Added_ID";
  commit work;
  create lf index "idx_1" on "TA_Call_Dist"("CusCan_ForeCast_Segment");
  create lf index "idx_2" on "TA_Call_Dist"("BB_Product_Holding")
end
