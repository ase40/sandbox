create procedure "Decisioning_Procs"."Create_Forecast_Loop_Table"( 
  in "Input_Table_Name" varchar(100) default 'Forecast_Loop_Table', -- Forecast_Loop_Table_2 to create table for start of next loop, CITeam.Cust_Weekly_Base to create opening base
  in "Cust_Weekly_Base_Fcast_Fields" long varchar,
  in "Forecast_Start_Wk" integer default null,
  in "sample_pct" real default null ) 
sql security invoker
begin
  declare "true_sample_rate" real;
  declare "multiplier" bigint;
  declare "Dynamic_SQL" long varchar;
  set "multiplier" = "DATEPART"("millisecond","now"())+738;
  set temporary option "Query_Temp_Space_Limit" = 0;
  if "lower"("Input_Table_Name") = 'fcast_sim_output' then
    execute immediate 'Drop table if exists Forecast_Loop_Table';
    execute immediate ''
       || ' Select * into Forecast_Loop_Table from fcast_sim_output where end_date = (Select max(end_date) from fcast_sim_output)';
    commit work;
    return
  end if;
  if "Input_Table_Name" <> 'Forecast_Loop_Table' then
    execute immediate 'Drop table if exists Forecast_Loop_Table';
    execute immediate ''
       || ' Select account_number,end_date '
       || "Cust_Weekly_Base_Fcast_Fields"
      -- Fields derived from base data
      -- || ' ,Cast(null as date) as DTV_PC_Future_Sub_Effective_Dt,Cast(null as date) as DTV_AB_Future_Sub_Effective_Dt '
       || ' ,Cast(null as varchar(10)) as BB_SysCan_PL_Next_Status,Cast(null as date) as BB_SysCan_PL_Next_Status_Dt '
       || ' ,Cast(null as varchar(28)) as Time_To_Offer_End_BB,Cast(null as varchar(28)) as Time_To_Offer_End_LR '
       || ' ,Cast(null as varchar(20)) as Previous_ABs_Binned, Cast(null as integer) as AB_Days_Since_Last_Payment_Dt '
       || ' ,Cast(null as varchar(100)) as CusCan_Forecast_Segment,Cast(null as varchar(100)) as SysCan_Forecast_Segment,Cast(null as varchar(100)) as DTV_Activation_Type,Cast(null as varchar(70)) as HD_segment '
      /*------------------------------------------------*/
      /* Random Sampling Fields ------------------------*/
      /*------------------------------------------------*/
       || ' ,Cast(null as float)  as rand_action_Cuscan '
       || ' ,Cast(null as float)  as rand_action_Syscan '
       || ' ,Cast(null as float)  as rand_BBCoE_Call '
       || ' ,Cast(null as float)  as rand_Value_Call '
       || ' ,Cast(null as float)  as rand_TA_Vol '
       || ' ,Cast(null as float)  as rand_WC_Vol '
       || ' ,Cast(null as float)  as rand_Value_Vol '
      -- || ' ,Cast(null as float)  as rand_TA_Save_Vol '
      -- || ' ,Cast(null as float)  as rand_WC_Save_Vol '
       || ' ,Cast(null as float)  as rand_TA_DTV_Offer_Applied '
       || ' ,Cast(null as float)  as rand_NonTA_DTV_Offer_Applied '
       || ' ,Cast(null as float)  as rand_NonTA_BB_Offer_Applied '
       || ' ,Cast(null as float)  as rand_TA_DTV_PC_Vol '
       || ' ,Cast(null as float)  as rand_WC_DTV_PC_Vol '
       || ' ,Cast(null as float)  as rand_Other_DTV_PC_Vol '
       || ' ,Cast(null as float)  as rand_TP_cond '
       || ' ,Cast(null as float)  as rand_cuscan_TP_cond '
       || ' ,Cast(null as float)  as rand_Intrawk_DTV_PC '
       || ' ,Cast(null as float)  as rand_DTV_PC_Duration '
       || ' ,Cast(null as float)  as rand_DTV_PC_Status_Change '
       || ' ,Cast(null as numeric(20,18))  as rand_New_Off_Dur '
       || ' ,Cast(null as float)  as rand_Intrawk_DTV_AB '
       || ' ,Cast(null as float)  as rand_BB_SysCan '
       || ' ,Cast(null as float)  as rand_BB_Regrade '
       || ' ,Cast(null as float)  as rand_OC_model '
       || ' ,Cast(null as varchar(20))  as OC_model_out '
       || ' ,Cast(null as float)  as P_target00 '
       || ' ,Cast(null as float)  as P_target01 '
       || ' ,Cast(null as float)  as P_target10 '
       || ' ,Cast(null as float)  as P_target11 '
      /*------------------------------------------------*/
      /* Rates -----------------------------------------*/
      /*------------------------------------------------*/
      -- BBCoE Call Rates
       || ' ,Cast(null as float) as pred_BBCoE_Call_Cust_rate,Cast(null as float) as pred_BBCoE_Call_Cust_rate_Pre_Seas,Cast(null as float) as cum_BBCoE_Call_Cust_rate_pre_overlay '
      -- Value Call Rates
       || ' ,Cast(null as float) as pred_Value_Call_Cust_rate,Cast(null as float) as pred_Value_Call_Cust_rate_Pre_Seas,Cast(null as float) as cum_Value_Call_Cust_rate_pre_overlay '
      -- TA_Rates
       || ' ,Cast(null as float) as pred_TA_Call_Cust_rate,Cast(null as float) as pred_TA_Call_Cust_rate_Pre_Seas,Cast(null as float) as cum_TA_Call_Cust_rate,Cast(null as float) as cum_TA_Call_Cust_rate_pre_overlay '
      --Web Chat Rates
       || ' ,Cast(null as float) as pred_Web_Chat_TA_Cust_rate,Cast(null as float) as pred_Web_Chat_TA_Cust_YoY_Trend,Cast(null as float) as cum_Web_Chat_TA_Cust_rate,Cast(null as float) as cum_Web_Chat_TA_Cust_rate_pre_overlay,Cast(null as float) as cum_Web_Chat_TA_Cust_Trend_rate '
      --syscan
       || ' ,Cast(null as float) as pred_DTV_AB_rate,Cast(null as float) as pred_DTV_YoY_Trend,Cast(null as float) as cum_DTV_AB_rate,cast(null as float) as cum_DTV_AB_Trend_rate '
      -- Other Offers Applied
       || ' ,Cast(null as float) as pred_NonTA_DTV_Offer_and_Contract_Applied_rate,Cast(null as float) as pred_NonTA_DTV_Offer_Applied_rate,Cast(null as float) as pred_NonTA_DTV_Contract_Applied_rate ' -- Other DTV Offers
       || ' ,Cast(null as float) as pred_NonTA_BB_Offer_and_Contract_Applied_rate,Cast(null as float) as pred_NonTA_BB_Offer_Applied_rate,Cast(null as float) as pred_NonTA_BB_Contract_Applied_rate ' -- Other BB Offers
       || ' ,Cast(null as float) as pred_Offer_Bridging_rate '
      -- BB PL Rates
       || ' ,Cast(null as float) as pred_PC_TP_EnterCusCan_Conv_rate,Cast(null as float) as pred_PC_TP_Enter3rdParty_Conv_rate '
       || ' ,Cast(null as float) as pred_SDC_TP_EnterCusCan_Conv_rate,Cast(null as float) as pred_SDC_TP_Enter3rdParty_Conv_rate '
      -- Web Chat PC Conversaion Rates
       || ' ,cast(null as float) as pred_WC_DTV_PC_rate,cast(null as float) as pred_WC_DTV_SDC_rate,cast(null as float) as pred_WC_Sky_Plus_Save_rate,Cast(null as float) as cum_WC_DTV_PC_rate '
      -- Other PC Rates
       || ' ,Cast(null as float) as pred_Other_DTV_PC_rate,Cast(null as float) as pred_Other_DTV_SDC_rate '
      -- TA -> PC rates
      -- || ' ,cast(null as float) as pred_TA_DTV_PC_rate,cast(null as float) as pred_TA_Sky_Plus_Save_rate,Cast(null as float) as cum_TA_DTV_PC_rate,cast(null as float) as pred_TA_DTV_SDC_rate '
      /*------------------------------------------------*/
      /* Actions ---------------------------------------*/
      /*------------------------------------------------*/
      -- New Customer Activations
       || ',Cast(null as integer) as New_DTV_Customer,Cast(null as integer) as New_BB_Customer '
      -- Churn Events
      -- || ' ,cast(null as tinyint) as CusCan,cast(null as tinyint) as SysCan '
       || ',Cast(null as tinyint) as BB_Churn '
      -- Other Offers Applied
      -- || ' ,cast(null as tinyint) as DTV_Offer_Applied,cast(null as tinyint) as BB_Offer_Applied '
       || ' ,cast(null as tinyint) as DTV_Offer_Applied_pre_overlay,cast(null as tinyint) as DTV_Offer_Applied_Bridging_Overlay '
       || ' ,cast(null as tinyint) as BB_Offer_Applied_pre_overlay,cast(null as tinyint) as BB_Offer_Applied_Bridging_Overlay '
      -- Contracts Applied
      //|| ',Cast(null as tinyint) as DTV_Contract_Applied_In_Next_7D '
      //|| ',Cast(null as tinyint) as BB_Contract_Applied_In_Next_7D '
      -- BBCoE Events
       || ' ,cast(null as tinyint) as BBCoE_Call_Cust '
      -- Value Events
       || ' ,cast(null as tinyint) as Value_Call_Cust '
      -- TA Events
       || ' ,cast(null as tinyint) as TA_Call_Cust,cast(null as tinyint) as TA_Call_Cust_pre_overlay,cast(null as tinyint) as TAs_in_next_7d_pre_overlay '
       || ' ,cast(null as tinyint) as TA_saves_in_next_7d_pre_overlay,cast(null as tinyint) as TA_Non_Saves '
       || ' ,Cast(null as tinyint) as TA_Wks_To_Overlay_Nulled '
      --Web Chat Events
       || ' ,cast(null as tinyint) as WC_Call_Cust,cast(null as tinyint) as WC_Call_Cust_pre_overlay '
       || ' ,cast(null as tinyint) as LiveChats_in_next_7d_pre_overlay '
       || ' ,cast(null as tinyint) as LiveChat_Saves_in_next_7d_pre_overlay,cast(null as tinyint) as WC_Saves_pre_overlay,cast(null as tinyint) as WC_Non_Saves '
      -- BB PL Entries
       || ' ,CAST(null AS TINYINT) AS BB_Enter_SysCan '
       || ' ,cast(null as tinyint) as BB_Enter_CusCan,cast(null as tinyint) as BB_Enter_3rdParty '
      /*------------------------------------------------*/
      /* Cust Status EoW -------------------------------*/
      /*------------------------------------------------*/
      -- Product Holding Movements
       || ' ,Cast(null as varchar(10)) as DTV_Status_Code_EoW '
       || ' ,Cast(null as varchar(10)) as BB_Status_Code_EoW,cast(null as varchar(100) ) as BB_Product_Holding_EoW '
      -- PC flags
       || ' ,cast(null as tinyint) as TP_Enter_CusCan,cast(null as tinyint) as TP_Enter_3rdParty '
      -- || ' ,cast(null as tinyint) as TA_DTV_PC,cast(null as tinyint) as TA_DTV_SDC,cast(null as tinyint) as WC_DTV_PC,cast(null as tinyint) as WC_DTV_SDC '
      -- || ' ,cast(null as tinyint) as Other_DTV_PC,cast(null as tinyint) as Other_DTV_SDC '
      -- Sky+ Saves
      -- || ' ,cast(null as tinyint)  as TA_Sky_Plus_Save,cast(null as tinyint)  as WC_Sky_Plus_Save '
       || ' into Forecast_Loop_Table '
       || ' from ' || "Input_Table_Name" || ' '
       || case when "Input_Table_Name" = 'CITeam.Cust_Weekly_Base' then
        ' where end_date = (Select min(calendar_date -1) from sky_calendar where Cast(subs_week_and_year as integer) = Forecast_Start_Wk) '
         || '       and Static_Sampling_Rand <= ' || "sample_pct"
      end; --     when "Input_Table_Name" = 'FCAST_Sim_Output' then
    --       ' where end_date = (Select max(end_date) from ' || "Input_Table_Name" || ')'
    commit work;
    create hg index "idx_1" on "Forecast_Loop_Table"("Account_number");
    create cmp index "idx_2" on "Forecast_Loop_Table"("Curr_Offer_Intended_end_Dt_DTV","end_date");
    create lf index "idx_4" on "Forecast_Loop_Table"("TA_Call_Cust");
    create lf index "idx_5" on "Forecast_Loop_Table"("DTV_Status_Code");
    create lf index "idx_6" on "Forecast_Loop_Table"("DTV_Status_Code_EoW");
    create lf index "idx_11" on "Forecast_Loop_Table"("WC_Call_Cust");
    create date index "idx_16" on "Forecast_Loop_Table"("end_date");
    create hng index "idx_18" on "Forecast_Loop_Table"("rand_New_Off_Dur");
    create lf index "idx_19" on "Forecast_Loop_Table"("Sports_Active");
    create lf index "idx_20" on "Forecast_Loop_Table"("Movies_Active")
  end if;
  /* Add BB product holding for new customers whose BB has been ordered but not activated*/
  if "Input_Table_Name" = 'CITeam.Cust_Weekly_Base' then
    drop table if exists #BB_Orders;
    select "sample"."account_number","sample"."end_date",
      "BB_Added_Product",
      "Row_Number"() over(partition by "sample"."account_number","sample"."end_date" order by "order_dt" desc) as "Order_Rnk"
      into #BB_Orders
      from "Forecast_Loop_Table" as "sample"
        join "CITeam"."Orders_Daily" as "od"
        on "od"."account_number" = "sample"."account_number"
        and "od"."order_dt" between "sample"."DTV_Last_Activation_Dt"-30 and "sample"."DTV_Last_Activation_Dt"
        and "sample"."DTV_Last_Activation_Dt" >= "sample"."end_date"-30
        and "sample"."BB_Product_Holding" is null
        and "od"."BB_Added_Product" is not null and "BB_Removed_Product" is null;
    delete from #BB_Orders where "Order_Rnk" > 1;
    update #BB_Orders
      set "BB_Added_Product" = "trim"("str_replace"("str_replace"("BB_Added_Product",'Sky ',''),'Broadband ',''));
    update #BB_Orders
      set "BB_Added_Product" = case "BB_Added_Product" when 'Fibre' then 'Sky Fibre'
      else "BB_Added_Product"
      end;
    update "Forecast_Loop_Table" as "sample"
      set "BB_Product_Holding" = "bbo"."BB_Added_Product",
      "BB_Active" = 1,
      "BB_Last_Activation_Dt" = "sample"."end_date" from
      #BB_Orders as "bbo"
      where "bbo"."account_number" = "sample"."account_number"
      and "bbo"."end_date" = "sample"."end_date"
      and "sample"."BB_Product_Holding" is null
  end if;
  ------------------------------------------------------
  -- Select * from sp_columns('Forecast_Loop_Table') where table_owner = 'menziesm'
  update "Forecast_Loop_Table"
    set "DTV_Status_Code_EoW" = null,
    "BB_Status_Code_EoW" = null,
    "BB_SysCan_PL_Next_Status" = null,
    "BB_SysCan_PL_Next_Status_Dt" = null,
    "Time_To_Offer_End_BB" = null,
    "Time_To_Offer_End_LR" = null,
    "AB_Days_Since_Last_Payment_Dt" = null,
    "Previous_ABs_Binned" = null,
    "CusCan_Forecast_Segment" = null,
    "SysCan_Forecast_Segment" = null,
    "DTV_Activation_Type" = null,
    "HD_segment" = null,
    "BB_Product_Holding_EoW" = null,
    "rand_action_Cuscan" = null,
    "rand_action_Syscan" = null,
    "rand_BBCoE_Call" = null,
    "rand_Value_Call" = null,
    "rand_TA_Vol" = null,
    "rand_WC_Vol" = null,
    "rand_Value_Vol" = null,
    -- ,rand_TA_Save_Vol=null
    -- ,rand_WC_Save_Vol=null
    "rand_TA_DTV_Offer_Applied" = null,
    "rand_NonTA_DTV_Offer_Applied" = null,
    "rand_NonTA_BB_Offer_Applied" = null,
    "rand_TA_DTV_PC_Vol" = null,
    "rand_WC_DTV_PC_Vol" = null,
    "rand_Other_DTV_PC_Vol" = null,
    "rand_TP_cond" = null,
    "rand_cuscan_TP_cond" = null,
    "rand_Intrawk_DTV_PC" = null,
    "rand_DTV_PC_Duration" = null,
    "rand_DTV_PC_Status_Change" = null,
    "rand_New_Off_Dur" = null,
    "rand_Intrawk_DTV_AB" = null,
    "rand_BB_SysCan" = null,
    "New_DTV_Customer" = 0,
    "New_BB_Customer" = 0,
    -- ,CusCan=0
    -- ,SysCan=0
    "rand_OC_model" = null,
    "OC_model_out" = null,
    "P_target00" = 0,
    "P_target01" = 0,
    "P_target10" = 0,
    "P_target11" = 0,
    "BB_Churn" = 0,
    "pred_TA_Call_Cust_rate" = 0,
    "cum_TA_Call_Cust_rate" = 0,
    "cum_TA_Call_Cust_rate_pre_overlay" = 0,
    "pred_Web_Chat_TA_Cust_rate" = 0,
    "pred_Web_Chat_TA_Cust_YoY_Trend" = 0,
    "cum_Web_Chat_TA_Cust_rate" = 0,
    "cum_Web_Chat_TA_Cust_rate_pre_overlay" = 0,
    "cum_Web_Chat_TA_Cust_Trend_rate" = 0,
    "pred_BBCoE_Call_Cust_rate" = 0,
    "cum_BBCoE_Call_Cust_rate_pre_overlay" = 0,
    "pred_Value_Call_Cust_rate" = 0,
    "cum_Value_Call_Cust_rate_pre_overlay" = 0,
    "pred_DTV_AB_rate" = 0,
    "pred_DTV_YoY_Trend" = 0,
    "cum_DTV_AB_rate" = 0,
    "cum_DTV_AB_Trend_rate" = 0,
    "pred_NonTA_DTV_Offer_and_Contract_Applied_rate" = 0,
    "pred_NonTA_DTV_Offer_Applied_rate" = 0,
    "pred_NonTA_DTV_Contract_Applied_rate" = 0,
    "pred_NonTA_BB_Offer_and_Contract_Applied_rate" = 0,
    "pred_NonTA_BB_Offer_Applied_rate" = 0,
    "pred_NonTA_BB_Contract_Applied_rate" = 0,
    "pred_Offer_Bridging_rate" = 0,
    "DTV_Offer_Applied_pre_overlay" = 0,
    "DTV_Offer_Applied_Bridging_Overlay" = 0,
    "BB_Offer_Applied_pre_overlay" = 0,
    "BB_Offer_Applied_Bridging_Overlay" = 0,
    "Value_Call_Cust" = 0,
    "TA_Call_Cust" = 0,
    -- ,TA_Call_Count=0
    "TA_Call_Cust_pre_overlay" = 0,
    "TAs_in_next_7d_pre_overlay" = 0,
    "TA_Saves_in_next_7d_pre_overlay" = 0,
    -- ,TA_Saves_pre_overlay=0
    "TA_Non_Saves" = 0,
    "TA_Wks_To_Overlay_Nulled" = 0,
    "WC_Call_Cust" = 0,
    "LiveChats_in_next_7d" = 0,
    "LiveChat_saves_in_next_7d" = 0,
    "LiveChats_in_next_7d_pre_overlay" = 0,
    "LiveChat_saves_in_next_7d_pre_overlay" = 0,
    "WC_Non_Saves" = 0,
    "BB_Enter_SysCan" = 0,
    "pred_PC_TP_EnterCusCan_Conv_rate" = 0,
    "pred_PC_TP_Enter3rdParty_Conv_rate" = 0,
    "pred_SDC_TP_EnterCusCan_Conv_rate" = 0,
    "pred_SDC_TP_Enter3rdParty_Conv_rate" = 0,
    "BB_Enter_CusCan" = 0,
    "BB_Enter_3rdParty" = 0,
    "pred_WC_DTV_PC_rate" = 0,
    "pred_WC_DTV_SDC_rate" = 0,
    "pred_WC_Sky_Plus_Save_rate" = 0,
    "cum_WC_DTV_PC_rate" = 0,
    "pred_Other_DTV_PC_rate" = 0,
    "pred_Other_DTV_SDC_rate" = 0,
    -- ,TA_DTV_PC=0
    -- ,TA_DTV_SDC=0
    "TP_Enter_CusCan" = 0,
    "TP_Enter_3rdParty" = 0,
    "TAs_in_next_7d" = 0,"TA_Saves_in_next_7d" = 0,"Value_Calls_In_Next_7D" = 0, -- Calls
    "DTV_PL_Cancels_In_Next_7D" = 0,"DTV_SDCs_In_Next_7D" = 0,"DTV_ABs_In_Next_7D" = 0, -- Pipeline
    "DTV_PO_Cancellations_In_Next_7D" = 0,"DTV_SameDayCancels_In_Next_7D" = 0,"DTV_SysCan_Churns_In_Next_7D" = 0, -- Churn
    "Offers_Applied_Next_7D_DTV" = 0,"Offers_Applied_Next_7D_BB" = 0,
    "DTV_Contracts_Applied_In_Next_7d" = 0,"BB_Contracts_Applied_In_Next_7d" = 0;
  update "Forecast_Loop_Table"
    /* Simple_Segment
= case when trim(simple_segment) in ('1 Secure')       then '1 Secure'
when trim(simple_segment) in ('2 Start', '3 Stimulate','2 Stimulate')  then '2 Stimulate'
when trim(simple_segment) in ('4 Support','3 Support')      then '3 Support'
when trim(simple_segment) in ('5 Stabilise','4 Stabilise')    then '4 Stabilise'
else 'Other/Unknown'
end
, */
    set "Time_To_Offer_End_BB"
     = case when "Curr_Offer_intended_end_Dt_BB" between("end_date"+1) and("end_date"+7) then 'Offer Ending in Next 1 Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+8) and("end_date"+14) then 'Offer Ending in Next 2-3 Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+15) and("end_date"+21) then 'Offer Ending in Next 2-3 Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+22) and("end_date"+28) then 'Offer Ending in Next 4-6 Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+29) and("end_date"+35) then 'Offer Ending in Next 4-6 Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+36) and("end_date"+42) then 'Offer Ending in Next 4-6 Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+43) and("end_date"+49) then 'Offer Ending in 7+ Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+50) and("end_date"+56) then 'Offer Ending in 7+ Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+57) and("end_date"+63) then 'Offer Ending in 7+ Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+64) and("end_date"+70) then 'Offer Ending in 7+ Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+71) and("end_date"+77) then 'Offer Ending in 7+ Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+78) and("end_date"+84) then 'Offer Ending in 7+ Wks'
    when "Curr_Offer_intended_end_Dt_BB" between("end_date"+85) and("end_date"+91) then 'Offer Ending in 7+ Wks'
    when "Curr_Offer_intended_end_Dt_BB" >= ("end_date"+92) then 'Offer Ending in 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-7) and "end_date" then 'Offer Ended in last 1 Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-14) and("end_date"-8) then 'Offer Ended in last 2-3 Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-21) and("end_date"-15) then 'Offer Ended in last 2-3 Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-28) and("end_date"-22) then 'Offer Ended in last 4-6 Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-35) and("end_date"-29) then 'Offer Ended in last 4-6 Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-42) and("end_date"-36) then 'Offer Ended in last 4-6 Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-49) and("end_date"-43) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-56) and("end_date"-50) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-63) and("end_date"-57) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-70) and("end_date"-64) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-77) and("end_date"-71) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-84) and("end_date"-78) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" between("end_date"-91) and("end_date"-85) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" <= ("end_date"-92) then 'Offer Ended 7+ Wks'
    when "Prev_offer_Actual_end_Dt_BB" is null then 'Null'
    when "Curr_Offer_intended_end_Dt_BB" is null then 'Null'
    else 'No Offer End BB'
    end,
    "Time_To_Offer_End_LR"
     = case when "Curr_Offer_Intended_end_Dt_LR" between("end_date"+1) and("end_date"+7) then 'Offer Ending in Next 1 Wks'
    when "Curr_Offer_Intended_end_Dt_LR" between("end_date"+8) and("end_date"+14) then 'Offer Ending in Next 2-3 Wks'
    when "Curr_Offer_Intended_end_Dt_LR" between("end_date"+15) and("end_date"+21) then 'Offer Ending in Next 2-3 Wks'
    when "Curr_Offer_Intended_end_Dt_LR" between("end_date"+22) and("end_date"+28) then 'Offer Ending in Next 4-6 Wks'
    when "Curr_Offer_Intended_end_Dt_LR" between("end_date"+29) and("end_date"+35) then 'Offer Ending in Next 4-6 Wks'
    when "Curr_Offer_Intended_end_Dt_LR" between("end_date"+36) and("end_date"+42) then 'Offer Ending in Next 4-6 Wks'
    when "Curr_Offer_Intended_end_Dt_LR" > ("end_date"+42) then 'Offer Ending in 7+ Wks'
    when "Prev_offer_Actual_end_dt_LR" between("end_date"-7) and "end_date" then 'Offer Ended in last 1 Wks'
    when "Prev_offer_Actual_end_dt_LR" between("end_date"-14) and("end_date"-8) then 'Offer Ended in last 2-3 Wks'
    when "Prev_offer_Actual_end_dt_LR" between("end_date"-21) and("end_date"-15) then 'Offer Ended in last 2-3 Wks'
    when "Prev_offer_Actual_end_dt_LR" between("end_date"-28) and("end_date"-22) then 'Offer Ended in last 4-6 Wks'
    when "Prev_offer_Actual_end_dt_LR" between("end_date"-35) and("end_date"-29) then 'Offer Ended in last 4-6 Wks'
    when "Prev_offer_Actual_end_dt_LR" between("end_date"-42) and("end_date"-36) then 'Offer Ended in last 4-6 Wks'
    when "Prev_offer_Actual_end_dt_LR" < ("end_date"-42) then 'Offer Ended 7+ Wks'
    else 'No Offer LR'
    end;
  -- ,DTV_Tenure
  --  = case when  Cast(end_date as integer)  - Cast(dtv_last_activation_dt as integer) <  round(365/12*1,0)     then 'M01'
  --   when  Cast(end_date as integer)  - Cast(dtv_last_activation_dt as integer) <  round(365/12*10,0)    then 'M10'
  --   when  Cast(end_date as integer)  - Cast(dtv_last_activation_dt as integer) <  round(365/12*14,0)    then 'M14'
  --   when  Cast(end_date as integer)  - Cast(dtv_last_activation_dt as integer) <  round(365/12*2*12,0)  then 'M24'
  --   when  Cast(end_date as integer)  - Cast(dtv_last_activation_dt as integer) <  round(365/12*3*12,0)  then 'Y03'
  --   when  Cast(end_date as integer)  - Cast(dtv_last_activation_dt as integer) <  round(365/12*5*12,0)  then 'Y05'
  --   when  Cast(end_date as integer)  - Cast(dtv_last_activation_dt as integer) >=  round(365/12*5*12,0) then 'Y05+'
  -- end
  -- ,Time_Since_Last_TA_call
  --  = Case when Last_TA_dt is null then 'No Prev TA Calls'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7  = 0 then '0 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 = 1 then '01 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 between 2 and 5 then '02-05 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 between 6 and 35 then '06-35 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 between 36 and 41 then '36-46 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 between 42 and 46 then '36-46 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 = 47 then '47 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 between 48 and 52 then '48-52 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 between 53 and 60 then '53-60 Wks since last TA Call'
  --      when (Cast(end_date as integer) - Cast(Last_TA_dt as integer))/7 > 60 then '61+ Wks since last TA Call'
  --      Else ''
  -- End
  -- ,Time_Since_Last_AB =
  --         Case when Coalesce(DTV_ABs_Ever,0) = 0 then 'N/A'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 = 0 then '0 Wks'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <= 2 then '1-2 Wks'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <= 4 then '3-4 Wks'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=6 then '5-6 Wks'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=7 then '7 Wks'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=8 then '8 Wks'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=11 then '9-11 Wks'
  --              when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=12 then '12 Wks'
  --              else '13+ Wks'
  --         end
  -- ,Previous_AB_Count
  --  = Case when DTV_ABs_Ever <= 5 then '' || DTV_ABs_Ever
  --       when DTV_ABs_Ever <= 20 then '6-20'
  --       when DTV_ABs_Ever > 20 then '21+'
  --       else 'No Previous ABs'
  --  end
  -- ,Days_Since_Last_Payment_Dt
  --  = Cast(end_date-Case when day(end_date) < payment_due_day_of_month
  --                         then Cast('' || year(dateadd(month,-1,end_date)) || '-' || month(dateadd(month,-1,end_date)) || '-' || payment_due_day_of_month as date)
  --                       when day(end_date) >= payment_due_day_of_month
  --                         then Cast('' || year(end_date) || '-' || month(end_date) || '-' || payment_due_day_of_month as date)
  --         end as integer)
  update "Forecast_Loop_Table" as "base"
    set "DTV_Last_PC_Future_Sub_Effective_Dt" = null
    where "base"."DTV_Status_Code" <> 'PC';
  update "Forecast_Loop_Table" as "base"
    set "DTV_Last_AB_Future_Sub_Effective_Dt" = null,
    "AB_Days_Since_Last_Payment_Dt" = null
    where "base"."DTV_Status_Code" <> 'AB';
  drop table if exists #Sample_ABs;
  select "MoR"."account_number",
    "MoR"."event_dt",
    "MoR"."event_dt"-"datepart"("weekday","MoR"."event_dt"+2) as "AB_Event_End_Dt",
    "Row_number"() over(partition by "MoR"."account_number" order by "MoR"."event_dt" desc) as "AB_Rnk"
    into #Sample_ABs
    from "Forecast_Loop_Table" as "sample"
      join "CITeam"."PL_Entries_DTV" as "MoR"
      on "MoR"."Account_Number" = "sample"."account_number"
      and "MoR"."event_dt" between "sample"."end_date"-90 and "sample"."end_date"
      and "MoR"."AB_Pending_Termination" > 0
    where "sample"."DTV_Status_Code" = 'AB';
  delete from #Sample_ABs where "AB_Rnk" > 1;
  update "Forecast_Loop_Table" as "sample"
    set "AB_Days_Since_Last_Payment_Dt" = cast("AB_Event_End_Dt"-case when "day"("AB_Event_End_Dt") < "payment_due_day_of_month" then
      cast('' || "year"("dateadd"("month",-1,"AB_Event_End_Dt")) || '-' || "month"("dateadd"("month",-1,"AB_Event_End_Dt")) || '-' || "payment_due_day_of_month" as date)
    when "day"("AB_Event_End_Dt") >= "payment_due_day_of_month" then
      cast('' || "year"("AB_Event_End_Dt") || '-' || "month"("AB_Event_End_Dt") || '-' || "payment_due_day_of_month" as date)
    end as integer) from
    "Forecast_Loop_Table" as "sample"
    join #Sample_ABs as "MoR"
    on "Mor"."Account_Number" = "sample"."account_number"
    where "DTV_Status_Code" = 'AB';
  update "Forecast_Loop_Table" as "a"
    set "subs_week_and_year" = "sc"."subs_week_and_year",
    "subs_week_of_year" = "sc"."subs_week_of_year" from
    "Forecast_Loop_Table" as "a"
    join "Sky_Calendar" as "sc" /*#Loop_*/
    on "sc"."calendar_date" = "a"."end_date"+7;
  update "Forecast_Loop_Table"
    set "rand_action_Cuscan" = "rand"("number"()*"multiplier"+1),
    "rand_action_Syscan" = "rand"("number"()*"multiplier"+726),
    "rand_BBCoE_Call" = "rand"("number"()*"multiplier"+56569),
    "rand_Value_Call" = "rand"("number"()*"multiplier"+56569),
    "rand_TA_Vol" = "rand"("number"()*"multiplier"+2),
    "rand_WC_Vol" = "rand"("number"()*"multiplier"+3),
    "rand_Value_Vol" = "rand"("number"()*"multiplier"+9557656),
    --    ,rand_TA_Save_Vol = rand(number(*)*multiplier+4)
    --    ,rand_WC_Save_Vol = rand(number(*)*multiplier+5)
    "rand_TA_DTV_Offer_Applied" = "rand"("number"()*"multiplier"+6),
    "rand_NonTA_DTV_Offer_Applied" = "rand"("number"()*"multiplier"+7),
    "rand_NonTA_BB_Offer_Applied" = "rand"("number"()*"multiplier"+455445),
    "rand_TA_DTV_PC_Vol" = "rand"("number"()*"multiplier"+8),
    "rand_WC_DTV_PC_Vol" = "rand"("number"()*"multiplier"+9),
    "rand_Other_DTV_PC_Vol" = "rand"("number"()*"multiplier"+10),
    "rand_TP_cond" = "rand"("number"()*"multiplier"+12),
    "rand_cuscan_TP_cond" = "rand"("number"()*"multiplier"+13),
    "rand_Intrawk_DTV_PC" = "rand"("number"()*"multiplier"+2134),
    "rand_DTV_PC_Duration" = "rand"("number"()*"multiplier"+234),
    "rand_DTV_PC_Status_Change" = "rand"("number"()*"multiplier"+8323),
    "rand_New_Off_Dur" = "rand"("number"()*"multiplier"+3043),
    "rand_Intrawk_DTV_AB" = "rand"("number"()*"multiplier"+3383),
    "rand_BB_SysCan" = "rand"("number"()*"multiplier"+3986),
    "rand_BB_Regrade" = "rand"("number"()*"multiplier"+1964),
    "rand_OC_model" = "rand"("number"()*"multiplier"+2424);
  if "Input_Table_Name" = 'CITeam.Cust_Weekly_Base' then
    call "Decisioning_Procs"."Create_Fcast_TA_Hist"('Forecast_Loop_Table');
    call "Decisioning_Procs"."Create_Fcast_PC_Hist"('Forecast_Loop_Table')
  -- Call Decisioning_Procs.Create_Fcast_AB_Hist('Forecast_Loop_Table');
  end if
end
