create procedure "Decisioning_Procs"."Forecast_Insert_New_Custs_Into_Loop_Table"( 
  in "Cust_Weekly_Base_Fcast_Fields" long varchar,
  in "True_Sample_Rate" real,
  in "Counter" integer ) 
sql security invoker
begin
  declare "new_cust_end_date" date;
  declare "new_cust_subs_week_and_year" integer;
  declare "new_cust_subs_week_of_year" integer;
  declare "multiplier" bigint;
  declare "CusCan_Vol" integer;
  declare "Loop_Index" integer;
  declare "FieldName" varchar(100);
  declare "Dynamic_SQL" long varchar;
  set "multiplier" = "DATEPART"("millisecond","now"())+2631;
  --- Changed the line 114 to reduce the date change from 14 days to 7 days
  ---------------------------------------------------------------
  --INSERT NEW CUSTOMERS
  ----------------------------------------------------------------
  set "new_cust_end_date" = (select "max"("end_date"+7) from "Forecast_Loop_Table");
  set "new_cust_subs_week_and_year" = (select "max"(cast("subs_week_and_year" as integer)) from "sky_calendar" where "calendar_date" = "new_cust_end_date");
  set "new_cust_subs_week_of_year" = (select "max"("subs_week_of_year") from "sky_calendar" where "calendar_date" = "new_cust_end_date");
  /*
Select top 100 end_date,BB_Curr_Contract_Intended_End_Dt,new_cust_end_date,BB_Curr_Contract_Intended_End_Dt+datediff(day,end_date,new_cust_end_date),new_cust_subs_week_and_year,new_cust_subs_week_of_year
from #new_customers_last_2Yrs_3
*/
  set "CusCan_Vol" = (select "sum"("DTV_PO_Cancellations_In_Next_7D"+"DTV_SameDayCancels_In_Next_7D") from "Forecast_Loop_Table");
  -- select new_end_date, new_subs_week_and_year, new_subs_week_of_year;
  drop table if exists #new_customers_last_2Yrs_2;
  select *,"rand"("number"()*"multiplier"+163456) as "rand_sample"
    into #new_customers_last_2Yrs_2
    from "Forecast_New_Cust_Sample";
  update #new_customers_last_2Yrs_2
    set "account_number" = "replicate"("char"(65+"remainder"(("counter"-1),53)),("counter"-1)/53+1) || "account_number";
  update #new_customers_last_2Yrs_2
    set "BB_Product_Holding" = "Order_BB_Added_In_Last_30d",
    "BB_Active" = 1,
    "BB_Last_Activation_Dt" = "end_date"
    where "Order_BB_Added_In_Last_30d" is not null;
  drop table if exists #new_customers_last_2Yrs_3;
  select *,"row_number"() over(partition by "dtv_activation_type" order by "rand_sample" asc) as "Rand_Rnk"
    into #new_customers_last_2Yrs_3
    from #new_customers_last_2Yrs_2;
  delete from #new_customers_last_2Yrs_3 as "new_cust" from
    #new_customers_last_2Yrs_3 as "new_cust"
    join "Activation_Vols" as "act"
    on(("new_cust"."Rand_Rnk" > "act"."Acquisitions"*"true_sample_rate"
    /* Temp fix to adjust acquisition volumes */
    //                * Case Cast(new_cust_subs_week_and_year/100 as integer)
    //                        when 2017 then 0.85
    //                        when 2018 then 1.10
    //                        else 1
    //                  end
    *.85
    --                    *0.75
    /*---------------------------------------*/
    and "act"."subs_week_of_year" = "new_cust_subs_week_of_year"
    and "new_cust"."DTV_Activation_Type" = 'Acquisition')
    or("new_cust"."Rand_Rnk" > ("act"."Reinstates"*"true_sample_rate")*"CusCan_Vol"/("act"."CusCan"*"True_Sample_Rate")
    and "act"."subs_week_of_year" = "new_cust_subs_week_of_year"
    and "new_cust"."DTV_Activation_Type" = 'Reinstate'));
  commit work;
  update #new_customers_last_2Yrs_3
    set "Curr_Offer_Intended_End_Dt_DTV"
     = case when "Future_Dated_Offer_Intended_end_Dt_DTV" is not null then "Future_Dated_Offer_Intended_end_Dt_DTV"
    else "Curr_Offer_Intended_End_Dt_DTV"
    end,
    "Curr_Offer_Intended_End_Dt_Sports"
     = case when "Future_Dated_Offer_Intended_end_Dt_Sports" is not null then "Future_Dated_Offer_Intended_end_Dt_Sports"
    else "Curr_Offer_Intended_End_Dt_Sports"
    end,
    "Curr_Offer_Intended_End_Dt_Movies"
     = case when "Future_Dated_Offer_Intended_end_Dt_Movies" is not null then "Future_Dated_Offer_Intended_end_Dt_Movies"
    else "Curr_Offer_Intended_End_Dt_Movies"
    end,
    "Curr_Offer_Intended_End_Dt_BB"
     = case when "Future_Dated_Offer_Intended_end_Dt_BB" is not null then "Future_Dated_Offer_Intended_end_Dt_BB"
    else "Curr_Offer_Intended_End_Dt_BB"
    end,
    "Curr_Offer_Intended_End_Dt_LR"
     = case when "Future_Dated_Offer_Intended_end_Dt_LR" is not null then "Future_Dated_Offer_Intended_end_Dt_LR"
    else "Curr_Offer_Intended_End_Dt_LR"
    end;
  update #new_customers_last_2Yrs_3
    set "Future_Dated_Offer_Start_Dt_DTV" = null,
    /*\\\\\\\\x09\\\\\\\\x09,Future_Dated_Offer_Start_Dt_Sports = null */
    /*\\\\\\\\x09\\\\\\\\x09,Future_Dated_Offer_Start_Dt_Movies = null*/
    "Future_Dated_Offer_Start_Dt_BB" = null,
    /*\\\\\\\\x09\\\\\\\\x09,Future_Dated_Offer_Start_Dt_LR = null*/
    "Future_Dated_Offer_Intended_end_Dt_DTV" = null,
    "Future_Dated_Offer_Intended_end_Dt_Sports" = null,
    "Future_Dated_Offer_Intended_end_Dt_Movies" = null,
    "Future_Dated_Offer_Intended_end_Dt_BB" = null,
    "Future_Dated_Offer_Intended_end_Dt_LR" = null;
  -- Create table of date fields that need to be adjusted for new customers
  drop table if exists #Date_fields;
  select *,"Row_Number"() over(order by "column_name" asc) as "ID"
    into #Date_fields
    from "sp_columns"('Forecast_New_Cust_Sample')
    where "table_owner" = current user
    and("lower"("column_name") like '%_dt_%' or "right"("lower"("column_name"),3) = '_dt' or "lower"("column_name") like '%_date%')
    and "lower"("column_name") <> 'end_date'
    and "type_name" in( 'datetime','date' ) ;
  -- Select * from #Date_fields
  -- Update date fileds relative to end_date
  set "Dynamic_SQL" = '';
  set "Loop_Index" = 1;
  while "Loop_Index" <= (select "count"() from #Date_fields) loop
    set "FieldName" = (select "max"("column_name") from #Date_fields where "ID" = "Loop_Index");
    set "Dynamic_SQL" = "Dynamic_SQL" || "Char"(13)
       || "FieldName" || ' = '
       || ' Case when ' || "FieldName" || ' = ''9999-09-09'' then Cast(''9999-09-09'' as date) '
       || '      when ' || "FieldName" || ' < ''9999-09-09'' then '
       || "FieldName" || ' + datediff(day,end_date,Cast(''' || "new_cust_end_date" || ''' as date)) '
       || ' end,';
    set "Loop_Index" = "Loop_Index"+1
  end loop;
  -- Select Dynamic_SQL;
  if "right"("Dynamic_SQL",1) = ',' then
    execute immediate 'Update #new_customers_last_2Yrs_3 '
       || 'Set ' || "left"("Dynamic_SQL","len"("Dynamic_SQL")-1)
  end if;
  update #new_customers_last_2Yrs_3
    set "end_date" = "new_cust_end_date"-7,
    "subs_week_and_year" = "new_cust_subs_week_and_year",
    "subs_week_of_year" = "new_cust_subs_week_of_year";
  commit work;
  -- Insert new customers into forecast loop table
  execute immediate ''
     || 'insert into Forecast_Loop_Table(account_number,end_date,New_DTV_Customer '
     || "Cust_Weekly_Base_Fcast_Fields"
     || ')'
     || ' Select account_number,end_date,1 as New_DTV_Customer '
     || "Cust_Weekly_Base_Fcast_Fields"
     || ' from #new_customers_last_2Yrs_3 as a ';
  -- Insert new offers into forecast offers hist table
  drop table if exists #Offers_Applied_Sample;
  select "os"."account_number",
    "new_cust"."end_date",
    "offer_id","Offer_Leg_Created_Dt",
    "Intended_Offer_End_Dt"+("new_cust_End_date"+7-"end_date") as "Intended_Offer_End_Dt",
    "Monthly_Offer_Amount",
    "Whole_Offer_Created_dt"+("new_cust_End_date"+7-"end_date") as "Whole_Offer_Created_dt",
    "Whole_Offer_start_dt_Actual"+("new_cust_End_date"+7-"end_date") as "Whole_Offer_start_dt_Actual"
    into #Offers_Applied_Sample
    from #new_customers_last_2Yrs_2 as "new_cust"
      join "CITeam"."Offers_Software" as "os"
      on "os"."account_number" = "new_cust"."account_number"
      and "os"."Whole_Offer_Start_Dt_Actual" between "new_cust"."end_date"-89 and "new_cust"."end_date"
      and "os"."offer_leg" = 1
      and "os"."subscription_sub_type" = 'DTV Primary Viewing'
      and "lower"("os"."offer_dim_description") not like '%price protect%';
  -- Update #Offers_Applied_Sample
  -- Set account_number = replicate(char(65 + (counter - 1)%53), (counter-1)/53 + 1) || account_number;
  -- 
  -- Update #Offers_Applied_Sample
  -- Set Whole_Offer_Start_Dt_Actual = new_cust_end_date + 3,
  --     Offer_Leg_Created_Dt = new_cust_end_date + 3,
  --     Whole_Offer_Created_Dt = new_cust_end_date + 3,
  --     Intended_Offer_End_Dt = Intended_Offer_End_Dt + datediff(day,end_date,new_cust_end_date)
  --     ;
  insert into "Offers_Applied_Sample"
    ( "Offer_Type","Account_Number","offer_id",
    "Offer_Leg_Created_Dt","Intended_Offer_End_Dt","Monthly_Offer_Amount","Whole_Offer_Created_dt","Whole_Offer_start_dt_Actual","Activated_Offer" ) 
    select 'Forecast' as "Offer_Type",
      "Account_Number",
      "offer_id",
      "Offer_Leg_Created_Dt",
      "Intended_Offer_End_Dt",
      "Monthly_Offer_Amount",
      "Whole_Offer_Created_dt",
      "Whole_Offer_start_dt_Actual",
      1 as "Activated_Offer"
      from #Offers_Applied_Sample
      where "account_number" = any(select distinct "account_number" from #new_customers_last_2Yrs_3)
end
