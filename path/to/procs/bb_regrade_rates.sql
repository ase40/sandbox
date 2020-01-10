create procedure "Decisioning_Procs"."BB_Regrade_Rates"( in "Forecast_Start_Wk" integer,"Num_Wks" integer,in "BB_Table_Name" varchar(100) default 'BB_Upgrades_Dist' ) 
sql security invoker
begin
  drop table if exists #BB_Regrades;
  select "account_number","event_dt","Product_Holding_SoD","Product_Holding_EoD",
    cast("event_dt"-"datepart"("weekday","event_dt"+2) as date) as "End_Date",
    cast(0 as integer) as "Offers_Applied_Lst_1D_BB",
    cast(null as date) as "BB_Curr_Contract_Start_Dt",
    cast(0 as integer) as "Contract_Applied_Lst_1D_BB"
    into #BB_Regrades
    from "citeam"."regrades_BB"
    where "event_dt" between(select "min"("calendar_date")-7*"Num_Wks" from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and(select "min"("calendar_date"-1) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and "Product_Holding_SoD" in( 'Unlimited','Unlimited (Legacy)','Sky Fibre','Unlimited Fibre','Fibre Max' ) 
    and "Product_Holding_EoD" in( 'Unlimited','Unlimited (Legacy)','Sky Fibre','Unlimited Fibre','Fibre Max' ) ;
  commit work;
  create hg index "idx_1" on #BB_Regrades("account_number");
  create date index "idx_2" on #BB_Regrades("event_dt");
  create date index "idx_3" on #BB_Regrades("end_date");
  call "Decisioning_procs"."Add_Offers_Software"('#BB_Regrades','Event_Dt','BB','Activated','New','','Update Only','Offers_Applied_Lst_1D_BB');
  call "Decisioning_procs"."Add_Contract_Details"('#BB_Regrades','Event_Dt','BB','Update Only','BB_Curr_Contract_Start_Dt');
  commit work;
  update #BB_Regrades
    set "Contract_Applied_Lst_1D_BB" = case when "BB_Curr_Contract_Start_Dt" = "event_dt" then 1 else 0 end;
  drop table if exists #Regrade_Rates;
  select "CusCan_Forecast_Segment",
    "BB_Package",
    "Product_Holding_EoD",
    "Offers_Applied_Lst_1D_BB",
    "Contract_Applied_Lst_1D_BB",
    "sum"("BB_Active") as "BB_Base",
    "count"("BB"."account_number") as "BB_Regrades",
    "sum"("BB_Regrades") over(partition by "CusCan_Forecast_Segment","BB_Package") as "BB_Regrades_Agg"
    into #Regrade_Rates
    from "CITeam"."DTV_Fcast_Weekly_Base" as "Base"
      left outer join #BB_Regrades as "BB"
      on "BB"."Account_Number" = "Base"."Account_Number"
      and "BB"."end_date" = "base"."end_date"
    where "base"."end_date" between(select "min"("calendar_date")-7*"Num_Wks"-1 from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and(select "min"("calendar_date"-7-1) from "sky_calendar" where "subs_week_and_year" = "Forecast_Start_Wk")
    and "base"."downgrade_view" = 'Actuals'
    and "base"."DTV_Active" = 1 and "base"."BB_Active" = 1
    group by "CusCan_Forecast_Segment",
    "BB_Package",
    "Product_Holding_EoD",
    "Offers_Applied_Lst_1D_BB",
    "Contract_Applied_Lst_1D_BB";
  delete from #Regrade_Rates where "BB_Regrades_Agg" = 0;
  delete from #Regrade_Rates where "BB_Package" = "Product_Holding_EoD";
  delete from #Regrade_Rates where "CusCan_Forecast_Segment" is null;
  drop table if exists "BB_Regrades_Rates";
  select "CusCan_Forecast_Segment",
    "BB_Package" as "BB_Product_Holding",
    "Coalesce"("Product_Holding_EoD","BB_Package") as "Product_Holding_EoD",
    "BB_Base",
    "BB_Regrades",
    "Coalesce"("Offers_Applied_Lst_1D_BB",0) as "Offers_Applied_Lst_1D_BB",
    "Coalesce"("Contract_Applied_Lst_1D_BB",0) as "Contract_Applied_Lst_1D_BB",
    "Row_Number"() over(partition by "CusCan_Forecast_Segment","BB_Product_Holding" order by "BB_Base" desc) as "Rnk",
    "sum"("BB_Base") over(partition by "CusCan_Forecast_Segment","BB_Product_Holding" order by "BB_Base" desc) as "Cum_BB_Custs",
    "sum"("BB_Base") over(partition by "CusCan_Forecast_Segment","BB_Product_Holding") as "Total_BB_Custs",
    cast("Cum_BB_Custs"-"BB_Base" as numeric(30,18))/"Total_BB_Custs" as "Lwr_Pctl",
    cast("Cum_BB_Custs" as numeric(30,18))/"Total_BB_Custs" as "Upr_Pctl"
    into "BB_Regrades_Rates"
    from #Regrade_Rates as "rr"
    order by "CusCan_Forecast_Segment" asc,"BB_Product_Holding" asc,"BB_Base" desc;
  commit work;
  create lf index "idx_1" on "BB_Regrades_Rates"("CusCan_Forecast_Segment");
  create lf index "idx_2" on "BB_Regrades_Rates"("BB_Product_Holding")
end
