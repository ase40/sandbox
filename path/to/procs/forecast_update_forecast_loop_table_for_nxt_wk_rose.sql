create procedure "Decisioning_Procs"."Forecast_Update_Forecast_Loop_Table_For_Nxt_Wk_rose"()
sql security invoker
begin
  update "Forecast_Loop_Table"
    set "end_date" = "end_date"+7;
  -- TODO: SABB not included in this bridging fix
  /*-----------------------------------------------------------------------------------*/
  /* Temp fix for Non TA Offers Fix for Bridging */
  update "Forecast_Loop_Table" as "a"
    set "Curr_Offer_Intended_end_Dt_DTV" = "dateadd"("month",12,"Curr_Offer_Intended_end_Dt_DTV"),
    "Curr_Offer_Intended_end_Dt_Sports" = "dateadd"("month",12,"Curr_Offer_Intended_end_Dt_Sports"),
    "Curr_Offer_Intended_end_Dt_Movies" = "dateadd"("month",12,"Curr_Offer_Intended_end_Dt_Movies") from -- offer extended for 12m
    "Forecast_Loop_Table" as "a"
    where "DTV_Offer_Applied_Bridging_Overlay" = 1
    and "DTV_Active" = 1
    and "Curr_Offer_Intended_end_Dt_DTV" is not null;
  update "Forecast_Loop_Table" as "a"
    set "Curr_Offer_Intended_end_Dt_BB" = "dateadd"("month",12,"Curr_Offer_Intended_end_Dt_BB") from -- offer extended for 12m
    "Forecast_Loop_Table" as "a"
    where "BB_Offer_Applied_Bridging_Overlay" = 1
    and "BB_Active" = 1 and "DTV_Active" = 1
    and "Curr_Offer_Intended_end_Dt_BB" is not null;
  /*----------------------------------------------------------------------*/
  -- PL Status Changes
  -- DTV_PC_Duration_Dist is the table that will randomly assign the number of days left to churn from PC date. 
  -- For AB the duration is a fixed value at 50
  -- These sub_effective_dt fields are used in weekly_Action to arrive at days_to_churn field which is then used again to randomly assign EoW status from current pipeline state.
  -- TODO: Future sub effective date for BB are not there in cust weekly and hence not getting used or updated here.
  update "Forecast_Loop_Table" as "base"
    set "DTV_Last_Pending_Cancel_Dt" = "base"."end_date"-3,
    "DTV_Last_PC_Effective_To_Dt" = '9999-09-09',
    "DTV_Last_PC_Future_Sub_Effective_Dt" = cast("base"."end_date"-3+"dur"."Days_To_churn" as date) from
    "Forecast_Loop_Table" as "base"
    join "DTV_PC_Duration_Dist" as "dur"
    on "rand_DTV_PC_Duration" between "dur"."PC_Days_Lower_Prcntl" and "dur"."PC_Days_Upper_Prcntl"
    where("DTV_PL_Cancels_In_Next_7D" > 0
    --       or WC_DTV_PC > 0
    --       or TA_Sky_Plus_Save > 0
    --       or WC_Sky_Plus_Save > 0
    --       or Other_DTV_PC > 0
    or("base"."DTV_Status_Code" = 'AB' and "base"."DTV_Status_Code_EoW" = 'PC'))
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "DTV_Last_Active_Block_Dt" = "base"."end_date"-3,
    "DTV_Last_AB_Effective_To_Dt" = '9999-09-09',
    "DTV_Last_AB_Future_Sub_Effective_Dt" = cast("base"."end_date"-3+50 as date),
    "DTV_ABs_Ever" = "Coalesce"("DTV_ABs_Ever",0)+1 from
    "Forecast_Loop_Table" as "base"
    where("DTV_ABs_In_Next_7D" > 0
    or("base"."DTV_Status_Code" = 'PC' and "base"."DTV_Status_Code_EoW" = 'AB'))
    --       and base.DTV_Status_Code_EoW = 'AB'
    and "DTV_Active" = 1;
  /* update "Forecast_Loop_Table" as "base"
set "BB_Last_Active_Block_Dt" = "base"."end_date"-3,
"BB_Last_AB_Effective_To_Dt" = '9999-09-09',
"BB_Last_AB_Future_Sub_Effective_Dt" = cast("base"."end_date"-3+50 as date),
"BB_ABs_Ever" = "Coalesce"("BB_ABs_Ever",0)+1 from
"Forecast_Loop_Table" as "base"
where("BB_ABs_In_Next_7D" > 0
or("base"."BB_Status_Code" = 'PC' and "base"."BB_Status_Code_EoW" = 'AB'))
--       and base.DTV_Status_Code_EoW = 'AB'
and "BB_Active" = 1; */
  /*----------------------------------------------------------------------*/
  /*----------------------------------------------------------------------*/
  select distinct "Subs_Type","Overall_Offer_Segment","Total_Offers"
    into #Total_Offers
    from "Offers_Applied_Sample"
    where "offer_Type" = 'Actual';
  commit work;
  create lf index "idx_1" on #Total_Offers("Subs_Type");
  create lf index "idx_2" on #Total_Offers("Overall_Offer_Segment");
  -- Offers
  update "Forecast_Loop_Table"
    set "Prev_Offer_ID_DTV" = "Curr_Offer_ID_DTV",
    "Prev_offer_Actual_end_dt_DTV" = "Curr_Offer_Intended_End_Dt_DTV",
    "Prev_Offer_Amount_DTV" = "Curr_Offer_Amount_DTV",
    "Curr_Offer_ID_DTV" = null,
    "curr_offer_start_dt_DTV" = null,
    "Curr_Offer_Intended_End_Dt_DTV" = null,
    "Curr_Offer_Amount_DTV" = null
    where "Curr_Offer_Intended_end_Dt_DTV" <= "end_date"
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table"
    set "Prev_Offer_ID_Sports" = "Curr_Offer_ID_Sports",
    "Prev_offer_Actual_end_dt_Sports" = "Curr_Offer_Intended_End_Dt_Sports",
    "Prev_Offer_Amount_Sports" = "Curr_Offer_Amount_Sports",
    "Curr_Offer_ID_Sports" = null,
    "curr_offer_start_dt_Sports" = null,
    "Curr_Offer_Intended_End_Dt_Sports" = null,
    "Curr_Offer_Amount_Sports" = null
    where "Curr_Offer_Intended_end_Dt_Sports" <= "end_date"
    and "Sports_Active" = 1;
  update "Forecast_Loop_Table"
    set "Prev_Offer_ID_Movies" = "Curr_Offer_ID_Movies",
    "Prev_offer_Actual_end_dt_Movies" = "Curr_Offer_Intended_End_Dt_Movies",
    "Prev_Offer_Amount_Movies" = "Curr_Offer_Amount_Movies",
    "Curr_Offer_ID_Movies" = null,
    "curr_offer_start_dt_Movies" = null,
    "Curr_Offer_Intended_End_Dt_Movies" = null,
    "Curr_Offer_Amount_Movies" = null
    where "Curr_Offer_Intended_end_Dt_Movies" <= "end_date"
    and "Movies_Active" = 1;
  update "Forecast_Loop_Table"
    set "DTV_Prev_Contract_Actual_End_Dt" = "DTV_Curr_Contract_Intended_End_Dt",
    "DTV_Curr_Contract_Intended_End_Dt" = null
    where "DTV_Curr_Contract_Intended_End_Dt" <= "end_date";
  update "Forecast_Loop_Table"
    set "Prev_Offer_ID_BB" = "Curr_Offer_ID_BB",
    "Prev_offer_Actual_end_dt_BB" = "Curr_Offer_Intended_End_Dt_BB",
    "Prev_Offer_Amount_BB" = "Curr_Offer_Amount_BB",
    "Curr_Offer_ID_BB" = null,
    "curr_offer_start_dt_BB" = null,
    "Curr_Offer_Intended_End_Dt_BB" = null,
    "Curr_Offer_Amount_BB" = null
    where "Curr_Offer_Intended_end_Dt_BB" <= "end_date"
    and "BB_Active" = 1;
  update "Forecast_Loop_Table"
    set "BB_Prev_Contract_Actual_End_Dt" = "BB_Curr_Contract_Intended_End_Dt",
    "BB_Curr_Contract_Intended_End_Dt" = null
    where "BB_Curr_Contract_Intended_End_Dt" <= "end_date";
  -- TA Offers
  -- TODO: TA offers after BBCoE calls
  drop table if exists #Offer_Rnk;
  select "account_number","end_date",
    cast((select "max"("Total_Offers") from #Total_Offers where "Overall_Offer_Segment" = 'TA' and "Subs_Type" = 'DTV Primary Viewing')
    *"rand_New_Off_Dur"+1 as integer) as "Offer_Rnk"
    into #Offer_Rnk
    from "Forecast_Loop_Table"
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" > 0 and "DTV_Active" = 1;
  commit work;
  create hg index "idx_1" on #Offer_Rnk("Account_Number");
  create date index "idx_2" on #Offer_Rnk("end_date");
  create hg index "idx_3" on #Offer_Rnk("Offer_Rnk");
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_DTV" = "offer"."offer_ID",
    "last_offer_applied_dt_dtv" = "base"."end_date"-3,
    "curr_offer_start_dt_DTV" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_DTV" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_DTV" = "offer"."Monthly_Offer_Amount" from
    --     ,DTV_Contract_Applied_In_Next_7D = 1
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number"
    and "rnk"."end_date" = "base"."end_date"
    join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk"
    and "Overall_Offer_Segment" = 'TA'
    and "Subs_Type" = 'DTV Primary Viewing'
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" > 0 and "DTV_Active" = 1;
  --Sports and Cinema offer extension 1
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_Sports" = (case when "base"."Curr_Offer_Intended_End_Dt_Sports"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_ID_Sports" else "base"."Prev_Offer_ID_Sports" end),
    "last_offer_applied_dt_Sports" = "base"."end_date"-3,
    "curr_offer_start_dt_Sports" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_Sports" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_Sports" = (case when "base"."Curr_Offer_Intended_End_Dt_Sports"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_Amount_Sports" else "base"."Prev_Offer_Amount_Sports" end) from
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number" and "rnk"."end_date" = "base"."end_date" join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk" and "Overall_Offer_Segment" = 'TA' and "Subs_Type" = 'DTV Primary Viewing'
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" > 0 and "Sports_Active" = 1
    and(("base"."Curr_Offer_Intended_End_Dt_Sports"-"base"."end_date") <= 42
    or("base"."Curr_Offer_Intended_End_Dt_Sports" is null and "base"."end_date"-"base"."Prev_offer_Actual_end_dt_Sports" <= 42));
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_Movies" = (case when "base"."Curr_Offer_Intended_End_Dt_Movies"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_ID_Movies" else "base"."Prev_Offer_ID_Movies" end),
    "last_offer_applied_dt_Movies" = "base"."end_date"-3,
    "curr_offer_start_dt_Movies" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_Movies" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_Movies" = (case when "base"."Curr_Offer_Intended_End_Dt_Movies"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_Amount_Movies" else "base"."Prev_Offer_Amount_Movies" end) from
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number" and "rnk"."end_date" = "base"."end_date" join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk" and "Overall_Offer_Segment" = 'TA' and "Subs_Type" = 'DTV Primary Viewing'
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" > 0 and "Movies_Active" = 1
    and(("base"."Curr_Offer_Intended_End_Dt_Movies"-"base"."end_date") <= 42
    or("base"."Curr_Offer_Intended_End_Dt_Movies" is null and "base"."end_date"-"base"."Prev_offer_Actual_end_dt_Movies" <= 42));
  -- ends  
  drop table if exists #Offer_Rnk;
  select "account_number","end_date",
    cast((select "max"("Total_Offers") from #Total_Offers where "Overall_Offer_Segment" = 'TA' and "Subs_Type" = 'Broadband DSL Line')
    *"rand_New_Off_Dur"+1 as integer) as "Offer_Rnk"
    into #Offer_Rnk
    from "Forecast_Loop_Table"
    where "Offers_Applied_Next_7D_BB" = 1 and "TA_Call_Cust" > 0 and "BB_Active" = 1;
  commit work;
  create hg index "idx_1" on #Offer_Rnk("Account_Number");
  create date index "idx_2" on #Offer_Rnk("end_date");
  create hg index "idx_3" on #Offer_Rnk("Offer_Rnk");
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_BB" = "offer"."offer_ID",
    "last_offer_applied_dt_BB" = "base"."end_date"-3,
    "curr_offer_start_dt_BB" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_BB" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_BB" = "offer"."Monthly_Offer_Amount" from
    --     ,BB_Contract_Applied_In_Next_7D = 1
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number"
    and "rnk"."end_date" = "base"."end_date"
    join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk"
    and "Overall_Offer_Segment" = 'TA'
    and "Subs_Type" = 'Broadband DSL Line'
    where "Offers_Applied_Next_7D_BB" = 1 and "TA_Call_Cust" > 0 and "BB_Active" = 1;
  -- Other Non TA Offers
  drop table if exists #Offer_Rnk;
  select "account_number","end_date",
    cast((select "max"("Total_Offers") from #Total_Offers where "Overall_Offer_Segment" = 'Other' and "Subs_Type" = 'DTV Primary Viewing')
    *"rand_New_Off_Dur"+1 as integer) as "Offer_Rnk"
    into #Offer_Rnk
    from "Forecast_Loop_Table"
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" = 0 and "DTV_Active" = 1;
  commit work;
  create hg index "idx_1" on #Offer_Rnk("Account_Number");
  create date index "idx_2" on #Offer_Rnk("end_date");
  create hg index "idx_3" on #Offer_Rnk("Offer_Rnk");
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_DTV" = "offer"."offer_ID",
    "last_offer_applied_dt_DTV" = "base"."end_date"-3,
    "curr_offer_start_dt_DTV" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_DTV" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_DTV" = "offer"."Monthly_Offer_Amount" from
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number"
    and "rnk"."end_date" = "base"."end_date"
    join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk"
    and "Overall_Offer_Segment" = 'Other'
    and "Subs_Type" = 'DTV Primary Viewing'
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" = 0 and "DTV_Active" = 1;
  --Sports and Cinema offer extension 2
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_Sports" = (case when "base"."Curr_Offer_Intended_End_Dt_Sports"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_ID_Sports" else "base"."Prev_Offer_ID_Sports" end),
    "last_offer_applied_dt_Sports" = "base"."end_date"-3,
    "curr_offer_start_dt_Sports" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_Sports" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_Sports" = (case when "base"."Curr_Offer_Intended_End_Dt_Sports"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_Amount_Sports" else "base"."Prev_Offer_Amount_Sports" end) from
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number" and "rnk"."end_date" = "base"."end_date" join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk" and "Overall_Offer_Segment" = 'Other' and "Subs_Type" = 'DTV Primary Viewing'
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" = 0 and "Sports_Active" = 1
    and(("base"."Curr_Offer_Intended_End_Dt_Sports"-"base"."end_date") <= 42
    or("base"."Curr_Offer_Intended_End_Dt_Sports" is null and "base"."end_date"-"base"."Prev_offer_Actual_end_dt_Sports" <= 42));
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_Movies" = (case when "base"."Curr_Offer_Intended_End_Dt_Movies"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_ID_Movies" else "base"."Prev_Offer_ID_Movies" end),
    "last_offer_applied_dt_Movies" = "base"."end_date"-3,
    "curr_offer_start_dt_Movies" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_Movies" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_Movies" = (case when "base"."Curr_Offer_Intended_End_Dt_Movies"-"base"."end_date" <= 42 then
      "base"."Curr_Offer_Amount_Movies" else "base"."Prev_Offer_Amount_Movies" end) from
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number" and "rnk"."end_date" = "base"."end_date" join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk" and "Overall_Offer_Segment" = 'Other' and "Subs_Type" = 'DTV Primary Viewing'
    where "Offers_Applied_Next_7D_DTV" = 1 and "TA_Call_Cust" = 0 and "Movies_Active" = 1
    and(("base"."Curr_Offer_Intended_End_Dt_Movies"-"base"."end_date") <= 42
    or("base"."Curr_Offer_Intended_End_Dt_Movies" is null and "base"."end_date"-"base"."Prev_offer_Actual_end_dt_Movies" <= 42));
  -- ends
  -- Code change
  drop table if exists #Offer_Rnk;
  select "account_number","end_date",
    cast((select "max"("Total_Offers") from #Total_Offers where "Overall_Offer_Segment" = 'Other' and "Subs_Type" = 'Broadband DSL Line')
    *"rand_New_Off_Dur"+1 as integer) as "Offer_Rnk"
    into #Offer_Rnk
    from "Forecast_Loop_Table"
    where "Offers_Applied_Next_7D_BB" = 1
    and(("TA_Call_Cust" = 0 or("BBCoE_Call_Cust" > 0 and "BB_Product_Holding_EoW" <> 'NULL') or "BB_Product_Holding_EoW" is null) and "BB_Active" = 1);
  commit work;
  create hg index "idx_1" on #Offer_Rnk("Account_Number");
  create date index "idx_2" on #Offer_Rnk("end_date");
  create hg index "idx_3" on #Offer_Rnk("Offer_Rnk");
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_BB" = "offer"."offer_ID",
    "curr_offer_start_dt_BB" = "base"."end_date"-3,
    -- Line added, code change
    "last_offer_applied_dt_BB" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_BB" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_BB" = "offer"."Monthly_Offer_Amount" from
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number"
    and "rnk"."end_date" = "base"."end_date"
    join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk"
    and "Overall_Offer_Segment" = 'Other'
    and "Subs_Type" = 'Broadband DSL Line'
    where "Offers_Applied_Next_7D_BB" = 1
    and(("TA_Call_Cust" = 0 or("BBCoE_Call_Cust" > 0 and "BB_Product_Holding_EoW" <> 'NULL') or "BB_Product_Holding_EoW" is null) and "BB_Active" = 1);
  drop table if exists #Offer_Rnk;
  select "account_number","end_date",
    cast((select "max"("Total_Offers") from #Total_Offers where "Overall_Offer_Segment" = 'Reactivations' and "Subs_Type" = 'DTV Primary Viewing')
    *"rand_New_Off_Dur"+1 as integer) as "Offer_Rnk"
    into #Offer_Rnk
    from "Forecast_Loop_Table"
    where "Offers_Applied_Next_7D_DTV" = 1
    and(("DTV_Status_Code" = 'PC' and "DTV_Status_Code_EoW" = 'AC')
    or(("DTV_PL_Cancels_In_Next_7D" > 0) and "DTV_Status_Code_EoW" = 'AC'))
    and "DTV_Active" = 1;
  commit work;
  create hg index "idx_1" on #Offer_Rnk("Account_Number");
  create date index "idx_2" on #Offer_Rnk("end_date");
  create hg index "idx_3" on #Offer_Rnk("Offer_Rnk");
  update "Forecast_Loop_Table" as "base"
    set "Curr_Offer_ID_DTV" = "offer"."offer_ID",
    "last_offer_applied_dt_DTV" = "base"."end_date"-3,
    "curr_offer_start_dt_DTV" = "base"."end_date"-3,
    "Curr_Offer_Intended_End_Dt_DTV" = "base"."end_date"-3+("offer"."Intended_Offer_End_Dt"-"offer"."Whole_offer_start_dt_Actual"),
    "Curr_Offer_Amount_DTV" = "offer"."Monthly_Offer_Amount" from
    --     ,DTV_Contract_Applied_In_Next_7D = 1
    "Forecast_Loop_Table" as "base"
    join #Offer_Rnk as "rnk"
    on "rnk"."account_number" = "base"."account_number"
    and "rnk"."end_date" = "base"."end_date"
    join "Offers_Applied_Sample" as "offer"
    on "offer"."offer_Rnk" = "rnk"."offer_rnk"
    and "Overall_Offer_Segment" = 'Reactivations'
    and "Subs_Type" = 'DTV Primary Viewing' --'Broadband DSL Line'
    where "Offers_Applied_Next_7D_DTV" = 1
    and(("DTV_Status_Code" = 'PC' and "DTV_Status_Code_EoW" = 'AC')
    or(("DTV_PL_Cancels_In_Next_7D" > 0) and "DTV_Status_Code_EoW" = 'AC')) /*TA_DTV_PC > 0 or WC_DTV_PC > 0 or TA_Sky_Plus_Save > 0 or WC_Sky_Plus_Save > 0 or Other_DTV_PC > 0*/
    and "DTV_Active" = 1;
  insert into "Offers_Applied_Sample"
    ( "Offer_Type","Account_Number","offer_id",
    "Offer_Leg_Created_Dt","Intended_Offer_End_Dt","Monthly_Offer_Amount","Whole_Offer_Created_dt","Whole_Offer_start_dt_Actual","Activated_Offer" ) 
    select 'Forecast' as "Offer_Type",
      "Account_Number",
      "Curr_Offer_ID_DTV" as "offer_id",
      "end_date"-3 as "Offer_Leg_Created_Dt",
      "Curr_Offer_Intended_End_Dt_DTV" as "Intended_Offer_End_Dt",
      "Curr_Offer_Amount_DTV" as "Monthly_Offer_Amount",
      "end_date"-3 as "Whole_Offer_Created_dt",
      "end_date"-3 as "Whole_Offer_start_dt_Actual",
      1 as "Activated_Offer"
      from "Forecast_Loop_Table"
      where "Offers_Applied_Next_7D_DTV" = 1;
  commit work;
  select "base"."account_number","base"."end_date","count"() as "Offers_Applied"
    into #Offers_Applied
    from "Forecast_Loop_Table" as "base"
      join "Offers_Applied_Sample" as "oas"
      on "oas"."account_number" = "base"."account_number"
      and "oas"."Whole_Offer_start_dt_Actual" between "base"."end_date"-89 and "base"."end_date"
    group by "base"."account_number","base"."end_date";
  commit work;
  create hg index "idx_1" on #Offers_Applied("Account_Number");
  create date index "idx_2" on #Offers_Applied("end_date");
  update "Forecast_Loop_Table" as "base"
    set "Offers_Applied_Lst_90D_DTV" = "Coalesce"("oas"."Offers_Applied",0) from
    "Forecast_Loop_Table" as "base"
    left outer join #Offers_Applied as "oas"
    on "oas"."account_number" = "base"."account_number"
    and "oas"."end_date" = "base"."end_date";
  update "Forecast_Loop_Table"
    set "Prev_offer_Actual_end_dt_DTV" = null
    where "Prev_offer_Actual_end_dt_DTV" < ("end_date")-53*7;
  update "Forecast_Loop_Table"
    set "Prev_offer_Actual_end_dt_BB" = null
    where "Prev_offer_Actual_end_dt_BB" < ("end_date")-53*7;
  /*----------------------------------------------------------------------*/
  /*----------------------------------------------------------------------*/
  -- Contracts Applied
  -- TODO: Discuss why the BB contract is applied only to the customer with holding_eow not null
  update "Forecast_Loop_Table" as "Base"
    set "DTV_Curr_Contract_Start_Dt" = "end_date"-3,
    "DTV_Curr_Contract_Intended_End_Dt" = "dateadd"("month",12,"end_date"-3)
    where "DTV_Contracts_Applied_In_Next_7D" > 0;
  update "Forecast_Loop_Table" as "Base"
    set "BB_Curr_Contract_Start_Dt" = "end_date"-3,
    "BB_Curr_Contract_Intended_End_Dt" = "dateadd"("month",12,"end_date"-3)
    where "BB_Contracts_Applied_In_Next_7D" > 0 and("BB_Product_Holding_EoW" is null or "BB_Product_Holding_EoW" <> 'NULL');
  -- Rose migration - updating the product holding to sky entertainment
  update "Forecast_Loop_Table" as "Base"
    set "DTV_Product_Holding" = "DTV_Product_holding_eow"
    where "Rose_migration_in_next_7d" > 0;
  /*----------------------------------------------------------------------*/
  -- Select DTV_Status_Code,DTV_PL_Cancels_In_Next_7D,DTV_SDCs_In_Next_7D,DTV_Status_Code_EoW,count(*)*4 as Base
  -- from Forecast_Loop_Table
  -- where DTV_Active = 1
  -- group by DTV_Status_Code,DTV_PL_Cancels_In_Next_7D,DTV_SDCs_In_Next_7D,DTV_Status_Code_EoW
  --
  /*----------------------------------------------------------------------*/
  -- Update Status Codes
  update "Forecast_Loop_Table"
    set "DTV_Status_Code" = "Coalesce"("DTV_Status_Code_EoW","DTV_Status_Code");
  update "Forecast_Loop_Table"
    set "DTV_Active" = case when "DTV_Status_Code" in( 'AC','AB','PC' ) then 1 else 0 end;
  update "Forecast_Loop_Table"
    set "BB_Status_Code" = "Coalesce"("BB_Status_Code_EoW","BB_Status_Code"),
    "BB_Product_Holding" = case when "BB_Product_Holding_EoW" is not null and "BB_Product_Holding_EoW" <> 'NULL' then "BB_Product_Holding_EoW" else "BB_Product_Holding" end;
  update "Forecast_Loop_Table"
    set "BB_Active" = case when "BB_Status_Code" in( 'AC','AB','PC','BCRQ' ) then 1 else 0 end;
  /*----------------------------------------------------------------------*/
  /*----------------------------------------------------------------------*/
  -- Update prev TA details
  -- TODO: Make the last call variables rolling.
  update "Forecast_Loop_Table"
    set "Last_TA_dt" = case when "TA_Call_Cust" > 0 then "end_date"-3 else "Last_TA_dt" end,
    --\\\\x09"Last_BBCoE_Call_Dt" = case when "BBCoE_Call_Cust" > 0 then "end_date"-3 else "Last_BBCoE_Call_Dt" end,
    "last_Value_Call_dt" = case when "Value_Call_Cust" > 0 then "end_date"-3 else "last_Value_Call_dt" end,
    --"Last_bill_date" = case when "end_date" - "Last_bill_date" > 30 then "Last_bill_date"+30 else "Last_bill_date" end,
    --\\\\x09"BBCoE_Calls_In_Last_30D" = case when "end_date"-"Last_BBCoE_Call_Dt" > 30 then 0 else "BBCoE_Calls_In_Last_30D" + "BBCoE_Calls_In_Next_7D" end,
    --\\\\x09"BBCoE_Calls_In_Last_90D" = case when "end_date"-"Last_BBCoE_Call_Dt" > 90 then 0 else "BBCoE_Calls_In_Last_90D" + "BBCoE_Calls_In_Next_7D" end,
    --\\\\x09"BBCoE_Calls_In_Last_1yr" = case when "end_date"-"Last_BBCoE_Call_Dt" > 365 then 0 else "BBCoE_Calls_In_Last_1yr" + "BBCoE_Calls_In_Next_7D" end,
    --\\\\x09"Value_Calls_In_Last_30D" = case when "end_date"-"Last_Value_Call_Dt" > 30 then 0 else "Value_Calls_In_Last_30D" + "Value_Calls_In_Next_7D" end,
    --\\\\x09"TAs_in_last_14d" = case when "end_date"-"Last_TA_dt" > 14 then 0 else "TAs_in_last_14d" + "TAs_in_next_7d" end,
    --\\\\x09"TAs_in_last_60d" = case when "end_date"-"Last_TA_dt" > 60 then 0 else "TAs_in_last_60d" + "TAs_in_next_7d" end,
    -- TODO: DTV_PC_in_last_xx - need to confirm the logic
    --\\\\x09"DTV_PCs_In_Last_30D_float" = (case when "Coalesce"("DTV_PCs_In_Last_30D_float",0) > "Coalesce"("DTV_PCs_In_Last_30D",0) then "Coalesce"("DTV_PCs_In_Last_30D",0) else "Coalesce"("DTV_PCs_In_Last_30D_float",0) end)*0.8 + "DTV_PL_Cancels_In_Next_7D",
    --\\\\x09"DTV_PCs_In_Last_30D" = "round"("DTV_PCs_In_Last_30D_float",0),
    --\\\\x09"DTV_PCs_In_Last_1yr_float" = (case when "Coalesce"("DTV_PCs_In_Last_1yr_float",0) > "Coalesce"("DTV_PCs_In_Last_1yr",0) then "Coalesce"("DTV_PCs_In_Last_1yr",0) else "Coalesce"("DTV_PCs_In_Last_1yr_float",0) end)*0.8 + "DTV_PL_Cancels_In_Next_7D",
    --\\\\x09"DTV_PCs_In_Last_1yr" = "round"("DTV_PCs_In_Last_1yr_float",0),
    "TAs_in_last_36m" = "Coalesce"("TAs_in_last_36m",0)+"TAs_in_next_7d",
    --  "TA_saves_in_last_36m" = "Coalesce"("TA_saves_in_last_36m",0)+"TA_saves_in_next_7d",
    "TA_Wks_To_Overlay_Nulled" = case when "TA_Wks_To_Overlay_Nulled" > 0 then "TA_Wks_To_Overlay_Nulled"-1 else 0 end,
    "Value_Calls_In_Last_5Yr" = "Coalesce"("Value_Calls_In_Last_5Yr",0)+"Value_Calls_In_Next_7D",
    "Value_Calls_Ever" = "Coalesce"("Value_Calls_Ever",0)+"Value_Calls_In_Next_7D",
    "Offers_Applied_Ever_DTV" = "Coalesce"("Offers_Applied_Ever_DTV",0)+"Offers_Applied_Next_7D_DTV"
/*----------------------------------------------------------------------*/
end
