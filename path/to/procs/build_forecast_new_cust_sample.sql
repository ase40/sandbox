create procedure "Decisioning_Procs"."Build_Forecast_New_Cust_Sample"( 
  in "Cust_Weekly_Base_Fcast_Fields" long varchar,
  in "LV" integer ) 
sql security invoker
begin
  declare "Obs_Dt" date;
  declare "Dynamic_SQL" long varchar;
  declare "Loop_Num" integer;
  drop table if exists "Forecast_New_Cust_Sample";
  -- Set Obs_Dt = (Select max(calendar_date) from Decisioning_Procs.subs_calendar(LV/100 -1,LV/100) where Subs_Week_And_Year < LV);
  set "Obs_Dt" = (select "max"("calendar_date") from "Sky_Calendar" where cast("Subs_Week_And_Year" as integer) < "LV");
  set temporary option "Query_Temp_Space_Limit" = 0;
  drop table if exists "FORECAST_New_Cust_Sample";
  execute immediate ''
     || ' select account_number, end_date '
     || "Cust_Weekly_Base_Fcast_Fields"
     || ' ,Case when dtv_last_activation_dt between (end_date-6) and end_date and dtv_1st_activation_dt < dtv_last_activation_dt then ''Reinstate'' '
     || '       when dtv_last_activation_dt between (end_date-6) and end_date and (dtv_1st_activation_dt = dtv_last_activation_dt) then ''Acquisition'' '
     || '  End as DTV_Activation_Type '
     || ' ,Cast(null as varchar(100)) as Order_BB_Added_In_Last_30d '
     || ' into Forecast_New_Cust_Sample '
     || 'from citeam.Cust_Weekly_Base '
     || 'where end_date between Obs_Dt - 5* 7 and Obs_Dt '
     || '    and dtv_active = 1 '
     || '    and dtv_last_activation_dt between (end_date-6) and end_date ' -- New customers
     || '    and DTV_Activation_Type is not null ';
  commit work;
  create lf index "idx_1" on "FORECAST_New_Cust_Sample"("Payment_Due_Day_of_Month");
  create hg index "idx_2" on "FORECAST_New_Cust_Sample"("account_number");
  create hg index "idx_3" on "FORECAST_New_Cust_Sample"("end_date");
  -- Create hg index idx_4 on FORECAST_New_Cust_Sample(DTV_PC_Future_Sub_Effective_Dt);
  -- Create hg index idx_5 on FORECAST_New_Cust_Sample(DTV_AB_Future_Sub_Effective_Dt);
  select "account_number",
    "rand"("number"()*172735) as "rand_Payment_Day",
    cast(null as integer) as "Payment_Due_Day_of_Month"
    into #Null_DoM_Sample
    from "FORECAST_New_Cust_Sample" as "sample"
    where "sample"."Payment_Due_Day_of_Month" is null;
  select "payment_due_day_of_month",
    "Row_Number"() over(order by "payment_due_day_of_month" asc) as "Day_Rnk",
    "Count"() as "Customers",
    "Sum"("Customers") over(order by "payment_due_day_of_month" asc) as "Cum_Customers",
    "sum"("Customers") over() as "Ttl",
    cast(null as real) as "Bill_Lower_Bound",
    cast("Cum_Customers" as real)/"Ttl" as "Bill_Upper_Bound"
    into #Acc_Payment_DoM
    from "CITeam"."cust_weekly_base"
    where "DTV_Last_Activation_Dt" between "Obs_Dt"-42-5*7 and "Obs_Dt"-42
    and "DTV_active" = 1
    and "payment_due_day_of_month" <= 28
    group by "payment_due_day_of_month";
  update #Acc_Payment_DoM as "DoM1"
    set "Bill_Lower_Bound" = "Coalesce"("DoM2"."Bill_Upper_Bound",0) from
    #Acc_Payment_DoM as "DoM1"
    left outer join #Acc_Payment_DoM as "DoM2"
    on "DoM1"."Day_Rnk"-1 = "DoM2"."Day_Rnk";
  update #Null_DoM_Sample as "sample"
    set "payment_due_day_of_month" = "DoM"."payment_due_day_of_month" from
    #Null_DoM_Sample as "sample"
    join #Acc_Payment_DoM as "DoM"
    on "sample"."rand_Payment_Day" between "DoM"."Bill_Lower_Bound" and "DoM"."Bill_Upper_Bound";
  update "FORECAST_New_Cust_Sample" as "sample"
    set "payment_due_day_of_month" = "DoM"."payment_due_day_of_month" from
    "FORECAST_New_Cust_Sample" as "sample"
    join #Null_DoM_Sample as "DoM"
    on "DoM"."account_number" = "sample"."account_number";
  drop table if exists #BB_Orders;
  select "sample"."account_number","sample"."end_date",
    "BB_Added_Product",
    "Row_Number"() over(partition by "sample"."account_number","sample"."end_date" order by "order_dt" desc) as "Order_Rnk"
    into #BB_Orders
    from "FORECAST_New_Cust_Sample" as "sample"
      join "CITeam"."Orders_Daily" as "od"
      on "od"."account_number" = "sample"."account_number"
      and "od"."order_dt" between "sample"."DTV_Last_Activation_Dt"-30 and "sample"."DTV_Last_Activation_Dt"
      and "sample"."BB_Product_Holding" is null
      and "od"."BB_Added_Product" is not null and "BB_Removed_Product" is null;
  delete from #BB_Orders where "Order_Rnk" > 1;
  update #BB_Orders
    set "BB_Added_Product" = "trim"("str_replace"("str_replace"("BB_Added_Product",'Sky ',''),'Broadband ',''));
  update #BB_Orders
    set "BB_Added_Product" = case "BB_Added_Product" when 'Fibre' then 'Sky Fibre'
    else "BB_Added_Product"
    end;
  update "FORECAST_New_Cust_Sample" as "sample"
    set "Order_BB_Added_In_Last_30d" = "bbo"."BB_Added_Product" from
    #BB_Orders as "bbo"
    where "bbo"."account_number" = "sample"."account_number"
    and "bbo"."end_date" = "sample"."end_date";
  drop table if exists #Future_Fields;
  select *,
    "Row_Number"() over(order by "colid" asc) as "RowID",
    case when "lower"("column_name") like '%next%' then 1
    when "lower"("column_name") like '%future%' then 1
    else 0
    end as "Remove_Field"
    into #Future_Fields
    from "sp_columns"('Forecast_New_Cust_Sample')
    where "table_owner" = current user and "Remove_Field" = 1;
  set "Loop_Num" = 1;
  set "Dynamic_SQL" = '';
  while "Loop_Num" <= (select "count"() from #Future_Fields) loop
    set "Dynamic_SQL" = "Dynamic_SQL" || (select "max"("column_name") from #Future_Fields where "RowID" = "Loop_Num") || ' = null,';
    set "Loop_Num" = "Loop_Num"+1
  end loop;
  execute immediate 'Update Forecast_New_Cust_Sample Set '
     || "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
end
