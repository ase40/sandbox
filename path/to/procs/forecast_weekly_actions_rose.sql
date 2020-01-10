create procedure //drop procedure Decisioning_Procs.Forecast_Weekly_Actions_rose;
"Decisioning_Procs"."Forecast_Weekly_Actions_rose"( 
  in "Counter" integer,
  in "Rate_Multiplier" real,
  in "WebChat_Agents" integer,
  in "Events_Per_Agent" real,
  -- ,IN var_TA_Forecast_Model varchar(100)
  -- ,IN var_Value_Forecast_Model varchar(100)
  in "Forecast_Start_Wk" integer,
  in "sample_pct" decimal(10,8),
  in "Include_YoY_Trends" varchar(3) default 'No',
  in "Include_TA_Propensity_Overlays" varchar(3) default 'Yes',
  in "Include_Offer_Bridging" varchar(3) default 'Yes',
  in "Offer_Autotreatment_Rate_Multiplier" decimal default 1,
  in "Bridging_EOO_Multiplier" decimal default 1 ) 
sql security invoker
begin
  declare "multiplier" bigint;
  declare "multiplier_2" bigint;
  declare "Base_Scale" real;
  declare "Dynamic_SQL" long varchar;
  set "multiplier" = "DATEPART"("millisecond","now"())+1;
  set "multiplier_2" = "DATEPART"("millisecond","now"())+2;
  set temporary option "Query_Temp_Space_Limit" = 0;
  --------------------------------------------------------------------------------------------------------------
  -- Predicted rates -------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------
  -- update the segments
  update "Forecast_Loop_Table" as "flt"
    set "CusCan_Forecast_Segment" = case when "DTV_status_code" in( 'AB','PC' ) then "DTV_status_code" else "csl"."cuscan_forecast_segment" end from
    "Forecast_Loop_Table" as "flt"
    join "Decisioning"."CusCan_Segment_Lookup" as "csl"
    on "csl"."dtv_tenure" = "flt"."DTV_tenure"
    and "csl"."Time_Since_Last_TA_Call" = "flt"."Time_Since_Last_TA_Call"
    and "csl"."Time_To_Offer_End_DTV" = "flt"."Time_To_Offer_End_DTV"
    and "csl"."package_desc" = "flt"."package_desc"
    and "csl"."Country" = "flt"."Country"
    and "csl"."BB_Active" = "flt"."BB_Active"
    and case when "flt"."dtv_tenure" = 'M10' then "flt"."Offer_Length_DTV" else 'Null' end
     = "Coalesce"("csl"."Offer_Length_DTV",'Null')
    where "flt"."DTV_Active" = 1;
  commit work;
  call "Decisioning_Procs"."Forecast_SysCan_Segment"(
  'Forecast_Loop_Table',
  ' ',
  'SysCan_Forecast_Segment',
  'DTV_Status_Code',
  'DTV_ABs_Ever',
  --'Simple_Segment',
  'DTV_Tenure',
  'Days_Since_Last_Payment_Dt',
  'H_Affluence',
  'BB_Active',
  'Package_Desc',
  'Country',
  'Time_Since_Last_AB',
  'Time_To_Offer_End_DTV');
  -- Call Decisioning_Procs.Value_Logit_Regression_Propensity(); -- Value Call propensity
  update "Forecast_Loop_Table" as "a"
    --pred_TA_Call_Cust_rate      = Case when a.DTV_status_code in ('PC','AB') then Coalesce(b.pred_TA_Call_Cust_rate,0) else a.pred_TA_Call_Cust_rate end
    --,
    set "pred_Web_Chat_TA_Cust_rate" = case when "Coalesce"("b"."WebChat_Events_Per_Agent",0) = 0 then 0 else "Coalesce"("b"."pred_Web_Chat_TA_Cust_rate"*"WebChat_Agents"*"Events_Per_Agent"/"b"."WebChat_Events_Per_Agent",0) end,
    "pred_Other_DTV_PC_rate" = "Coalesce"("b"."pred_Other_DTV_PC_rate",0),
    "pred_Other_DTV_SDC_rate" = "Coalesce"("b"."pred_Other_DTV_SDC_rate",0),
    "pred_NonTA_DTV_Offer_and_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_DTV_Offer_and_Contract_Applied_rate",0),
    "pred_NonTA_DTV_Offer_Applied_rate" = "Coalesce"("b"."pred_NonTA_DTV_Offer_Applied_rate",0),
    "pred_NonTA_DTV_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_DTV_Contract_Applied_rate",0),
    "pred_NonTA_BB_Offer_and_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_BB_Offer_and_Contract_Applied_rate",0),
    "pred_NonTA_BB_Offer_Applied_rate" = "Coalesce"("b"."pred_NonTA_BB_Offer_Applied_rate",0),
    "pred_NonTA_BB_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_BB_Contract_Applied_rate",0) from
    "Forecast_Loop_Table" as "a"
    left outer join "Forecast_Loop_Table" as "c"
    on "c"."account_number" = "a"."account_number"
    and "c"."end_date" = "a"."end_date"
    left outer join "cuscan_predicted_values" as "b"
    --(a.subs_week_of_year       = b.subs_week or (a.subs_week_of_year = 53 and b.subs_week = 52)) and
    on "replace"("c"."cuscan_forecast_segment",'_SkyQ','_Original') = "b"."cuscan_forecast_segment"
    and "c"."prem_segment" = "b"."prem_segment"
    where "a"."DTV_Active" = 1;
  update "Forecast_Loop_Table" as "a"
    --pred_TA_Call_Cust_rate      = Case when a.DTV_status_code in ('PC','AB') then Coalesce(b.pred_TA_Call_Cust_rate,0) else a.pred_TA_Call_Cust_rate end
    --,
    set "pred_Web_Chat_TA_Cust_rate" = case when "Coalesce"("b"."WebChat_Events_Per_Agent",0) = 0 then 0 else "Coalesce"("b"."pred_Web_Chat_TA_Cust_rate"*"WebChat_Agents"*"Events_Per_Agent"/"b"."WebChat_Events_Per_Agent",0) end,
    "pred_Other_DTV_PC_rate" = "Coalesce"("b"."pred_Other_DTV_PC_rate",0),
    "pred_Other_DTV_SDC_rate" = "Coalesce"("b"."pred_Other_DTV_SDC_rate",0),
    "pred_NonTA_DTV_Offer_and_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_DTV_Offer_and_Contract_Applied_rate",0),
    "pred_NonTA_DTV_Offer_Applied_rate" = "Coalesce"("b"."pred_NonTA_DTV_Offer_Applied_rate",0),
    "pred_NonTA_DTV_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_DTV_Contract_Applied_rate",0),
    "pred_NonTA_BB_Offer_and_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_BB_Offer_and_Contract_Applied_rate",0),
    "pred_NonTA_BB_Offer_Applied_rate" = "Coalesce"("b"."pred_NonTA_BB_Offer_Applied_rate",0),
    "pred_NonTA_BB_Contract_Applied_rate" = "Coalesce"("b"."pred_NonTA_BB_Contract_Applied_rate",0) from
    "Forecast_Loop_Table" as "a"
    left outer join "Forecast_Loop_Table" as "c"
    on "c"."account_number" = "a"."account_number"
    and "c"."end_date" = "a"."end_date"
    left outer join "cuscan_predicted_values" as "b"
    --(a.subs_week_of_year       = b.subs_week or (a.subs_week_of_year = 53 and b.subs_week = 52)) and
    on "replace"("c"."cuscan_forecast_segment",'_SkyQ','_Original_UK') = "b"."cuscan_forecast_segment"
    and "b"."prem_segment" = "c"."prem_segment"
    where "a"."pred_TA_Call_Cust_rate" = 0
    and "a"."DTV_Active" = 1;
  ------ TA cum ----
  update "Forecast_Loop_Table" as "a"
    set "cum_TA_Call_Cust_rate" = "pred_TA_Call_Cust_rate",
    "cum_TA_Call_Cust_rate_pre_overlay" = "pred_TA_Call_Cust_rate"
    where "DTV_Active" = 1;
  -- cum_TA_Call_Cust_rate update considering TA Initiative Overlay distribution per cuscan_forecast_segment:
  drop table if exists #Segment_Sizes;
  select "subs_week_and_year","cuscan_forecast_segment","sum"("DTV_Active") as "Customers",
    "sum"("Customers") over() as "Total_Customers",
    cast("Customers" as real)/"Total_Customers" as "Segmnt_Pct"
    into #Segment_Sizes
    from "Forecast_Loop_Table"
    group by "subs_week_and_year","cuscan_forecast_segment";
  -- Select * from #Segment_Sizes;
  drop table if exists #Overlays_per_seg_per_week;
  select "base"."Subs_Week_And_Year",
    "base"."cuscan_forecast_segment",
    "sum"(cast("Overlay" as real)*"Coalesce"("Overlay_Dist_perc","base"."Segmnt_Pct")*"sample_pct")*(case when "Include_TA_Propensity_Overlays" = 'No' then 0 else 1 end) as "net_call_effect"
    into #Overlays_per_seg_per_week
    from #Segment_Sizes as "base"
      join "Decisioning"."TA_Initiative_Overlays" as "TAIO"
      on "TAIO"."subs_week_and_year" = "base"."subs_week_and_year"
      and "TAIO"."Effective_From_Wk" <= "Forecast_Start_Wk"
      and "TAIO"."Effective_To_Wk" >= "Forecast_Start_Wk"
      and "TAIO"."Overlay" is not null and "TAIO"."Overlay" <> 0
      and "Latest_Load" = 1
      left outer join "CITeam"."segment_id_lookup" as "SL"
      on "SL"."Segment_Name" = "base"."cuscan_forecast_segment"
      left outer join "Decisioning"."Overlays_Dist_Per_Segment" as "ODPS"
      on "ODPS"."SegmentId" = "SL"."SegmentId"
      and "TAIO"."Reason" = "ODPS"."Reason"
      and "ODPS"."Subs_Year" = "TAIO"."Subs_Year"
      and "ODPS"."Effective_From_Wk" = "TAIO"."Effective_From_Wk"
      and "ODPS"."Effective_To_Wk" = "TAIO"."Effective_To_Wk"
    group by "base"."Subs_Week_And_Year","base"."cuscan_forecast_segment"
    order by "base"."Subs_Week_And_Year" asc,"base"."cuscan_forecast_segment" asc;
  -- Select subs_week_and_year,sum(overlay) Overlay from Decisioning.TA_Initiative_Overlays where 201649 between Effective_From_Wk and Effective_To_Wk and Latest_Load = 1 group by subs_week_and_year
  --once TA_Cust is assigned, how many calls does each segment make on average
  select "Cuscan_Forecast_Segment","sum"(cast("TA_Event_Count" as real)*"TA_Custs")/"sum"("TA_Custs") as "Calls_Per_Caller"
    into #avg_calls_per_segment
    from "TA_Call_Dist"
    group by "Cuscan_Forecast_Segment";
  select "A"."cuscan_forecast_segment","count"() as "segment_base_size"
    into #segment_base_sizes
    from "Forecast_Loop_Table" as "A"
    where "DTV_Active" = 1
    group by "A"."cuscan_forecast_segment";
  update "Forecast_Loop_Table" as "Base"
    set "cum_TA_Call_Cust_rate" = cast("cum_TA_Call_Cust_rate" as real)+cast("overlay"."net_call_effect" as real)
    /("size"."segment_base_size"*"repeat"."Calls_Per_Caller") from
    "Forecast_Loop_Table" as "Base"
    join #segment_base_sizes as "Size"
    on "size"."cuscan_forecast_segment" = "base"."cuscan_forecast_segment"
    join #avg_calls_per_segment as "Repeat"
    on "repeat"."cuscan_forecast_segment" = "base"."cuscan_forecast_segment"
    join #Overlays_per_seg_per_week as "overlay"
    on "overlay"."cuscan_forecast_segment" = "base"."cuscan_forecast_segment"
    and "overlay"."Subs_Week_And_Year" = "base"."Subs_Week_And_Year";
  ------ WC cum-----
  update "Forecast_Loop_Table" as "a"
    set "cum_Web_Chat_TA_Cust_rate" = "cum_TA_Call_Cust_rate"+"pred_Web_Chat_TA_Cust_rate",
    "cum_Web_Chat_TA_Cust_rate_pre_overlay" = "cum_TA_Call_Cust_rate_pre_overlay"+"pred_Web_Chat_TA_Cust_rate"
    where "DTV_Active" = 1;
  -------WC cum ------
  update "Forecast_Loop_Table" as "a"
    set "cum_Web_Chat_TA_Cust_Trend_rate" = "cum_Web_Chat_TA_Cust_rate"+0 --; --pred_Web_Chat_TA_Cust_YoY_Trend
    where "DTV_Active" = 1;
  -- syscan rates -----
  update "Forecast_Loop_Table" as "a"
    set "pred_DTV_AB_rate" = "Coalesce"("c"."pred_DTV_AB_rate",0) from
    "Forecast_Loop_Table" as "a"
    left outer join "syscan_predicted_values" as "c"
    --(a.subs_week_of_year       = c.subs_week or (a.subs_week_of_year = 53 and c.subs_week = 52))
    --and
    on "a"."syscan_forecast_segment" = "c"."syscan_forecast_segment"
    where "DTV_Active" = 1;
  ---- AB cum ------
  update "Forecast_Loop_Table" as "a"
    set "cum_DTV_AB_rate" = "pred_DTV_AB_rate"
    where "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "a"
    set "cum_DTV_AB_trend_rate" = "cum_DTV_AB_rate" --+ pred_dtv_YoY_Trend
    where "DTV_Active" = 1;
  --------------------------------------------------------------------------------------------------------------
  -- TA/WC Volumes, Saves & Offers Applied  --------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------
  -- 3.06 Allocate customers randomly based on rates --
  update "Forecast_Loop_Table" as "a"
    set "TA_Call_Cust" = case when "rand_action_Cuscan" <= "cum_TA_Call_Cust_rate"*"Rate_Multiplier" then /*pct_cuscan_count*/
      1
    else 0
    end,
    "WC_Call_Cust" = case when "rand_action_Cuscan" > "cum_TA_Call_Cust_rate"*"Rate_Multiplier" /*pct_cuscan_count*/
    and "rand_action_Cuscan" <= "cum_Web_Chat_TA_Cust_rate"*"Rate_Multiplier" then /*pct_cuscan_count*/
      1
    else 0
    end,
    "TA_Call_Cust_pre_overlay" = case when "rand_action_Cuscan" <= "cum_TA_Call_Cust_rate_pre_overlay"*"Rate_Multiplier" then /*pct_cuscan_count*/
      1
    else 0
    end,
    "WC_Call_Cust_pre_overlay" = case when "rand_action_Cuscan" > "cum_TA_Call_Cust_rate_pre_overlay"*"Rate_Multiplier" /*pct_cuscan_count*/
    and "rand_action_Cuscan" <= "cum_Web_Chat_TA_Cust_rate_pre_overlay"*"Rate_Multiplier" then /*pct_cuscan_count*/
      1
    else 0
    end
    where "DTV_Active" = 1
    and "TA_Wks_To_Overlay_Nulled" = 0;
  update "Forecast_Loop_Table" as "a"
    set "TA_Wks_To_Overlay_Nulled" = 13
    where "TA_Call_Cust"+"WC_Call_Cust" = 0 and "TA_Call_Cust_pre_overlay"+"WC_Call_Cust_pre_overlay" > 0;
  commit work;
  set "Dynamic_SQL"
     = ' set  TAs_in_next_7d  = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_Event_Count else a.TAs_in_next_7d end '
     || ' ,TA_saves_in_next_7d      = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_Saved_Count else a.TA_saves_in_next_7d end '
    --   || ' ,Offers_Applied_Next_7D_DTV = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_DTV_Offer_Applied else a.Offers_Applied_Next_7D_DTV end '
    --   || ' ,DTV_Contracts_Applied_In_Next_7D = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_DTV_Offer_Applied else a.DTV_Contracts_Applied_In_Next_7D end ' -- All offers come with a contract
     || ' ,Offers_Applied_Next_7D_BB = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_BB_Offer_Applied else a.Offers_Applied_Next_7D_BB end '
     || ' ,BB_Contracts_Applied_In_Next_7D = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_BB_Offer_Applied else a.BB_Contracts_Applied_In_Next_7D end ' -- All offers come with a contract
     || ' ,DTV_PL_Cancels_In_Next_7D = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_DTV_PC else a.DTV_PL_Cancels_In_Next_7D end '
     || ' ,DTV_SDCs_In_Next_7D = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 then b.TA_DTV_SDC else a.DTV_SDCs_In_Next_7D end '
     || ' ,BB_Product_Holding_EoW = Case when TA_Call_Cust > 0 and TAs_in_next_7d = 0 and b.BB_Product_Added is not null then b.BB_Product_Added '
     || '                                    when TA_Call_Cust > 0 and TAs_in_next_7d = 0 and b.BB_Removed > 0 then null '
     || '                               end '
     || ' '
     || '     ,TAs_in_Next_7D_pre_overlay  = Case when TA_Call_Cust_pre_overlay > 0 and TAs_in_Next_7D_pre_overlay = 0 then b.TA_Event_Count else a.TAs_in_Next_7D_pre_overlay end '
     || '     ,TA_Saves_in_Next_7D_pre_overlay      = Case when TA_Call_Cust_pre_overlay > 0 and TAs_in_Next_7D_pre_overlay = 0 then b.TA_Saved_Count else a.TA_Saves_in_Next_7D_pre_overlay end ';
  -- TA
  execute immediate
    'update Forecast_Loop_Table as a '
     || "Dynamic_SQL"
     || ' from Forecast_Loop_Table as a '
     || '     inner join '
     || '      TA_Call_Dist as b '
     || '      on a.cuscan_forecast_segment = b.cuscan_forecast_segment '
     || '         and b.BB_Product_Holding = Coalesce(a.BB_Product_Holding,''Non BB'') '
     || '         and a.rand_TA_Vol between b.TA_Dist_Lower_Pctl and b.TA_Dist_Upper_Pctl '
     || ' where DTV_Active = 1 ';
  execute immediate
    'update Forecast_Loop_Table as a '
     || "Dynamic_SQL"
     || ' from Forecast_Loop_Table as a '
     || ' inner join '
     || ' TA_Call_Dist as b '
     || ' on b.BB_Product_Holding = Coalesce(a.BB_Product_Holding,''Non BB'') '
     || '      and b.cuscan_forecast_segment = ''All'' '
     || '         and a.rand_TA_Vol between b.TA_Dist_Lower_Pctl and b.TA_Dist_Upper_Pctl '
     || ' where DTV_Active = 1 ';
  execute immediate
    'update Forecast_Loop_Table as a '
     || "Dynamic_SQL"
     || ' from Forecast_Loop_Table as a '
     || ' inner join '
     || ' TA_Call_Dist as b '
     || ' on b.cuscan_forecast_segment = a.cuscan_forecast_segment '
     || '         and b.BB_Product_Holding = ''All'' '
     || '         and a.rand_TA_Vol between b.TA_Dist_Lower_Pctl and b.TA_Dist_Upper_Pctl '
     || ' where DTV_Active = 1 ';
  execute immediate
    'update Forecast_Loop_Table as a '
     || "Dynamic_SQL"
     || ' from Forecast_Loop_Table as a '
     || '      inner join '
     || '      TA_Call_Dist as b '
     || '      on b.cuscan_forecast_segment = ''All'' '
     || '         and b.BB_Product_Holding = ''All'' '
     || '         and a.rand_TA_Vol between b.TA_Dist_Lower_Pctl and b.TA_Dist_Upper_Pctl '
     || ' where DTV_Active = 1 ';
  -- WebChat
  update "Forecast_Loop_Table" as "a"
    set "LiveChats_in_Next_7D" = "b"."total_calls",
    "LiveChat_Saves_in_Next_7D" = "b"."TA_Saved" from
    -- select count(*)
    "Forecast_Loop_Table" as "a"
    join "WC_Dist" as "b"
    on "replace"("a"."cuscan_forecast_segment",'_SkyQ','_Original') = "b"."cuscan_forecast_segment"
    and "a"."rand_WC_Vol" between "b"."TA_Lower_Pctl" and "b"."TA_Upper_Pctl"
    where "WC_Call_Cust" > 0
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "a"
    set "LiveChats_in_Next_7D" = "b"."total_calls",
    "LiveChat_Saves_in_Next_7D" = "b"."TA_Saved" from
    -- select count(*)
    "Forecast_Loop_Table" as "a"
    join "WC_Dist" as "b"
    on "replace"("a"."cuscan_forecast_segment",'_SkyQ','_Original_UK') = "b"."cuscan_forecast_segment"
    and "a"."rand_WC_Vol" between "b"."TA_Lower_Pctl" and "b"."TA_Upper_Pctl"
    where "WC_Call_Cust" > 0
    and "LiveChats_in_Next_7D" = 0
    and "DTV_Active" = 1;
  -- WebChat pre overlay calculations: OC added
  update "Forecast_Loop_Table" as "a"
    set "LiveChats_in_Next_7D_pre_overlay" = "b"."total_calls",
    "LiveChat_Saves_in_Next_7D_pre_overlay" = "b"."TA_Saved" from
    -- select count(*)
    "Forecast_Loop_Table" as "a"
    join "WC_Dist" as "b"
    on "replace"("a"."cuscan_forecast_segment",'_SkyQ','_Original') = "b"."cuscan_forecast_segment"
    and "a"."rand_WC_Vol" between "b"."TA_Lower_Pctl" and "b"."TA_Upper_Pctl"
    where "WC_Call_Cust_pre_overlay" > 0
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "a"
    set "LiveChats_in_Next_7D_pre_overlay" = "b"."total_calls",
    "LiveChat_Saves_in_Next_7D_pre_overlay" = "b"."TA_Saved" from
    -- select count(*)
    "Forecast_Loop_Table" as "a"
    join "WC_Dist" as "b"
    on "replace"("a"."cuscan_forecast_segment",'_SkyQ','_Original_UK') = "b"."cuscan_forecast_segment"
    and "a"."rand_WC_Vol" between "b"."TA_Lower_Pctl" and "b"."TA_Upper_Pctl"
    where "WC_Call_Cust_pre_overlay" > 0
    and "LiveChats_in_Next_7D_pre_overlay" = 0
    and "DTV_Active" = 1;
  --------------------------------------------------------------------------------------------------------------
  -- Value Calls -----------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------
  update "Forecast_Loop_Table" as "a"
    set "Value_Call_Cust" = 1
    where "rand_Value_Call" <= "pred_Value_Call_Cust_rate";
  update "Forecast_Loop_Table" as "a"
    set "Value_Calls_In_Next_7D" = "val"."Value_Call_Count" from
    "Forecast_Loop_Table" as "a"
    left outer join "Value_Call_Dist" as "val"
    on "val"."cuscan_forecast_segment" = "a"."cuscan_forecast_segment"
    and "rand_Value_Vol" between "Value_Dist_Lower_Pctl" and "Value_Dist_Upper_Pctl"
    where "a"."Value_Call_Cust" = 1;
  /*
Alter table FORECAST_Looped_Sim_Output_Platform
Add(rand_Value_Vol float default null);


Update FORECAST_Looped_Sim_Output_Platform
Set rand_Value_Vol = rand(number(*)*9557656)
*/
  create or replace variable "x" real;
  set "x" = .1;
  drop table if exists "offer_contract_rose2";
  select "Account_Number","ta_flag","Value_Call_Cust_flag","ISNULL"("P_target011",0)+"ISNULL"("P_target111",0)+"ISNULL"("P_target101",0)+"ISNULL"("P_target001",0) as "P_Rose",
    "ISNULL"("P_target010",0)+"ISNULL"("P_target110",0)+"ISNULL"("P_target100",0)+"ISNULL"("P_target000",0) as "P_NotRose",
    "ISNULL"("P_target011",0)+"ISNULL"("P_target111",0)+"ISNULL"("P_target101",0)+"ISNULL"("P_target001",0)+"ISNULL"("P_target010",0)+"ISNULL"("P_target110",0)+"ISNULL"("P_target100",0)+"ISNULL"("P_target000",0) as "P_Total",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then "P_target010"*((("P_Rose"*(1-"x")/"P_NotRose"))+1) else "P_target010" end as "P_target010_n",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then "P_target110"*((("P_Rose"*(1-"x")/"P_NotRose"))+1) else "P_target110" end as "P_target110_n",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then "P_target100"*((("P_Rose"*(1-"x")/"P_NotRose"))+1) else "P_target100" end as "P_target100_n",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then "P_target000"*((("P_Rose"*(1-"x")/"P_NotRose"))+1) else "P_target000" end as "P_target000_n",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then("P_target011"*"x") else "P_target011" end as "P_target011_n",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then("P_target111"*"x") else "P_target111" end as "P_target111_n",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then("P_target101"*"x") else "P_target101" end as "P_target101_n",
    case when "DTV_Product_Holding" = 'Sky Entertainment' and "P_Total" <> 0 then("P_target001"*"x") else "P_target001" end as "P_target001_n"
    into "offer_contract_rose2"
    from(select "a".*,"DTV_Product_Holding"
        from "offer_contract_rose" as "a"
          left outer join(select "account_number","DTV_Product_Holding","New_DTV_Customer"
            from "Forecast_Loop_Table") as "b" on "a"."account_number" = "b"."account_number") as "a";
  alter table "offer_contract_rose2" delete
    "P_Rose";
  alter table "offer_contract_rose2" delete
    "P_NotRose";
  alter table "offer_contract_rose2" delete
    "P_Total";
  alter table "offer_contract_rose2" rename "P_target010_n" to "P_target010";
  alter table "offer_contract_rose2" rename "P_target110_n" to "P_target110";
  alter table "offer_contract_rose2" rename "P_target100_n" to "P_target100";
  alter table "offer_contract_rose2" rename "P_target000_n" to "P_target000";
  alter table "offer_contract_rose2" rename "P_target011_n" to "P_target011";
  alter table "offer_contract_rose2" rename "P_target111_n" to "P_target111";
  alter table "offer_contract_rose2" rename "P_target101_n" to "P_target101";
  alter table "offer_contract_rose2" rename "P_target001_n" to "P_target001";
  -- Merge from OC table
  set "Dynamic_SQL"
     = ' set '
     || ' P_target000  = b.P_target000 '
     || ' ,P_target010      = b.P_target010  '
     || ' ,P_target100 = b.P_target100  '
     || ' ,P_target110 = b.P_target110  '
     || ' ,P_target001  = b.P_target001 '
     || ' ,P_target011      = b.P_target011  '
     || ' ,P_target101 = b.P_target101  '
     || ' ,P_target111 = b.P_target111  ';
  -- TA
  execute immediate
    'update Forecast_Loop_Table as a '
     || "Dynamic_SQL"
     || ' from Forecast_Loop_Table as a '
     || '     inner join '
     || '      offer_contract_rose2 as b '
     || '      on a.account_number = b.account_number '
     || '         and a.TA_Call_Cust = b.ta_flag '
     || '         and a.Value_Call_Cust = b.Value_Call_Cust_flag ';
  update "Forecast_Loop_Table"
    set "OC_model_out"
     = (case when "rand_OC_model" > 0 and "rand_OC_model" <= "P_target000" then '000'
    when "rand_OC_model" > "P_target000" and "rand_OC_model" <= ("P_target000"+"P_target010") then '010'
    when "rand_OC_model" > ("P_target000"+"P_target010") and "rand_OC_model" <= ("P_target000"+"P_target010"+"P_target100") then '100'
    when "rand_OC_model" > ("P_target000"+"P_target010"+"P_target100") and "rand_OC_model" <= ("P_target000"+"P_target010"+"P_target100"+"P_target110") then '110'
    when "rand_OC_model" > ("P_target000"+"P_target010"+"P_target100"+"P_target110") and "rand_OC_model" <= ("P_target000"+"P_target010"+"P_target100"+"P_target110"+"P_target001") then '001'
    when "rand_OC_model" > ("P_target000"+"P_target010"+"P_target100"+"P_target110"+"P_target001") and "rand_OC_model" <= ("P_target000"+"P_target010"+"P_target100"+"P_target110"+"P_target001"+"P_target011") then '011'
    when "rand_OC_model" > ("P_target000"+"P_target010"+"P_target100"+"P_target110"+"P_target001"+"P_target011") and "rand_OC_model" <= ("P_target000"+"P_target010"+"P_target100"+"P_target110"+"P_target001"+"P_target011"+"P_target101") then '101'
    when "rand_OC_model" > ("P_target000"+"P_target010"+"P_target100"+"P_target110"+"P_target001"+"P_target011"+"P_target101") and "rand_OC_model" < 1 then '111' end)
    where "DTV_Active" = 1;
  update "Forecast_Loop_Table"
    set "Offers_Applied_Next_7D_DTV" = case when "OC_model_out" in( '100','110','101','111' ) then 1 else 0 end;
  update "Forecast_Loop_Table"
    set "DTV_Contracts_Applied_In_Next_7D" = case when "OC_model_out" in( '010','110','011','111' ) then 1 else 0 end;
  update "Forecast_Loop_Table"
    set "Rose_migration_in_next_7d" = case when "OC_model_out" in( '011','111','101','001' ) then 1 else 0 end,
    "DTV_Product_Holding_EoW" = 'Sky Entertainment';
  --------------------------------------------------------------------------------------------------------------
  -- Pending Cancels -------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------
  --- pred DTV_PC ----
  update "Forecast_Loop_Table" as "a"
    set "pred_WC_DTV_PC_rate" = "b"."WC_DTV_PC_Conv_Rate", -- - Coalesce(seasonality.TA_Save_Rate_Change,0) - Coalesce(intiative.TA_Save_Rate_Change,0)
    "pred_WC_DTV_SDC_rate" = "b"."WC_DTV_SDC_Conv_Rate" from -- - Coalesce(seasonality.TA_Save_Rate_Change,0) - Coalesce(intiative.TA_Save_Rate_Change,0)
    "Forecast_Loop_Table" as "a"
    join "TA_DTV_PC_Vol" as "b"
    on "a"."cuscan_forecast_segment" = "b"."cuscan_forecast_segment"
    left outer join "Decisioning"."TA_save_rate_seasonality" as "seasonality"
    on "remainder"("a"."subs_week_and_year",100) = "seasonality"."Subs_Week"
    where "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "a"
    set "pred_PC_TP_EnterCusCan_Conv_rate" = "b"."Raw_PC_TP_Enter_CusCan_Conv_Rate",
    "pred_PC_TP_Enter3rdParty_Conv_rate" = "b"."Raw_PC_TP_Enter_3rdParty_Conv_Rate",
    "pred_SDC_TP_EnterCusCan_Conv_rate" = "b"."Raw_SDC_TP_Enter_CusCan_Conv_Rate",
    "pred_SDC_TP_Enter3rdParty_Conv_rate" = "b"."Raw_SDC_TP_Enter_3rdParty_Conv_Rate" from
    "Forecast_Loop_Table" as "a"
    join "DTV_PC_TP_PC_Conv" as "b"
    on "a"."cuscan_forecast_segment" = "b"."cuscan_forecast_segment"
    where "DTV_Active" = 1;
  drop table if exists #WC_PC_Pctl;
  select "cuscan_forecast_segment","account_number","TA_Call_Cust","WC_Call_Cust","TA_saves_in_next_7d","LiveChat_saves_in_next_7d","Offers_Applied_Next_7D_DTV",
    "Row_number"() over(partition by "cuscan_forecast_segment" order by "TA_saves_in_next_7d" asc,"LiveChat_saves_in_next_7d" asc,"Offers_Applied_Next_7D_DTV" asc) as "Segment_Rnk",
    "Count"() over(partition by "cuscan_forecast_segment") as "Total_Accs",
    cast("Segment_Rnk" as real)/"Total_Accs" as "CusCan_Segment_Pctl"
    into #WC_PC_Pctl
    from "Forecast_Loop_Table"
    where "WC_Call_Cust" > 0 and "DTV_Status_Code" not in( 'AB','PC' ) ;
  update "Forecast_Loop_Table" as "a"
    set "DTV_PL_Cancels_In_Next_7D" = case when "rand_WC_DTV_PC_Vol" <= "pred_WC_DTV_PC_rate" and "a"."WC_Call_Cust" > 0 then
      1
    else "DTV_PL_Cancels_In_Next_7D"
    end,
    "DTV_SDCs_In_Next_7D" = case when "pred_WC_DTV_PC_rate" < "rand_WC_DTV_PC_Vol" and "rand_WC_DTV_PC_Vol" <= "pred_WC_DTV_PC_rate"+"pred_WC_DTV_SDC_rate"
    and "a"."WC_Call_Cust" > 0 then
      1
    else "DTV_PL_Cancels_In_Next_7D"
    end from
    "Forecast_Loop_Table" as "a"
    join #WC_PC_Pctl as "pc"
    on "pc"."account_number" = "a"."account_number"
    where "DTV_Active" = 1;
  -- Other Non-TA/LiveChat PCs
  set "Base_Scale"
     = cast((select "count"() from "Forecast_Loop_Table" where "DTV_Active" = 1) as real)
    /(select "count"() from "Forecast_Loop_Table" where "TA_Call_Cust" = 0 and "WC_Call_Cust" = 0 and "DTV_Active" = 1);
  -- Select Base_Scale
  update "Forecast_Loop_Table" as "a"
    set "DTV_PL_Cancels_In_Next_7D" = 1,
    "DTV_Status_Code_EoW" = 'PC'
    where "a"."TA_Call_Cust" = 0 and "a"."WC_Call_Cust" = 0 and "a"."Offers_Applied_Next_7D_DTV" = 0
    and "rand_Other_DTV_PC_Vol" <= "pred_Other_DTV_PC_rate"*"Base_Scale"
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "a"
    set "DTV_SDCs_In_Next_7D" = 1,
    "DTV_Status_Code_EoW" = 'PO'
    where "a"."TA_Call_Cust" = 0 and "a"."WC_Call_Cust" = 0
    and "pred_Other_DTV_PC_rate"*"Base_Scale" < "rand_Other_DTV_PC_Vol" and "rand_Other_DTV_PC_Vol" <= ("pred_Other_DTV_PC_rate"+"pred_Other_DTV_SDC_rate")*"Base_Scale"
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table"
    set "rand_action_Syscan" = case when "TA_Call_Cust"+"WC_Call_Cust" > 0 then 1
    else null
    end
    where "DTV_Active" = 1;
  update "Forecast_Loop_Table"
    set "rand_action_Syscan" = "rand"("number"()*"multiplier"+4)
    where "rand_action_Syscan" is null
    and "DTV_Active" = 1;
  select "Syscan_Forecast_segment","sum"("DTV_Active") as "Syscan_segment_count"
    into #SysCan_Seg
    from "Forecast_Loop_Table"
    where "DTV_Active" = 1
    group by "Syscan_Forecast_segment";
  commit work;
  create hg index "idx_1" on #SysCan_Seg("Syscan_Forecast_segment");
  -- the low ranking customers will be the ones with no TA / WC
  drop table if exists #SysCan_Rank;
  select "account_number",
    "rand_action_Syscan",
    "sum"("TA_Call_Cust"+"WC_Call_Cust") over(partition by "flt"."Syscan_Forecast_segment") as "SysCan_Seg_CusCan_Actions",
    "count"() over(partition by "flt"."Syscan_Forecast_segment") as "Total_Cust_In_SysCan_Segment",
    cast("rank"() over(partition by "flt"."Syscan_Forecast_segment" order by "rand_action_Syscan" asc) as real) as "SysCan_Group_rank",
    cast("rank"() over(partition by "flt"."Syscan_Forecast_segment" order by "rand_action_Syscan" asc) as real)/cast("sys"."Syscan_segment_count" as real) as "pct_syscan_count",
    case when "Total_Cust_In_SysCan_Segment"-"SysCan_Seg_CusCan_Actions" > 0 then
      case when "TA_Call_Cust"+"WC_Call_Cust" = 0
      and "rand_action_Syscan" <= "pred_dtv_AB_rate"*"Total_Cust_In_SysCan_Segment"/("Total_Cust_In_SysCan_Segment"-"SysCan_Seg_CusCan_Actions") then
        1
      else 0
      end
    else 0
    end as "DTV_AB"
    into #SysCan_Rank
    from "Forecast_Loop_Table" as "flt"
      left outer join #SysCan_Seg as "sys"
      on "flt"."Syscan_Forecast_segment" = "sys"."Syscan_Forecast_segment"
    where "DTV_Active" = 1;
  commit work;
  create hg index "idx_1" on #SysCan_Rank("account_number");
  create lf index "idx_2" on #SysCan_Rank("DTV_AB");
  update "Forecast_Loop_Table" as "a"
    set "DTV_ABs_In_Next_7D" = 1 from
    "Forecast_Loop_Table" as "a"
    join #SysCan_Rank as "b"
    on "b"."account_number" = "a"."account_number"
    and "b"."DTV_AB" = 1
    where "DTV_Active" = 1;
  --------------------------------------------------------------------------------------------------------------
  -- End of Week Statuses --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------------------
  update "Forecast_Loop_Table" as "base"
    set "DTV_Status_Code_EoW" = 'PO',
    "DTV_SameDayCancels_In_Next_7D" = 1
    where "DTV_SDCs_In_Next_7D" > 0;
  update "Forecast_Loop_Table" as "base"
    set "DTV_Status_Code_EoW" = "AB"."DTV_Next_Status_Code",
    "Offers_Applied_Next_7D_DTV" = "AB"."AB_ReAC_Offer_Applied",
    "DTV_Contracts_Applied_In_Next_7D" = "AB"."AB_ReAC_Offer_Applied", -- All offers come with contract
    "AB_Days_Since_Last_Payment_Dt" = case when "DTV_Status_Code_EoW" = 'AB' then "base"."Days_Since_Last_Payment_Dt" end,
    "BB_Enter_SysCan" = "AB"."BB_Enter_SysCan",
    "BB_Status_Code_EoW" = "AB"."BB_Status_Code_EoW" from
    "Forecast_Loop_Table" as "base"
    join "IntraWk_AB_Pct" as "AB"
    on "AB"."Days_Since_Last_Payment" = "base"."Days_Since_Last_Payment_Dt"
    and "AB"."BB_Active" = "Base"."BB_Active"
    and "base"."rand_Intrawk_DTV_AB" between "AB"."IntaWk_AB_Lower_Pctl" and "AB"."IntaWk_AB_Upper_Pctl"
    where "DTV_ABs_In_Next_7D" > 0
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "DTV_Status_Code_EoW" = "PC"."Next_Status_Code",
    "Offers_Applied_Next_7D_DTV" = "PC"."PC_ReAC_Offer_Applied",
    "DTV_Contracts_Applied_In_Next_7D" = "PC"."PC_ReAC_Offer_Applied" from -- All offers come with contract
    "Forecast_Loop_Table" as "base"
    join "IntraWk_PC_Pct" as "PC"
    on "base"."rand_Intrawk_DTV_PC" between "PC"."IntaWk_PC_Lower_Pctl" and "PC"."IntaWk_PC_Upper_Pctl"
    where "DTV_PL_Cancels_In_Next_7D" > 0
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "DTV_Status_Code_EoW" = 'AB',
    "Offers_Applied_Next_7D_DTV" = 0 from
    "Forecast_Loop_Table" as "base"
    join "PC_AB_Rates" as "PC"
    on "PC"."Days_Since_Last_Payment" = "base"."Days_Since_Last_Payment_Dt"
    and "base"."rand_DTV_PC_Status_Change" < "PC"."PC_AB_Rate"
    and case when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 0 then 'Churn in next 1 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 1 then 'Churn in next 2 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 2 then 'Churn in next 3 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 3 then 'Churn in next 4 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 4 then 'Churn in next 5 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 >= 5 then 'Churn in next 6+ wks' end
    --           when (cast(PC_Future_Sub_Effective_Dt as integer) - cast(End_Date as integer))/7>5 then '6+_Wks_To_Churn'
     = "PC"."Wks_To_Intended_Churn"
    where "DTV_Status_Code" = 'PC'
    and("DTV_PL_Cancels_In_Next_7D" = 0 and "DTV_SDCs_In_Next_7D" = 0)
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "DTV_Status_Code_EoW" = "PC"."Status_Code_EoW",
    "Offers_Applied_Next_7D_DTV" = "PC"."PC_ReAC_Offer_Applied" from
    "Forecast_Loop_Table" as "base"
    join "PC_PL_Status_Change_Dist" as "PC"
    on "base"."rand_DTV_PC_Status_Change" between "PC"."PC_Percentile_Lower_Bound" and "PC"."PC_Percentile_Upper_Bound"
    and case when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 0 then 'Churn in next 1 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 1 then 'Churn in next 2 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 2 then 'Churn in next 3 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 3 then 'Churn in next 4 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 4 then 'Churn in next 5 wks'
    when(cast("base"."DTV_Last_PC_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 >= 5 then 'Churn in next 6+ wks' end
    --           when (cast(PC_Future_Sub_Effective_Dt as integer) - cast(End_Date as integer))/7>5 then '6+_Wks_To_Churn'
     = "PC"."Wks_To_Intended_Churn"
    and "pc"."Time_To_Offer_End_DTV" = "base"."Time_To_Offer_End_DTV"
    where "DTV_Status_Code" = 'PC' and "Coalesce"("DTV_Status_Code_EoW",'Null') <> 'AB'
    and("DTV_PL_Cancels_In_Next_7D" = 0 and "DTV_SDCs_In_Next_7D" = 0)
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "DTV_Status_Code_EoW" = "AB"."Status_Code_EoW",
    "Offers_Applied_Next_7D_DTV" = "AB"."AB_ReAC_Offer_Applied_EoW",
    "BB_Enter_SysCan" = "AB"."BB_Enter_SysCan",
    "BB_Status_Code_EoW" = "AB"."BB_Status_Code_EoW" from
    "Forecast_Loop_Table" as "base"
    join "AB_PL_Status_Change_Dist" as "AB"
    on "AB"."Days_Since_Last_Payment" = "base"."Days_Since_Last_Payment_Dt"
    and "base"."BB_Active" = "AB"."BB_Active"
    and "Coalesce"("base"."BB_Status_Code",'XB') = "AB"."BB_Status_Code"
    and "base"."rand_DTV_PC_Status_Change" between "AB"."AB_Percentile_Lower_Bound" and "AB"."AB_Percentile_Upper_Bound"
    and case when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 0 then 'Churn in next 1 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 1 then 'Churn in next 2 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 2 then 'Churn in next 3 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 3 then 'Churn in next 4 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 4 then 'Churn in next 4 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 5 then 'Churn in next 6 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 6 then 'Churn in next 7 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 7 then 'Churn in next 8 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 = 8 then 'Churn in next 9 wks'
    when(cast("base"."DTV_Last_AB_Future_Sub_Effective_Dt" as integer)-cast("base"."End_Date" as integer))/7 >= 9 then 'Churn in next 10+ wks' end
    --           when (cast(PC_Future_Sub_Effective_Dt as integer) - cast(End_Date as integer))/7>5 then '6+_Wks_To_Churn'
     = "AB"."Wks_To_Intended_Churn"
    where "DTV_Status_Code" = 'AB' and "DTV_ABs_In_Next_7D" = 0
    and "DTV_Active" = 1;
  select "CusCan_Forecast_Segment",cast("sum"("BB_Active") as real)/"Count"() as "BB_Att_Rate"
    into #BB_Att_Rates
    from "Forecast_Loop_Table"
    where "DTV_Active" = 1
    group by "CusCan_Forecast_Segment";
  --
  -- Select * from #BB_Att_Rates
  update "Forecast_Loop_Table" as "base"
    set "TP_Enter_CusCan" = case when "rand_TP_cond" <= "pred_PC_TP_EnterCusCan_Conv_rate"/"bba"."BB_Att_Rate" then 1 else 0 end,
    "TP_Enter_3rdParty" = case when "pred_PC_TP_EnterCusCan_Conv_rate"/"bba"."BB_Att_Rate" < "rand_TP_cond" and "rand_TP_cond" <= "pred_PC_TP_EnterCusCan_Conv_rate"/"bba"."BB_Att_Rate"+"pred_PC_TP_Enter3rdParty_Conv_rate"/"bba"."BB_Att_Rate" then 1 else 0 end from
    #BB_Att_Rates as "bba"
    where "BB_Active" = 1 and("DTV_PL_Cancels_In_Next_7D" > 0
    or "DTV_SDCs_In_Next_7D" > 0)
    and "bba"."cuscan_forecast_segment" = "base"."cuscan_forecast_segment"
    and "BB_Att_Rate" > 0
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "TP_Enter_CusCan" = case when "rand_TP_cond" <= "pred_SDC_TP_EnterCusCan_Conv_rate"/"bba"."BB_Att_Rate" then 1 else 0 end,
    "TP_Enter_3rdParty" = case when "pred_SDC_TP_EnterCusCan_Conv_rate"/"bba"."BB_Att_Rate" < "rand_TP_cond" and "rand_TP_cond" <= "pred_SDC_TP_EnterCusCan_Conv_rate"/"bba"."BB_Att_Rate"+"pred_SDC_TP_Enter3rdParty_Conv_rate"/"bba"."BB_Att_Rate" then 1 else 0 end from
    #BB_Att_Rates as "bba"
    where "BB_Active" = 1 and("DTV_SDCs_In_Next_7D" > 0) /*TA_DTV_SDC > 0 or WC_DTV_SDC > 0 or Other_DTV_SDC > 0*/
    and "bba"."cuscan_forecast_segment" = "base"."cuscan_forecast_segment"
    and "BB_Att_Rate" > 0
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "BB_Status_Code_EoW" = 'PC'
    where("TP_Enter_CusCan" > 0 or "TP_Enter_3rdParty" > 0)
    and "BB_Active" = 1 and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "DTV_PO_Cancellations_In_Next_7D" = 1,
    "BB_Status_Code_EoW" = case when "BB_Status_Code" = 'PC' then 'CN' else "BB_Status_Code" end,
    "BB_Churn" = case when "BB_Status_Code" = 'PC' then 1 else 0 end
    where "DTV_Status_Code_EoW" = 'PO'
    and "DTV_SameDayCancels_In_Next_7D" = 0
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "DTV_SysCan_Churns_In_Next_7D" = 1
    where "DTV_Status_Code_EoW" = 'SC'
    and "DTV_Active" = 1;
  update "Forecast_Loop_Table" as "base"
    set "BB_SysCan_PL_Next_Status" = "BB"."BB_Next_Status_Code",
    "BB_SysCan_PL_Next_Status_Dt" = "Base"."End_Date"+7+"BB"."Days_To_BB_Next_Status" from
    "BB_TP_SysCan_Dist" as "BB"
    where "base"."rand_BB_SysCan" between "BB"."Act_Pctl_Lower_Bnd" and "BB"."Act_Pctl_Upper_Bnd"
    and "Base"."DTV_SysCan_Churns_In_Next_7D" = 1
    and "Base"."BB_Status_Code" in( 'AB','BCRQ' ) ;
  update "Forecast_Loop_Table"
    set "BB_Status_Code_EoW" = "BB_SysCan_PL_Next_Status"
    where "end_date"+7 >= "BB_SysCan_PL_Next_Status_Dt"
    and "BB_Status_Code" in( 'AB','BCRQ' ) ;
  update "Forecast_Loop_Table" as "base"
    set "BB_Churn" = 1
    where "BB_Status_Code_EoW" = 'CN'
    and "BB_Active" = 1;
  -----------------------------------------------------------------------------------------
  -- Other Offers (Offer Bridging Overlay)
  -----------------------------------------------------------------------------------------
  -- Set Total offers applied prior to overlays
  update "Forecast_Loop_Table" as "a"
    set "DTV_Offer_Applied_pre_overlay" = "Offers_Applied_Next_7D_DTV",
    "BB_Offer_Applied_pre_overlay" = "Offers_Applied_Next_7D_BB"
    where "DTV_Active" = 1;
  -- Add non TA offers prior to overlay
  update "Forecast_Loop_Table" as "a"
    --DTV_Offer_Applied_pre_overlay =
    --    set "Offers_Applied_Next_7D_DTV"
    --     = case when "DTV_Active" = 1 then
    --      case when "rand_NonTA_DTV_Offer_Applied"
    --      between 0 and "pred_NonTA_DTV_Offer_and_Contract_Applied_rate" then
    -- 1
    --      when "rand_NonTA_DTV_Offer_Applied"
    --      between "pred_NonTA_DTV_Offer_and_Contract_Applied_rate" and "pred_NonTA_DTV_Offer_and_Contract_Applied_rate"+"pred_NonTA_DTV_Contract_Applied_rate" then
    -- 0
    --      when "rand_NonTA_DTV_Offer_Applied"
    --      between "pred_NonTA_DTV_Offer_and_Contract_Applied_rate"+"pred_NonTA_DTV_Contract_Applied_rate"
    --      and "pred_NonTA_DTV_Offer_and_Contract_Applied_rate"+"pred_NonTA_DTV_Contract_Applied_rate"+"pred_NonTA_DTV_Offer_Applied_rate" then
    -- 1
    --      else 0
    --      end
    --    else 0
    --    end,
    --    "DTV_Contracts_Applied_In_Next_7D"
    --     = case when "DTV_Active" = 1 then
    --      case when "rand_NonTA_DTV_Offer_Applied"
    --      between 0 and "pred_NonTA_DTV_Offer_and_Contract_Applied_rate" then
    -- 1
    --      when "rand_NonTA_DTV_Offer_Applied"
    --      between "pred_NonTA_DTV_Offer_and_Contract_Applied_rate" and "pred_NonTA_DTV_Offer_and_Contract_Applied_rate"+"pred_NonTA_DTV_Contract_Applied_rate" then
    -- 1
    --      when "rand_NonTA_DTV_Offer_Applied"
    --      between "pred_NonTA_DTV_Offer_and_Contract_Applied_rate"+"pred_NonTA_DTV_Contract_Applied_rate"
    --      and "pred_NonTA_DTV_Offer_and_Contract_Applied_rate"+"pred_NonTA_DTV_Contract_Applied_rate"+"pred_NonTA_DTV_Offer_Applied_rate" then
    -- 0
    --      else 0
    --      end
    --    else 0
    --    end,
    set "Offers_Applied_Next_7D_BB"
     = case when "DTV_Active" = 1 and "BB_Active" = 1 then
      case when "rand_NonTA_BB_Offer_Applied"
      between 0 and "pred_NonTA_BB_Offer_and_Contract_Applied_rate" then
        1
      when "rand_NonTA_BB_Offer_Applied"
      between "pred_NonTA_BB_Offer_and_Contract_Applied_rate" and "pred_NonTA_BB_Offer_and_Contract_Applied_rate"+"pred_NonTA_BB_Contract_Applied_rate" then
        0
      when "rand_NonTA_BB_Offer_Applied"
      between "pred_NonTA_BB_Offer_and_Contract_Applied_rate"+"pred_NonTA_BB_Contract_Applied_rate"
      and "pred_NonTA_BB_Offer_and_Contract_Applied_rate"+"pred_NonTA_BB_Contract_Applied_rate"+"pred_NonTA_BB_Offer_Applied_rate" then
        1
      else 0
      end
    else 0
    end,
    "BB_Contracts_Applied_In_Next_7D"
     = case when "DTV_Active" = 1 and "BB_Active" = 1 then
      case when "rand_NonTA_BB_Offer_Applied"
      between 0 and "pred_NonTA_BB_Offer_and_Contract_Applied_rate" then
        1
      when "rand_NonTA_BB_Offer_Applied"
      between "pred_NonTA_BB_Offer_and_Contract_Applied_rate" and "pred_NonTA_BB_Offer_and_Contract_Applied_rate"+"pred_NonTA_BB_Contract_Applied_rate" then
        1
      when "rand_NonTA_BB_Offer_Applied"
      between "pred_NonTA_BB_Offer_and_Contract_Applied_rate"+"pred_NonTA_BB_Contract_Applied_rate"
      and "pred_NonTA_BB_Offer_and_Contract_Applied_rate"+"pred_NonTA_BB_Contract_Applied_rate"+"pred_NonTA_BB_Offer_Applied_rate" then
        0
      else 0
      end
    else 0
    end
    where "DTV_Active" = 1
    and(case when "DTV_Status_Code" in( 'AB','PC' ) 
    or "DTV_ABs_In_Next_7D"+"DTV_PL_Cancels_In_Next_7D"+"DTV_SDCs_In_Next_7D" > 0
    or "TA_Call_Cust" > 0
    or "WC_Call_Cust" > 0 then
      1
    else 0
    end) = 0;
  --------------------------------------------------------------------------------- Offer bridging fix
  -- Create multiple for each segments based on (customers in segment)/(customers eligible for bridging)
  drop table if exists #Offer_Bridging_Ratio;
  select "subs_week_and_year","cuscan_forecast_segment",
    "Count"() as "Base",
    "Sum"(case when("Curr_Offer_Intended_end_Dt_DTV"-"end_date" between 9*7 and 9*7+6
    or "Curr_Offer_Intended_end_Dt_BB"-"end_date" between 9*7 and 9*7+6) then
      1 else 0 end) as "End_Of_Offer",
    "Sum"(case when("Curr_Offer_Intended_end_Dt_DTV"-"end_date" between 9*7 and 9*7+6
    or "Curr_Offer_Intended_end_Dt_BB"-"end_date" between 9*7 and 9*7+6)
    and "Offers_Applied_Next_7D_DTV" = 0
    and "Offers_Applied_Next_7D_BB" = 0
    and(case when "DTV_Status_Code" in( 'AB','PC' ) 
    or "DTV_ABs_In_Next_7D"+"DTV_PL_Cancels_In_Next_7D"+"DTV_SDCs_In_Next_7D" > 0 then
      --                                     or TA_Call_Cust > 0
      --                                     or WC_Call_Cust > 0
      1
    else 0
    end) = 0 then
      1
    else 0
    end) as "Offer_Bridging_Headroom",
    case when "Offer_Bridging_Headroom" = 0 then 0
    else cast("End_Of_Offer" as real)/"Offer_Bridging_Headroom"
    end as "Headroom_Multiplier"
    into #Offer_Bridging_Ratio
    from "Forecast_Loop_Table"
    where "DTV_Active" = 1
    group by "subs_week_and_year","cuscan_forecast_segment";
  commit work;
  create hg index "idx_1" on #Offer_Bridging_Ratio("cuscan_forecast_segment");
  -- Select top 1000 * from #Offer_Bridging_Ratio
  update "Forecast_Loop_Table" as "a"
    set "pred_Offer_Bridging_rate"
     = "Coalesce"("EOO"."Treatment_Rate"*"c"."Headroom_Multiplier"*"Offer_Autotreatment_Rate_Multiplier"*.835654596*"Bridging_EOO_Multiplier"
    *case when "Include_Offer_Bridging" = 'Yes' then 1 else 0 end,0) from
    "Forecast_Loop_Table" as "A"
    join #Offer_Bridging_Ratio as "c"
    on "c"."cuscan_forecast_segment" = "a"."cuscan_forecast_segment"
    join "gma80"."Offer_bridging_EOO_treatment_rates_0910" as "EOO"
    on "EOO"."CusCan_Forecast_Segment" = "A"."CusCan_Forecast_Segment"
    and "A"."subs_week_and_year" between "EOO"."Effective_From_Wk" and "EOO"."Effective_To_Wk"
    where("Curr_Offer_Intended_end_Dt_DTV"-"end_date" between 9*7 and 9*7+6
    or "Curr_Offer_Intended_end_Dt_BB"-"end_date" between 9*7 and 9*7+6)
    and "Offers_Applied_Next_7D_DTV" = 0
    and "Offers_Applied_Next_7D_BB" = 0
    and(case when "DTV_Status_Code" in( 'AB','PC' ) 
    or "DTV_ABs_In_Next_7D"+"DTV_PL_Cancels_In_Next_7D"+"DTV_SDCs_In_Next_7D" > 0 then
      1
    else 0
    end) = 0
    and "DTV_Active" = 1;
  -- update Forecast_Loop_Table as a
  -- set   pred_Offer_Bridging_rate --_post_overlay
  --         = Coalesce(EOO.Treatment_Rate * c.Headroom_Multiplier * Offer_Autotreatment_Rate_Multiplier /*Temp Multiplier to Reduce Bridging from 1.8m to 1.5m*/ * 0.835654596  
  --             * Case when Include_Offer_Bridging = 'Yes' then 1 else 0 end
  --             * Case when A.subs_week_and_year between 201749 and 201848 then Bridging_EOO_Multiplier else 1 end,0) -- Offer Bridging Fix
  -- from Forecast_Loop_Table as A
  --      inner join
  --      #Offer_Bridging_Ratio as c
  --      on c.cuscan_forecast_segment = a.cuscan_forecast_segment
  --      inner join
  --      Decisioning.Offer_Bridging_EOO_Treatment_Rates EOO
  --      on EOO.CusCan_Forecast_Segment = A.CusCan_Forecast_Segment
  -- where (Curr_Offer_Intended_end_Dt_DTV - end_date between 8*7 and 8*7 + 6
  --       or Curr_Offer_Intended_end_Dt_BB  - end_date between 8*7 and 8*7 + 6)
  --       and Offers_Applied_Next_7D_DTV = 0
  --       and Offers_Applied_Next_7D_BB = 0
  --       and (Case when DTV_Status_Code in ('AB','PC')
  --                         or DTV_ABs_In_Next_7D+DTV_PL_Cancels_In_Next_7D+DTV_SDCs_In_Next_7D > 0
  -- --                         or TA_Call_Cust > 0
  -- --                         or WC_Call_Cust > 0
  --                   then 1
  --                   else 0
  --              end) = 0
  --         and DTV_Active = 1
  -- ;
  --
  -- Select top 100 * from Forecast_Loop_Table where pred_Offer_Bridging_rate > 0
  update "Forecast_Loop_Table" as "a"
    set "DTV_Offer_Applied_Bridging_Overlay" = case when "Curr_Offer_Intended_End_Dt_DTV" is not null then 1 else 0 end,
    "BB_Offer_Applied_Bridging_Overlay" = case when "Curr_Offer_Intended_End_Dt_BB" is not null then 1 else 0 end from
    "Forecast_Loop_Table" as "a"
    where("Curr_Offer_Intended_end_Dt_DTV"-"end_date" between 9*7 and 9*7+6
    or "Curr_Offer_Intended_end_Dt_BB"-"end_date" between 9*7 and 9*7+6)
    and "rand_NonTA_DTV_Offer_Applied" >= (1-"pred_Offer_Bridging_rate") -- Select from customers least likely to have had any other offer applied
    and "Offers_Applied_Next_7D_DTV" = 0
    and "Offers_Applied_Next_7D_BB" = 0
    and(case when "DTV_Status_Code" in( 'AB','PC' ) 
    or "DTV_ABs_In_Next_7D"+"DTV_PL_Cancels_In_Next_7D"+"DTV_SDCs_In_Next_7D" > 0 then
      --                  or TA_Call_Cust > 0
      --                  or WC_Call_Cust > 0
      1
    else 0
    end) = 0 -- Not a customer in PL at start of week or entering PL during the week
    and "DTV_Active" = 1;
  -----------------------------------------------------------------------------------------
  -- Product Regrades
  -----------------------------------------------------------------------------------------
  update "Forecast_Loop_Table" as "Base"
    set "BB_Product_Holding_EoW" = "BB"."Product_Holding_EoD",
    "Offers_Applied_Next_7D_BB" = "BB"."Offers_Applied_Lst_1D_BB",
    "BB_Contracts_Applied_In_Next_7D" = "BB"."Contract_Applied_Lst_1D_BB" from
    "BB_Regrades_Rates" as "BB"
    where "BB"."CusCan_Forecast_Segment" = "Base"."CusCan_Forecast_Segment"
    and "BB"."BB_Product_Holding" = "Base"."BB_Product_Holding"
    and "Base"."Rand_BB_Regrade" between "BB"."Lwr_Pctl" and "BB"."Upr_Pctl"
    and "BB"."BB_Regrades" > 0
    and "DTV_Active" = 1 and "BB_Active" = 1
end //grant execute on Decisioning_Procs.Forecast_Weekly_Actions_Rose to decisioning

