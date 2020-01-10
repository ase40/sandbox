create procedure "Decisioning_Procs"."Forecast_SysCan_Segment"( 
  in "Base_Table_" varchar(100),
  in "Base_Table_Where" varchar(1000),
  in "SysCan_Segment_Field" varchar(100),
  in "DTV_Status_Code" varchar(100),
  in "DTV_ABs_Ever" varchar(100),
  -- IN Previous_ABs varchar(100),
  -- IN Previous_AB_Count varchar(100),
  -- IN Simple_Segments varchar(100),
  in "DTV_Tenure" varchar(100),
  in "Days_Since_Last_Payment_Dt" varchar(100),
  in "Affluence" varchar(100),
  in "BB_Active" varchar(100),
  in "Package_Desc" varchar(100),
  in "Country" varchar(100),
  in "Time_Since_Last_AB" varchar(100),
  in "Time_To_Offer_End_DTV" varchar(100) ) 
sql security invoker -- RESULT(Account_number varchar(20),End_date date,SysCan_Forecast_Segment varchar(100))
begin
  declare "SysCan_Forecast_Segment" varchar(100);
  declare "Days_Since_Last_Payment_Dt_Binned" varchar(20);
  declare "BB_Segment" varchar(10);
  -- Declare Previous_AB_Count_Binned varchar(20);
  declare "Time_Since_Last_AB_Binned" varchar(20);
  declare "Dynamic_SQL" varchar(10000);
  set temporary option "Query_Temp_Space_Limit" = 0;
  drop table if exists #temp;
  set "Dynamic_SQL" = '' --'Insert into #temp '
     || ' Select Account_Number,End_Date, '
     || 'base.' || "DTV_Status_Code" || ' as DTV_Status_Code, '
     || 'base.' || "DTV_ABs_Ever" || ' as DTV_ABs_Ever, '
    -- || 'base.' || DTV_ABs_Ever || ' as Previous_ABs, '
    -- || 'base.' || Previous_AB_Count || ' as Previous_AB_Count, '
    -- || 'base.' || Simple_Segments || ' as Simple_Segments, '
     || 'base.' || "DTV_Tenure" || ' as DTV_Tenure, '
     || 'base.' || "Days_Since_Last_Payment_Dt" || ' as Days_Since_Last_Payment_Dt, '
     || 'base.' || "Affluence" || ' as Affluence, '
     || 'base.' || "BB_Active" || ' as BB_Active, '
     || 'base.' || "Package_Desc" || ' as Package_Desc, '
     || 'base.' || "Country" || ' as Country, '
     || 'base.' || "Time_Since_Last_AB" || ' as Time_Since_Last_AB, '
     || 'base.' || "Time_To_Offer_End_DTV" || ' as Time_To_Offer_End_DTV, '
     || 'base.Days_Since_Last_Payment_Dt_Binned, '
     || 'base.BB_Segment, '
     || 'base.Previous_AB_Count_Binned, '
    -- || 'Cast(null as varchar(20)) as Time_Since_Last_AB_Binned, '
     || 'Cast(null as varchar(100)) as SysCan_Forecast_Segment '
     || ' into #temp '
     || ' from ' || "Base_Table_" || ' as base'
     || ' ' || "Base_Table_Where";
  -- Select Dynamic_SQL;
  -- 
  -- return;
  execute immediate "Dynamic_SQL";
  commit work;
  create lf index "idx_1" on #temp("Days_Since_Last_Payment_Dt_Binned");
  create hg index "idx_2" on #temp("Account_Number");
  create lf index "idx_3" on #temp("end_date");
  -- Update #temp
  -- Set
  -- --    Time_Since_Last_AB_Binned = Time_Since_Last_AB,
  -- --         Case when Previous_ABs = '0' then 'N/A'
  -- --              when Time_Since_Last_AB = 0 then '0 Wks'
  -- --              when Time_Since_Last_AB <= 2 then '1-2 Wks'
  -- --              when Time_Since_Last_AB <= 4 then '3-4 Wks'
  -- --              when Time_Since_Last_AB <=6 then '5-6 Wks'
  -- --              when Time_Since_Last_AB <=7 then '7 Wks'
  -- --              when Time_Since_Last_AB <=8 then '8 Wks'
  -- --              when Time_Since_Last_AB <=11 then '9-11 Wks'
  -- --              when Time_Since_Last_AB <=12 then '12 Wks'
  -- --              else '13+ Wks'
  -- --         end,
  --     Previous_AB_Count_Binned = 
  --         Case    when DTV_ABs_Ever <= 5 then '' || DTV_ABs_Ever 
  --                 when DTV_ABs_Ever <= 20 then '6-20'             
  --                 when DTV_ABs_Ever > 20 then '21+'
  --                 else '0'
  --         end, 
  --     Days_Since_Last_Payment_Dt_Binned =
  --         Case when Days_Since_Last_Payment_Dt < 4 then '< 4'
  --              when Days_Since_Last_Payment_Dt > 16 then '> 16'
  --              else '' || Days_Since_Last_Payment_Dt
  --         End,
  --     BB_Segment = Case when BB_Active > 0 then 'BB' else 'Non-BB' end
  -- --     Previous_AB_Count_Binned = Previous_ABs
  --     ;
  update #temp set "Days_Since_Last_Payment_Dt_Binned" = null where "Days_Since_Last_Payment_Dt_Binned" = '';
  update #temp
    set #temp."SysCan_Forecast_Segment"
     = case when "DTV_Status_Code" in( 'AB','PC' ) then "DTV_Status_Code"
    when "Time_Since_Last_AB" in( '0 Wks','N/A' ) then
      case when "DTV_Tenure" in( 'M01' ) then
        case when "Days_Since_Last_Payment_Dt_Binned" in( '10','8' ) then
          case when "Affluence" in( 'High','Mid','Mid High','Mid Low','Very High' ) then 'Rule 1'
          when "Affluence" in( 'Low','Unknown','Very Low' ) then 'Rule 2' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '11','12','9' ) then 'Rule 3'
        //                        Case
        //                            When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support' ) then 'Rule 3'
        //                            When Simple_Segments in ( '4 Stabilise','Other/Unknown' ) then 'Rule 4' 
        //                        End
        when "Days_Since_Last_Payment_Dt_Binned" in( '13','14','7' ) then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 5'
          when "Affluence" in( 'Low','Very Low' ) then 'Rule 6'
          when "Affluence" in( 'Mid','Mid Low' ) then 'Rule 7'
          when "Affluence" in( 'Unknown' ) then 'Rule 8' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '15' ) then 'Rule 9'
        when "Days_Since_Last_Payment_Dt_Binned" in( '16','4','5','> 16' ) then
          case when "Time_To_Offer_End_DTV" in( 'No Offer End DTV','Offer Ended 7+ Wks','Offer Ended in last 4-6 Wks','Offer Ending in Next 4-6 Wks' ) then 'Rule 10'
          when "Time_To_Offer_End_DTV" in( 'Offer Ended in last 1 Wks','Offer Ended in last 2-3 Wks','Offer Ending in 7+ Wks','Offer Ending in Next 1 Wks','Offer Ending in Next 2-3 Wks' ) then 'Rule 11' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '6' ) then 'Rule 12'
        when "Days_Since_Last_Payment_Dt_Binned" in( '< 4' ) then
          case when "Affluence" in( 'High','Mid','Mid High' ) then 'Rule 13'
          when "Affluence" in( 'Low','Mid Low','Unknown','Very High' ) then 'Rule 14'
          when "Affluence" in( 'Very Low' ) then 'Rule 15' end
        when "Days_Since_Last_Payment_Dt_Binned" is null then 'Rule 16' end
      //                        Case
      //                            When Simple_Segments in ( '2 Stimulate','3 Support' ) then 'Rule 16'
      //                            When Simple_Segments in ( '4 Stabilise','Other/Unknown' ) then 'Rule 17' 
      //                        End 
      when "DTV_Tenure" in( 'M10' ) then
        case when "Days_Since_Last_Payment_Dt_Binned" in( '10' ) then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 18'
          when "Affluence" in( 'Low' ) then 'Rule 19'
          when "Affluence" in( 'Mid' ) then 'Rule 20'
          when "Affluence" in( 'Mid Low' ) then 'Rule 21'
          when "Affluence" in( 'Unknown' ) then 'Rule 22'
          when "Affluence" in( 'Very Low' ) then 'Rule 23' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '11','12' ) then
          case when "Affluence" in( 'High','Very High' ) then 'Rule 24'
          when "Affluence" in( 'Low' ) then 'Rule 25'
          when "Affluence" in( 'Mid' ) then 'Rule 26'
          when "Affluence" in( 'Mid High' ) then 'Rule 27'
          when "Affluence" in( 'Mid Low' ) then 'Rule 28'
          when "Affluence" in( 'Unknown' ) then 'Rule 29'
          when "Affluence" in( 'Very Low' ) then 'Rule 30' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '13','14' ) then
          case when "Affluence" in( 'High','Very High' ) then 'Rule 31'
          when "Affluence" in( 'Low' ) then 'Rule 32'
          when "Affluence" in( 'Mid' ) then 'Rule 33'
          when "Affluence" in( 'Mid High' ) then 'Rule 34'
          when "Affluence" in( 'Mid Low','Unknown' ) then 'Rule 35'
          when "Affluence" in( 'Very Low' ) then 'Rule 36' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '15','> 16' ) or "Days_Since_Last_Payment_Dt_Binned" is null then
          case when "Affluence" in( 'High','Very High' ) then 'Rule 37'
          when "Affluence" in( 'Low' ) then 'Rule 38'
          when "Affluence" in( 'Mid' ) then 'Rule 39'
          when "Affluence" in( 'Mid High' ) then 'Rule 40'
          when "Affluence" in( 'Mid Low' ) then 'Rule 41'
          when "Affluence" in( 'Unknown' ) then 'Rule 42'
          when "Affluence" in( 'Very Low' ) then 'Rule 43' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '16' ) then
          case when "Affluence" in( 'High','Mid','Mid High','Mid Low','Very High' ) then 'Rule 44'
          when "Affluence" in( 'Low','Unknown','Very Low' ) then 'Rule 45' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '4','5','< 4' ) then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 46'
          when "Affluence" in( 'Low' ) then 'Rule 47'
          when "Affluence" in( 'Mid' ) then 'Rule 48'
          when "Affluence" in( 'Mid Low','Unknown' ) then 'Rule 49'
          when "Affluence" in( 'Very Low' ) then 'Rule 50' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '6','7' ) then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 51'
          when "Affluence" in( 'Low' ) then 'Rule 52'
          when "Affluence" in( 'Mid' ) then 'Rule 53'
          when "Affluence" in( 'Mid Low' ) then 'Rule 54'
          when "Affluence" in( 'Unknown' ) then 'Rule 55'
          when "Affluence" in( 'Very Low' ) then 'Rule 56' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '8','9' ) then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 57'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 58'
          when "Affluence" in( 'Mid' ) then 'Rule 59'
          when "Affluence" in( 'Mid Low' ) then 'Rule 60'
          when "Affluence" in( 'Very Low' ) then 'Rule 61' end
        end when "DTV_Tenure" in( 'M14' ) then
        case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11','12','8' ) then
          case when "Affluence" in( 'High','Mid','Very High' ) then 'Rule 62'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 63'
          when "Affluence" in( 'Mid High' ) then 'Rule 64'
          when "Affluence" in( 'Mid Low' ) then 'Rule 65'
          when "Affluence" in( 'Very Low' ) then 'Rule 66' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '13','6','7' ) then
          case when "Affluence" in( 'High','Mid','Mid High','Mid Low','Very High' ) then 'Rule 67'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 68'
          when "Affluence" in( 'Very Low' ) then 'Rule 69' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '14','9' ) then
          case when "Affluence" in( 'High','Very High' ) then 'Rule 70'
          when "Affluence" in( 'Low','Unknown','Very Low' ) then 'Rule 71'
          when "Affluence" in( 'Mid','Mid High','Mid Low' ) then 'Rule 72' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '15','> 16' ) then
          case when "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 73'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 74'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 75'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 76' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '16' ) or "Days_Since_Last_Payment_Dt_Binned" is null then 'Rule 77'
        when "Days_Since_Last_Payment_Dt_Binned" in( '4','5','< 4' ) then
          case when "Affluence" in( 'High','Mid','Mid High','Very High' ) then 'Rule 78'
          when "Affluence" in( 'Low' ) then 'Rule 79'
          when "Affluence" in( 'Mid Low','Unknown' ) then 'Rule 80'
          when "Affluence" in( 'Very Low' ) then 'Rule 81' end
        end when "DTV_Tenure" in( 'M24' ) then
        case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11','12' ) then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 82'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 83'
          when "Affluence" in( 'Mid' ) then 'Rule 84'
          when "Affluence" in( 'Mid Low' ) then 'Rule 85'
          when "Affluence" in( 'Very Low' ) then 'Rule 86' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '13','14','6' ) then
          case when "Affluence" in( 'High','Mid','Mid High','Very High' ) then 'Rule 87'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 88'
          when "Affluence" in( 'Mid Low' ) then 'Rule 89'
          when "Affluence" in( 'Very Low' ) then 'Rule 90' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '15','4','5','> 16' ) then
          case when "Days_Since_Last_Payment_Dt" <= 5 then 'Rule 91'
          when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 92'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 93'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 94'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 95' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '16' ) or "Days_Since_Last_Payment_Dt_Binned" is null then 'Rule 96'
        when "Days_Since_Last_Payment_Dt_Binned" in( '7' ) then
          case when "Affluence" in( 'High','Mid','Mid High','Very High' ) then 'Rule 97'
          when "Affluence" in( 'Low','Mid Low','Unknown','Very Low' ) then 'Rule 98' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '8','9' ) then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 99'
          when "Affluence" in( 'Low','Very Low' ) then 'Rule 100'
          when "Affluence" in( 'Mid','Mid Low','Unknown' ) then 'Rule 101' end
        when "Days_Since_Last_Payment_Dt_Binned" in( '< 4' ) then
          case when "Affluence" in( 'High','Very High' ) then 'Rule 102'
          when "Affluence" in( 'Low' ) then 'Rule 103'
          when "Affluence" in( 'Mid','Mid High','Mid Low','Unknown' ) then 'Rule 104'
          when "Affluence" in( 'Very Low' ) then 'Rule 105' end
        end when "DTV_Tenure" in( 'Y03' ) then
        case when "Days_Since_Last_Payment_Dt" <= 2 then
          case when "Affluence" in( 'High','Mid High','Mid Low' ) then 'Rule 106'
          when "Affluence" in( 'Low','Unknown','Very Low' ) then 'Rule 107'
          when "Affluence" in( 'Mid','Very High' ) then 'Rule 108' end
        when "Days_Since_Last_Payment_Dt" > 2 and "Days_Since_Last_Payment_Dt" <= 5 then
          case when "Affluence" in( 'High','Mid','Mid High','Mid Low','Very High' ) then 'Rule 109'
          when "Affluence" in( 'Low','Unknown','Very Low' ) then 'Rule 110' end
        when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 8 then
          case when "Affluence" in( 'High','Mid','Mid High','Very High' ) then 'Rule 111'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 112'
          when "Affluence" in( 'Mid Low' ) then 'Rule 113'
          when "Affluence" in( 'Very Low' ) then 'Rule 114' end
        when "Days_Since_Last_Payment_Dt" > 8 and "Days_Since_Last_Payment_Dt" <= 11 then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 115'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 116'
          when "Affluence" in( 'Mid','Mid Low' ) then 'Rule 117'
          when "Affluence" in( 'Very Low' ) then 'Rule 118' end
        when "Days_Since_Last_Payment_Dt" > 11 and "Days_Since_Last_Payment_Dt" <= 14 then
          case when "Affluence" in( 'High','Mid','Mid High' ) then 'Rule 119'
          when "Affluence" in( 'Low','Mid Low' ) then 'Rule 120'
          when "Affluence" in( 'Unknown','Very Low' ) then 'Rule 121'
          when "Affluence" in( 'Very High' ) then 'Rule 122' end
        when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 17 then
          case when "country" in( 'ROI' ) then 'Rule 123'
          when "country" in( 'UK' ) then 'Rule 124' end
        when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 then
          case when "BB_Segment" in( 'BB' ) then 'Rule 125'
          when "BB_Segment" in( 'Non-BB' ) then 'Rule 126' end
        when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then
          case when "BB_Segment" in( 'BB' ) then 'Rule 127'
          when "BB_Segment" in( 'Non-BB' ) then 'Rule 128' end
        when "Days_Since_Last_Payment_Dt" > 26 then
          case when "Affluence" in( 'High','Mid','Mid High','Very High' ) then 'Rule 129'
          when "Affluence" in( 'Low','Mid Low','Unknown' ) then 'Rule 130'
          when "Affluence" in( 'Very Low' ) then 'Rule 131' end
        end when "DTV_Tenure" in( 'Y05' ) then
        case when "Days_Since_Last_Payment_Dt" <= 2 then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 132'
          when "Affluence" in( 'Low','Mid Low' ) then 'Rule 133'
          when "Affluence" in( 'Mid','Unknown' ) then 'Rule 134'
          when "Affluence" in( 'Very Low' ) then 'Rule 135' end
        when "Days_Since_Last_Payment_Dt" > 2 and "Days_Since_Last_Payment_Dt" <= 5 then
          case when "Affluence" in( 'High','Mid','Mid High','Mid Low','Very High' ) then 'Rule 136'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 137'
          when "Affluence" in( 'Very Low' ) then 'Rule 138' end
        when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 8 then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 139'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 140'
          when "Affluence" in( 'Mid','Mid Low' ) then 'Rule 141'
          when "Affluence" in( 'Very Low' ) then 'Rule 142' end
        when "Days_Since_Last_Payment_Dt" > 8 and "Days_Since_Last_Payment_Dt" <= 11 then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 143'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 144'
          when "Affluence" in( 'Mid','Mid Low' ) then 'Rule 145'
          when "Affluence" in( 'Very Low' ) then 'Rule 146' end
        when "Days_Since_Last_Payment_Dt" > 11 and "Days_Since_Last_Payment_Dt" <= 14 then
          case when "Affluence" in( 'High','Mid High','Very High' ) then 'Rule 147'
          when "Affluence" in( 'Low','Unknown' ) then 'Rule 148'
          when "Affluence" in( 'Mid','Mid Low' ) then 'Rule 149'
          when "Affluence" in( 'Very Low' ) then 'Rule 150' end
        when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 17 then
          case when "country" in( 'ROI' ) then 'Rule 151'
          when "country" in( 'UK' ) then 'Rule 152' end
        when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 or "Days_Since_Last_Payment_Dt" is null then 'Rule 153'
        when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then
          case when "Affluence" in( 'High','Mid','Mid High','Unknown','Very High' ) then 'Rule 154'
          when "Affluence" in( 'Low','Mid Low' ) then 'Rule 155'
          when "Affluence" in( 'Very Low' ) then 'Rule 156' end
        when "Days_Since_Last_Payment_Dt" > 26 then
          case when "Affluence" in( 'High','Very High' ) then 'Rule 157'
          when "Affluence" in( 'Low' ) then 'Rule 158'
          when "Affluence" in( 'Mid','Mid High','Mid Low','Unknown' ) then 'Rule 159'
          when "Affluence" in( 'Very Low' ) then 'Rule 160' end
        end when "DTV_Tenure" in( 'Y05+' ) then
        case when "Affluence" in( 'High','Mid High','Very High' ) then
          case when "Days_Since_Last_Payment_Dt" <= 2 then 'Rule 161'
          when "Days_Since_Last_Payment_Dt" > 2 and "Days_Since_Last_Payment_Dt" <= 5 then 'Rule 162'
          when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 8 then 'Rule 163'
          when "Days_Since_Last_Payment_Dt" > 8 and "Days_Since_Last_Payment_Dt" <= 11 then 'Rule 164'
          when "Days_Since_Last_Payment_Dt" > 11 and "Days_Since_Last_Payment_Dt" <= 14 then 'Rule 165'
          when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 166'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 or "Days_Since_Last_Payment_Dt" is null then 'Rule 167'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 168'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 169' end
        when "Affluence" in( 'Low' ) then
          case when "Days_Since_Last_Payment_Dt" <= 5 then 'Rule 170'
          when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 11 then 'Rule 171'
          when "Days_Since_Last_Payment_Dt" > 11 and "Days_Since_Last_Payment_Dt" <= 14 then 'Rule 172'
          when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 20 or "Days_Since_Last_Payment_Dt" is null then 'Rule 173'
          when "Days_Since_Last_Payment_Dt" > 20 and "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 174'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 175'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 176' end
        when "Affluence" in( 'Mid' ) then
          case when "Days_Since_Last_Payment_Dt" <= 5 then 'Rule 177'
          when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 11 then 'Rule 178'
          when "Days_Since_Last_Payment_Dt" > 11 and "Days_Since_Last_Payment_Dt" <= 14 then 'Rule 179'
          when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 180'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 20 or "Days_Since_Last_Payment_Dt" is null then 'Rule 181'
          when "Days_Since_Last_Payment_Dt" > 20 and "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 182'
          when "Days_Since_Last_Payment_Dt" > 23 then 'Rule 183' end
        when "Affluence" in( 'Mid Low' ) then
          case when "Days_Since_Last_Payment_Dt" <= 2 then 'Rule 184'
          when "Days_Since_Last_Payment_Dt" > 2 and "Days_Since_Last_Payment_Dt" <= 5 then 'Rule 185'
          when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 8 then 'Rule 186'
          when "Days_Since_Last_Payment_Dt" > 8 and "Days_Since_Last_Payment_Dt" <= 11 then 'Rule 187'
          when "Days_Since_Last_Payment_Dt" > 11 and "Days_Since_Last_Payment_Dt" <= 14 then 'Rule 188'
          when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 189'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 or "Days_Since_Last_Payment_Dt" is null then 'Rule 190'
          when "Days_Since_Last_Payment_Dt" > 23 then 'Rule 191' end
        when "Affluence" in( 'Unknown','Very Low' ) then
          case when "Days_Since_Last_Payment_Dt" <= 2 then 'Rule 192'
          when "Days_Since_Last_Payment_Dt" > 2 and "Days_Since_Last_Payment_Dt" <= 5 then 'Rule 193'
          when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 8 then 'Rule 194'
          when "Days_Since_Last_Payment_Dt" > 8 and "Days_Since_Last_Payment_Dt" <= 14 then 'Rule 195'
          when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 196'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 or "Days_Since_Last_Payment_Dt" is null then 'Rule 197'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 198'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 199' end
        end
      end when "Time_Since_Last_AB" in( '1-2 Wks' ) then
      case when "Days_Since_Last_Payment_Dt" <= 5 then
        case when "BB_Segment" in( 'BB' ) then
          case when "Days_Since_Last_Payment_Dt" <= 2 then 'Rule 200'
          when "Days_Since_Last_Payment_Dt" > 2 then 'Rule 201' end
        when "BB_Segment" in( 'Non-BB' ) then 'Rule 202' end
      when "Days_Since_Last_Payment_Dt" > 5 and "Days_Since_Last_Payment_Dt" <= 14 then
        case when "Package_Desc" in( 'Family' ) then 'Rule 203'
        when "Package_Desc" in( 'Kids,Mix,World','Original','SKY Q','Variety' ) or "Package_Desc" is null then 'Rule 204' end
      when "Days_Since_Last_Payment_Dt" > 14 and "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 205'
      when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 20 then 'Rule 206'
      when "Days_Since_Last_Payment_Dt" > 20 and "Days_Since_Last_Payment_Dt" <= 23 or "Days_Since_Last_Payment_Dt" is null then
        case when "DTV_Tenure" in( 'M01','M24','Y03','Y05','Y05+' ) then 'Rule 207'
        when "DTV_Tenure" in( 'M10','M14' ) then 'Rule 208' end
      when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then
        case when "Package_Desc" in( 'Family','Original','SKY Q' ) then 'Rule 209'
        when "Package_Desc" in( 'Variety' ) then 'Rule 210' end
      when "Days_Since_Last_Payment_Dt" > 26 then
        case when "Affluence" in( 'High','Low','Very Low' ) then 'Rule 211'
        when "Affluence" in( 'Mid','Mid High','Mid Low','Unknown','Very High' ) then 'Rule 212' end
      end when "Time_Since_Last_AB" in( '12 Wks' ) then
      case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11','12' ) then 'Rule 213'
      when "Days_Since_Last_Payment_Dt_Binned" in( '13','14','8','9' ) then 'Rule 214'
      when "Days_Since_Last_Payment_Dt_Binned" in( '15','16','4','5','6','7','< 4' ) then 'Rule 215'
      when "Days_Since_Last_Payment_Dt_Binned" in( '> 16' ) then 'Rule 216' end
    when "Time_Since_Last_AB" in( '13+ Wks' ) then
      case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11' ) then
        //                When Simple_Segments in ( '4 Stabilise','Other/Unknown' )  then Case
        case when "Previous_AB_Count_Binned" in( '1' ) then 'Rule 222'
        when "Previous_AB_Count_Binned" in( '2' ) then 'Rule 223'
        when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 224'
        when "Previous_AB_Count_Binned" in( '3','4' ) then 'Rule 225'
        when "Previous_AB_Count_Binned" in( '5' ) then 'Rule 226'
        //                    End 
        //                When Simple_Segments in ( '1 Secure','2 Stimulate' )  then 
        //                    Case
        when "DTV_Tenure" in( 'M01','M10','M14','M24','Y03' ) then 'Rule 217'
        when "DTV_Tenure" in( 'Y05' ) then 'Rule 218'
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 219'
        //                    End
        //                When Simple_Segments in ( '3 Support' )  then 
        //                    Case
        when "DTV_Tenure" in( 'M01','M10','M14','M24','Y03','Y05' ) then 'Rule 220'
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 221' end
      //                    End 
      when "Days_Since_Last_Payment_Dt_Binned" in( '12' ) then
        //                        When Simple_Segments in ( '4 Stabilise' )  then 
        //                            Case
        case when "Previous_AB_Count_Binned" in( '1' ) then 'Rule 230'
        when "Previous_AB_Count_Binned" in( '2' ) then 'Rule 231'
        when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 232'
        when "Previous_AB_Count_Binned" in( '3','4','5' ) then 'Rule 233'
        //                            End 
        //                        When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support','Other/Unknown' )  then 
        //                            Case
        when "DTV_Tenure" in( 'M01','M10','M14','M24','Y03' ) then 'Rule 227'
        when "DTV_Tenure" in( 'Y05' ) then 'Rule 228'
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 229' end
      //                            End
      when "Days_Since_Last_Payment_Dt_Binned" in( '13' ) then
        case when "DTV_Tenure" in( 'M01','Y05' ) then 'Rule 234'
        //                        Case
        //                            When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support' ) then 'Rule 234'
        //                            When Simple_Segments in ( '4 Stabilise','Other/Unknown' ) then 'Rule 235' 
        //                        End
        when "DTV_Tenure" in( 'M10' ) then 'Rule 236'
        when "DTV_Tenure" in( 'M14','M24' ) then
          case when "DTV_ABs_Ever" <= 1 then 'Rule 237'
          when "DTV_ABs_Ever" > 1 then 'Rule 238' end
        when "DTV_Tenure" in( 'Y03' ) then 'Rule 239'
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 240' end
      //                        Case
      //                            When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support','Other/Unknown' ) then 'Rule 240'
      //                            When Simple_Segments in ( '4 Stabilise' ) then 'Rule 241' 
      //                        End 
      when "Days_Since_Last_Payment_Dt_Binned" in( '14' ) then
        case when "DTV_Tenure" in( 'M01','Y05+' ) then 'Rule 242'
        //                        Case
        //                            When Simple_Segments in ( '1 Secure','3 Support','Other/Unknown' ) then 'Rule 242'
        //                            When Simple_Segments in ( '2 Stimulate' ) then 'Rule 243'
        //                            When Simple_Segments in ( '4 Stabilise' ) then 'Rule 244' 
        //                        End
        when "DTV_Tenure" in( 'M10' ) then 'Rule 245'
        when "DTV_Tenure" in( 'M14','M24' ) then
          case when "DTV_ABs_Ever" <= 1 then 'Rule 246'
          when "DTV_ABs_Ever" > 1 then 'Rule 247' end
        when "DTV_Tenure" in( 'Y03' ) then 'Rule 248'
        when "DTV_Tenure" in( 'Y05' ) then 'Rule 249' end
      //                        Case
      //                            When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support' ) then 'Rule 249'
      //                            When Simple_Segments in ( '4 Stabilise','Other/Unknown' ) then 'Rule 250' 
      //                        End 
      when "Days_Since_Last_Payment_Dt_Binned" in( '15' ) then
        case when "country" in( 'ROI' ) then
          case when "DTV_ABs_Ever" <= 1 then 'Rule 251'
          when "DTV_ABs_Ever" > 1 then 'Rule 252' end
        when "country" in( 'UK' ) then 'Rule 253' end
      //                        Case
      //                            When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support' ) then 'Rule 253'
      //                            When Simple_Segments in ( '4 Stabilise','Other/Unknown' ) then 'Rule 254' 
      //                        End 
      when "Days_Since_Last_Payment_Dt_Binned" in( '16' ) then
        case when "DTV_Tenure" in( 'M01','M14','M24','Y03' ) then
          case when "Previous_AB_Count_Binned" in( '1','2' ) then 'Rule 255'
          when "Previous_AB_Count_Binned" in( '21+','3','4','5','6-20' ) then 'Rule 256' end
        when "DTV_Tenure" in( 'M10' ) then 'Rule 257'
        when "DTV_Tenure" in( 'Y05' ) then 'Rule 258'
        //                        Case
        //                            When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support' ) then 'Rule 258'
        //                            When Simple_Segments in ( '4 Stabilise','Other/Unknown' ) then 'Rule 259' 
        //                        End
        when "DTV_Tenure" in( 'Y05+' ) then
          case when "country" in( 'ROI' ) then 'Rule 260'
          when "country" in( 'UK' ) then 'Rule 261' end
        end when "Days_Since_Last_Payment_Dt_Binned" in( '4','5','< 4' ) then
        //                When Simple_Segments in ( '4 Stabilise','Other/Unknown' )  then Case
        case when "Previous_AB_Count_Binned" in( '1' ) then 'Rule 271'
        when "Previous_AB_Count_Binned" in( '2' ) then 'Rule 272'
        when "Previous_AB_Count_Binned" in( '21+' ) then 'Rule 273'
        when "Previous_AB_Count_Binned" in( '3','4' ) then 'Rule 274'
        when "Previous_AB_Count_Binned" in( '5' ) then 'Rule 275'
        when "Previous_AB_Count_Binned" in( '6-20' ) then 'Rule 276'
        //                        End 
        //                When Simple_Segments in ( '2 Stimulate' )  then Case
        when "Affluence" in( 'High','Mid','Very High' ) then 'Rule 264'
        when "Affluence" in( 'Low','Mid Low','Very Low' ) then 'Rule 265'
        when "Affluence" in( 'Mid High','Unknown' ) then 'Rule 266'
        //                        End
        //                When Simple_Segments in ( '1 Secure' )  then Case
        when "DTV_Tenure" in( 'M01','M10','M14','Y05+' ) then 'Rule 262'
        when "DTV_Tenure" in( 'M24','Y03','Y05' ) then 'Rule 263'
        //                        End
        //                When Simple_Segments in ( '3 Support' )  then Case
        when "Previous_AB_Count_Binned" in( '1' ) then 'Rule 267'
        when "Previous_AB_Count_Binned" in( '2' ) then 'Rule 268'
        when "Previous_AB_Count_Binned" in( '21+','3','4','6-20' ) then 'Rule 269'
        when "Previous_AB_Count_Binned" in( '5' ) then 'Rule 270' end
      //                        End
      when "Days_Since_Last_Payment_Dt_Binned" in( '6' ) then
        //                When Simple_Segments in ( '4 Stabilise' )  then Case
        case when "Previous_AB_Count_Binned" in( '1' ) then 'Rule 281'
        when "Previous_AB_Count_Binned" in( '2','3' ) then 'Rule 282'
        when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 283'
        when "Previous_AB_Count_Binned" in( '4','5' ) then 'Rule 284'
        //                End 
        //                When Simple_Segments in ( '1 Secure','2 Stimulate' )  then Case
        when "DTV_Tenure" in( 'M01','M10','M14','M24','Y03','Y05' ) then 'Rule 277'
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 278'
        //                End
        //                When Simple_Segments in ( '3 Support','Other/Unknown' )  then Case
        when "DTV_Tenure" in( 'M01','M10','M14','M24','Y03','Y05' ) then 'Rule 279'
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 280' end
      //                End
      when "Days_Since_Last_Payment_Dt_Binned" in( '7' ) then
        case when "DTV_Tenure" in( 'M01','M10','M14' ) then
          case when "BB_Segment" in( 'BB' ) then 'Rule 285'
          when "BB_Segment" in( 'Non-BB' ) then 'Rule 286' end
        when "DTV_Tenure" in( 'M24','Y03' ) then
          case when "DTV_ABs_Ever" <= 1 then 'Rule 287'
          when "DTV_ABs_Ever" > 1 then 'Rule 288' end
        when "DTV_Tenure" in( 'Y05' ) then 'Rule 289'
        //                        Case
        //                            When Simple_Segments in ( '1 Secure','2 Stimulate','3 Support','Other/Unknown' ) then 'Rule 289'
        //                            When Simple_Segments in ( '4 Stabilise' ) then 'Rule 290' 
        //                        End
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 291' end
      //                        Case
      //                            When Simple_Segments in ( '1 Secure','3 Support' ) then 'Rule 291'
      //                            When Simple_Segments in ( '2 Stimulate','Other/Unknown' ) then 'Rule 292'
      //                            When Simple_Segments in ( '4 Stabilise' ) then 'Rule 293' 
      //                        End 
      when "Days_Since_Last_Payment_Dt_Binned" in( '8','9' ) then
        //                When Simple_Segments in ( '4 Stabilise','Other/Unknown' )  then Case
        case when "Previous_AB_Count_Binned" in( '1' ) then 'Rule 298'
        when "Previous_AB_Count_Binned" in( '2' ) then 'Rule 299'
        when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 300'
        when "Previous_AB_Count_Binned" in( '3' ) then 'Rule 301'
        when "Previous_AB_Count_Binned" in( '4','5' ) then 'Rule 302'
        //                        End 
        //                When Simple_Segments in ( '1 Secure','3 Support' )  then Case
        when "DTV_Tenure" in( 'M01','Y05+' ) then 'Rule 294'
        when "DTV_Tenure" in( 'M10','M14','M24','Y03','Y05' ) then 'Rule 295'
        //                        End
        //                When Simple_Segments in ( '2 Stimulate' )  then Case
        when "DTV_Tenure" in( 'M01','M10','M14','M24','Y03','Y05' ) then 'Rule 296'
        when "DTV_Tenure" in( 'Y05+' ) then 'Rule 297' end
      //                        End
      when "Days_Since_Last_Payment_Dt_Binned" in( '> 16' ) then
        case when "DTV_Tenure" in( 'M01' ) then
          case when "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 303'
          when "Days_Since_Last_Payment_Dt" > 23 then 'Rule 304' end
        when "DTV_Tenure" in( 'M10' ) then
          case when "Days_Since_Last_Payment_Dt" <= 20 then 'Rule 305'
          when "Days_Since_Last_Payment_Dt" > 20 and "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 306'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 307'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 308' end
        when "DTV_Tenure" in( 'M14' ) then
          case when "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 309'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 310'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 311' end
        when "DTV_Tenure" in( 'M24' ) then
          case when "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 312'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 313'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 314' end
        when "DTV_Tenure" in( 'Y03' ) then
          case when "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 315'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 316'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 317' end
        when "DTV_Tenure" in( 'Y05' ) then
          case when "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 318'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 319'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 320'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 321' end
        when "DTV_Tenure" in( 'Y05+' ) then
          case when "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 322'
          when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 20 then 'Rule 323'
          when "Days_Since_Last_Payment_Dt" > 20 and "Days_Since_Last_Payment_Dt" <= 23 then 'Rule 324'
          when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then 'Rule 325'
          when "Days_Since_Last_Payment_Dt" > 26 then 'Rule 326' end
        end
      end when "Time_Since_Last_AB" in( '3-4 Wks' ) then
      case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11','12' ) then
        case when "Previous_AB_Count_Binned" in( '1','2','3','4','5' ) then
          case when "Package_Desc" in( 'Family' ) then 'Rule 327'
          when "Package_Desc" in( 'Original','SKY Q','Variety' ) then 'Rule 328' end
        when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 329' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '13' ) then 'Rule 330'
      when "Days_Since_Last_Payment_Dt_Binned" in( '14' ) then 'Rule 331'
      when "Days_Since_Last_Payment_Dt_Binned" in( '15' ) then 'Rule 332'
      when "Days_Since_Last_Payment_Dt_Binned" in( '16' ) or "Days_Since_Last_Payment_Dt_Binned" is null then 'Rule 333'
      when "Days_Since_Last_Payment_Dt_Binned" in( '4','5' ) then 'Rule 334'
      when "Days_Since_Last_Payment_Dt_Binned" in( '6' ) then 'Rule 335'
      when "Days_Since_Last_Payment_Dt_Binned" in( '7' ) then 'Rule 336'
      when "Days_Since_Last_Payment_Dt_Binned" in( '8','9' ) then
        case when "Previous_AB_Count_Binned" in( '1','2','3','4','5' ) then 'Rule 337'
        when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 338' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '< 4' ) then
        case when "Previous_AB_Count_Binned" in( '1','2','3','4' ) then 'Rule 339'
        when "Previous_AB_Count_Binned" in( '21+','5','6-20' ) then 'Rule 340' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '> 16' ) then
        case when "Days_Since_Last_Payment_Dt" <= 23 then
          case when "DTV_Tenure" in( 'M01','M14','M24','Y05','Y05+' ) then 'Rule 341'
          when "DTV_Tenure" in( 'M10','Y03' ) then 'Rule 342' end
        when "Days_Since_Last_Payment_Dt" > 23 then
          case when "Previous_AB_Count_Binned" in( '1','2','3','4','5' ) then 'Rule 343'
          when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 344' end
        end
      end when "Time_Since_Last_AB" in( '5-6 Wks','9-11 Wks' ) then
      case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11','12','8','9' ) then
        case when "DTV_Tenure" in( 'M01','M24','Y03','Y05','Y05+' ) then
          case when "Previous_AB_Count_Binned" in( '1','2','3','4','5' ) then 'Rule 345'
          when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 346' end
        when "DTV_Tenure" in( 'M10','M14' ) then 'Rule 347' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '13','14','6','7' ) or "Days_Since_Last_Payment_Dt_Binned" is null then
        case when "DTV_Tenure" in( 'M01','M14','M24','Y03','Y05','Y05+' ) then
          case when "Previous_AB_Count_Binned" in( '1','2','3','4','5' ) then 'Rule 348'
          when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 349' end
        when "DTV_Tenure" in( 'M10' ) then 'Rule 350' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '15','< 4' ) then
        case when "DTV_Tenure" in( 'M01','Y05+' ) then 'Rule 351'
        when "DTV_Tenure" in( 'M10','M14' ) then
          case when "DTV_ABs_Ever" <= 1 then 'Rule 352'
          when "DTV_ABs_Ever" > 1 then 'Rule 353' end
        when "DTV_Tenure" in( 'M24','Y03','Y05' ) then
          case when "Previous_AB_Count_Binned" in( '1','2','3' ) then 'Rule 354'
          when "Previous_AB_Count_Binned" in( '21+','4','5','6-20' ) then 'Rule 355' end
        end when "Days_Since_Last_Payment_Dt_Binned" in( '16' ) then 'Rule 356'
      when "Days_Since_Last_Payment_Dt_Binned" in( '4','5' ) then
        case when "Package_Desc" in( 'Family','SKY Q' ) then 'Rule 357'
        when "Package_Desc" in( 'Original','Variety' ) then 'Rule 358' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '> 16' ) then
        case when "Days_Since_Last_Payment_Dt" <= 17 then 'Rule 359'
        when "Days_Since_Last_Payment_Dt" > 17 and "Days_Since_Last_Payment_Dt" <= 23 then
          case when "DTV_Tenure" in( 'M01','Y05+' ) then 'Rule 360'
          when "DTV_Tenure" in( 'M10' ) then 'Rule 361'
          when "DTV_Tenure" in( 'M14','M24' ) then 'Rule 362'
          when "DTV_Tenure" in( 'Y03','Y05' ) then 'Rule 363' end
        when "Days_Since_Last_Payment_Dt" > 23 and "Days_Since_Last_Payment_Dt" <= 26 then
          case when "Affluence" in( 'High','Mid','Mid High' ) then 'Rule 364'
          when "Affluence" in( 'Low','Mid Low' ) then 'Rule 365'
          when "Affluence" in( 'Unknown','Very High' ) then 'Rule 366'
          when "Affluence" in( 'Very Low' ) then 'Rule 367' end
        when "Days_Since_Last_Payment_Dt" > 26 then
          case when "Affluence" in( 'High','Mid','Mid High','Very High' ) then 'Rule 368'
          when "Affluence" in( 'Low','Very Low' ) then 'Rule 369'
          when "Affluence" in( 'Mid Low' ) then 'Rule 370'
          when "Affluence" in( 'Unknown' ) then 'Rule 371' end
        end
      end when "Time_Since_Last_AB" in( '7 Wks' ) then
      case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11','12','13','14','8','9' ) then 'Rule 372'
      when "Days_Since_Last_Payment_Dt_Binned" in( '15','< 4' ) then 'Rule 373'
      when "Days_Since_Last_Payment_Dt_Binned" in( '16','> 16' ) or "Days_Since_Last_Payment_Dt_Binned" is null then
        case when "Days_Since_Last_Payment_Dt" <= 23 or "Days_Since_Last_Payment_Dt" is null then 'Rule 374'
        when "Days_Since_Last_Payment_Dt" > 23 then 'Rule 375' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '4','5' ) then
        case when "Affluence" in( 'High','Mid','Mid High','Mid Low','Unknown','Very High' ) then 'Rule 376'
        when "Affluence" in( 'Low','Very Low' ) then 'Rule 377' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '6','7' ) then 'Rule 378' end
    when "Time_Since_Last_AB" in( '8 Wks' ) then
      case when "Days_Since_Last_Payment_Dt_Binned" in( '10','11','12','8','9' ) then
        case when "Previous_AB_Count_Binned" in( '1','2','3','4','5' ) then
          case when "DTV_Tenure" in( 'M01','M24','Y03','Y05','Y05+' ) then 'Rule 379'
          when "DTV_Tenure" in( 'M10','M14' ) then 'Rule 380' end
        when "Previous_AB_Count_Binned" in( '21+','6-20' ) then 'Rule 381' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '13','14','6','7' ) then
        case when "Affluence" in( 'High','Mid','Mid High','Mid Low','Unknown','Very High' ) then 'Rule 382'
        when "Affluence" in( 'Low','Very Low' ) then 'Rule 383' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '15','16','4','> 16' ) or "Days_Since_Last_Payment_Dt_Binned" is null then
        case when "Previous_AB_Count_Binned" in( '1','2','3','5' ) then 'Rule 384'
        when "Previous_AB_Count_Binned" in( '21+','4','6-20' ) then 'Rule 385' end
      when "Days_Since_Last_Payment_Dt_Binned" in( '5','< 4' ) then 'Rule 386' end
    end;
  set "Dynamic_SQL" = 'Update  ' || "Base_Table_" || ' '
     || ' Set ' || "SysCan_Segment_Field" || ' = seg.SysCan_Forecast_Segment '
     || 'from ' || "Base_Table_"
     || '       inner join '
     || '       #temp seg '
     || '       on seg.account_number = ' || "Base_Table_" || '.account_number '
     || '          and seg.end_date = ' || "Base_Table_" || '.end_date '
     || "Base_Table_Where";
  commit work;
  execute immediate "Dynamic_SQL"
end
