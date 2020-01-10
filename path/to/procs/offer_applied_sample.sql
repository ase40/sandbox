create procedure "Decisioning_Procs"."Offer_Applied_Sample"( in "Forecast_Start_Wk" integer,"Num_Wks" integer ) 
sql security invoker
begin
  drop table if exists "temp_Offers_Applied_Sample";
  select *,"subscription_sub_type" as "subs_type",
    cast(null as varchar(10)) as "Offer_Type",
    cast(null as varchar(30)) as "Overall_Offer_Segment"
    into "temp_Offers_Applied_Sample"
    from "citeam"."offers_software" as "oua"
    where "Whole_Offer_Start_Dt_Actual" between(select "min"("calendar_date"-90) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Wk")
    and(select "min"("calendar_date"-1) from "sky_calendar" where cast("subs_week_and_year" as integer) = "Forecast_Start_Wk")
    and "Datediff"("month","Whole_offer_start_dt_Actual","Intended_offer_end_dt") <= 36
    and "offer_leg" = 1
    and "subscription_sub_type" in( 'DTV Primary Viewing','Broadband DSL Line' ) 
    and "lower"("offer_dim_description") not like '%price protection%';
  update "temp_Offers_Applied_Sample"
    set "Offer_Type" = 'Actual';
  commit work;
  create hg index "idx_1" on "temp_Offers_Applied_Sample"("account_number");
  create date index "idx_2" on "temp_Offers_Applied_Sample"("Whole_Offer_Created_Dt");
  call "Decisioning_Procs"."Add_Turnaround_Attempts"('temp_Offers_Applied_Sample','Whole_Offer_Created_Dt','TA','Drop and Replace','TAs_in_last_24hrs');
  call "Decisioning_Procs"."Add_Software_Orders"('temp_Offers_Applied_Sample','Whole_Offer_Created_Dt','DTV','Exclude Regrades','Account_Number',null,'Drop and Replace','order_DTV_added_in_last_24hrs','order_DTV_removed_in_last_24hrs');
  call "Decisioning_Procs"."Add_PL_Entries_DTV"('temp_Offers_Applied_Sample','Whole_Offer_Created_Dt','Drop and Replace','DTV_PC_Reactivations_In_Last_1D','DTV_AB_Reactivations_In_Last_1D');
  update "temp_Offers_Applied_Sample"
    set "overall_offer_segment" = case when "TAs_in_last_24hrs" > 0 then 'TA'
    when "order_DTV_added_in_last_24hrs" > 0 then 'Activations'
    when "DTV_PC_Reactivations_In_Last_1D" > 0 or "DTV_AB_Reactivations_In_Last_1D" > 0 then 'Reactivations'
    else 'Other'
    end;
  drop table if exists "Offers_Applied_Sample";
  select *,cast(null as integer) as "Offer_Rnk",cast(null as integer) as "Total_Offers"
    into "Offers_Applied_Sample"
    from "temp_Offers_Applied_Sample"
    where 1 = 0;
  commit work;
  create lf index "idx_1" on "Offers_Applied_Sample"("Overall_Offer_Segment");
  create lf index "idx_2" on "Offers_Applied_Sample"("Subs_Type");
  create hg index "idx_3" on "Offers_Applied_Sample"("Offer_Rnk");
  insert into "Offers_Applied_Sample"
    select *,
      "Row_Number"() over(partition by "Subs_Type","Overall_Offer_Segment" order by "src_system_id" asc) as "Offer_Rnk",
      "count"() over(partition by "Subs_Type","Overall_Offer_Segment") as "Total_Offers"
      from "temp_Offers_Applied_Sample";
  drop table if exists "temp_Offers_Applied_Sample"
end
