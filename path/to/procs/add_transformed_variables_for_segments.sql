create procedure "Decisioning_Procs"."Add_Transformed_Variables_For_Segments"( 
  in "Src_Table" varchar(100) default 'Forecast_Loop_Table',
  in "Where_Cond" long varchar default null,
  in "Output_Table_Name" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Loop_Num" integer;
  if "Output_Table_Name" <> "Src_Table" then
    execute immediate 'Drop table if exists ' || "Output_Table_Name";
    execute immediate 'Select * into ' || "Output_Table_Name" || ' from ' || "Src_Table" || ' ' || "Where_Cond"
  elseif "lower"("Src_Table") = 'citeam.cust_weekly_base' then
    set "Output_Table_Name" = 'Transformed_Cust_Weekly_Base';
    execute immediate 'Drop table if exists ' || "Output_Table_Name";
    execute immediate 'Select * into ' || "Output_Table_Name" || ' from ' || "Src_Table" || ' ' || "Where_Cond"
  end if;
  set "Output_Table_Name" = "Coalesce"("Output_Table_Name","Src_Table");
  drop table if exists #Existing_Columns;
  select *,"Row_Number"() over(order by "column_name" asc) as "RowNum"
    into #Existing_Columns
    from "sp_columns"("Output_Table_Name")
    where "table_owner" = current user
    and "lower"("column_name") in( 'bb_segment','dtv_tenure','affluence','package_desc','prem_segment','offer_length_dtv','time_to_offer_end_dtv','time_since_last_ta_call','time_since_last_ab','previous_abs','days_since_last_payment_dt','days_since_last_payment_dt_binned','previous_ab_count_binned' ) ;
  set "Dynamic_SQL" = 'Alter table ' || "Output_Table_Name";
  set "Loop_Num" = 1;
  while "Loop_Num" <= (select "count"() from #Existing_Columns) loop
    set "Dynamic_SQL" = "Dynamic_SQL" || ' drop ' || (select "max"("column_name") from #Existing_Columns where "RowNum" = "Loop_Num") || ',';
    set "Loop_Num" = "Loop_Num"+1
  end loop;
  if "right"("Dynamic_SQL",1) = ',' then execute immediate "left"("Dynamic_SQL","len"("Dynamic_SQL")-1) end if;
  execute immediate 'Alter table ' || "Output_Table_Name" || ' Add ('
     || 'BB_Segment varchar(10) default null'
     || ',DTV_Tenure varchar(20) default null'
     || ',Affluence varchar(10) default null'
     || ',Package_Desc varchar(50) default null'
     || ',Prem_Segment varchar(10) default null'
     || ',Offer_Length_DTV varchar(30) default null'
     || ',Time_To_Offer_End_DTV varchar(30) default null'
     || ',Time_Since_Last_TA_call varchar(30) default null'
     || ',Time_Since_Last_AB varchar(30) default null'
     || ',Previous_AB_Count_Binned varchar(10) default null'
     || ',Days_Since_Last_Payment_Dt integer default null'
     || ',Days_Since_Last_Payment_Dt_Binned varchar(10) default null'
     || ');'
     || 'commit;'
     || 'Create lf index idx__1 on ' || "Output_Table_Name" || '(BB_Segment);'
     || 'Create lf index idx__2 on ' || "Output_Table_Name" || '(DTV_Tenure);'
     || 'Create lf index idx__3 on ' || "Output_Table_Name" || '(Affluence);'
     || 'Create lf index idx__4 on ' || "Output_Table_Name" || '(Package_Desc);'
     || 'Create lf index idx__5 on ' || "Output_Table_Name" || '(Prem_Segment);'
     || 'Create lf index idx__6 on ' || "Output_Table_Name" || '(Offer_Length_DTV);'
     || 'Create lf index idx__7 on ' || "Output_Table_Name" || '(Time_To_Offer_End_DTV);'
     || 'Create lf index idx__8 on ' || "Output_Table_Name" || '(Time_Since_Last_TA_call);'
     || 'Create lf index idx__9 on ' || "Output_Table_Name" || '(Time_Since_Last_AB);'
     || 'Create lf index idx__10 on ' || "Output_Table_Name" || '(Previous_AB_Count_Binned);'
     || 'Create lf index idx__11 on ' || "Output_Table_Name" || '(Days_Since_Last_Payment_Dt);'
     || 'Create lf index idx__12 on ' || "Output_Table_Name" || '(Days_Since_Last_Payment_Dt_Binned);';
  execute immediate
    ' Update ' || "Output_Table_Name" || ' Set'
     || '  BB_Segment = Case when BB_Active > 0 then ''BB'' else ''Non BB'' end '
     || ' ,DTV_Tenure = case '
     || '   when  Cast(end_date as integer)  < Cast(DTV_Last_Activation_Dt as integer)                          then ''New'' '
     || '   when  Cast(end_date as integer)  - Cast(DTV_Last_Activation_Dt as integer) <  round(365/12*1,0)     then ''M01'' '
     || '   when  Cast(end_date as integer)  - Cast(DTV_Last_Activation_Dt as integer) <  round(365/12*10,0)    then ''M10'' '
     || '   when  Cast(end_date as integer)  - Cast(DTV_Last_Activation_Dt as integer) <  round(365/12*14,0)    then ''M14'' '
     || '   when  Cast(end_date as integer)  - Cast(DTV_Last_Activation_Dt as integer) <  round(365/12*2*12,0)  then ''M24'' '
     || '   when  Cast(end_date as integer)  - Cast(DTV_Last_Activation_Dt as integer) <  round(365/12*3*12,0)  then ''Y03'' '
     || '   when  Cast(end_date as integer)  - Cast(DTV_Last_Activation_Dt as integer) <  round(365/12*5*12,0)  then ''Y05'' '
     || '   when  Cast(end_date as integer)  - Cast(DTV_Last_Activation_Dt as integer) >=  round(365/12*5*12,0) then ''Y05+'' '
     || ' end '
     || ' ,Affluence = h_affluence '
     || ' ,Package_Desc = Case when DTV_Product_Holding like ''Box Sets%'' then ''Family'' '
     || '         when DTV_Product_Holding like ''Sky Q%'' then ''SKY Q'' '
     || '         when DTV_Product_Holding like ''Variety%'' then ''Variety'' '
     || '         when DTV_Product_Holding like ''Original%'' then ''Original'' '
     || '         when DTV_Product_Holding like ''Sky Entertainment%'' then ''Sky Entertainment'' '
     || '   end'
     || ' ,Prem_Segment = Case when sports_Active > 0 and movies_Active > 0 then ''TopTier'' '
     || '       when sports_Active > 0                then ''Sports'' '
     || '       when movies_Active > 0                then ''Movies'' '
     || '       when DTV_Active > 0                   then ''Basic'' '
     || '  end '
     || ' ,Offer_Length_DTV = case '
     || '     when 1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 <= 3  then ''Offer Length 3M'' '
     || '     when (1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 >3) and (1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 <= 6) then ''Offer Length 6M'' '
     || '     when (1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 >6) and (1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 <= 9) then ''Offer Length 9M'' '
     || '     when (1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 >9) and (1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 <= 12) then ''Offer Length 12M'' '
     || '     when 1+ (Curr_Offer_Intended_end_Dt_DTV - Curr_Offer_Start_Dt_DTV) / 31 > 12  then ''Offer Length 12M +'' '
     || '     when Curr_Offer_Intended_end_Dt_DTV is null then ''No Offer'' '
     || '     when Curr_Offer_Start_Dt_DTV is null then ''No Offer'' '
     || '  end '
     || ' ,Time_To_Offer_End_DTV = case '
     || '     when Future_Dated_Offer_Start_Dt_DTV > Curr_Offer_Intended_end_Dt_DTV then ''Offer Ending in 7+ Wks'' '
     || '     when Curr_Offer_Intended_end_Dt_DTV between (end_date + 1) and (end_date + 7)   then ''Offer Ending in Next 1 Wks'' '
     || '     when Curr_Offer_Intended_end_Dt_DTV between (end_date + 8) and (end_date + 21)  then ''Offer Ending in Next 2-3 Wks'' '
     || '     when Curr_Offer_Intended_end_Dt_DTV between (end_date + 22) and (end_date + 42) then ''Offer Ending in Next 4-6 Wks'' '
     || '     when Curr_Offer_Intended_end_Dt_DTV > (end_date + 42)                           then ''Offer Ending in 7+ Wks'' '
     || '     when Prev_Offer_Actual_End_Dt_DTV between end_date - 6  and end_date      then ''Offer Ended in last 1 Wks'' '
     || '     when Prev_Offer_Actual_End_Dt_DTV between end_date - 20 and end_date - 7  then ''Offer Ended in last 2-3 Wks'' '
     || '     when Prev_Offer_Actual_End_Dt_DTV between end_date - 41 and end_date - 21 then ''Offer Ended in last 4-6 Wks'' '
     || '     when Prev_Offer_Actual_End_Dt_DTV between end_date-52*7 + 1 and end_date - 42 then ''Offer Ended 7+ Wks'' '
     || '     else ''No Offer End DTV'' '
     || '  end '
     || ' ,Time_Since_Last_TA_call = Case when last_TA_dt is null then ''No Prev TA Calls'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7  = 0 then ''0 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 = 1 then ''01 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 between 2 and 5 then ''02-05 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 between 6 and 35 then ''06-35 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 between 36 and 46 then ''36-46 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 = 47 then ''47 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 between 48 and 52 then ''48-52 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 between 53 and 60 then ''53-60 Wks since last TA Call'' '
     || '  when (Cast(end_date as integer) - Cast(last_TA_dt as integer))/7 > 60 then ''61+ Wks since last TA Call'' '
     || '  Else '''' '
     || ' End  '
     || ' ,Time_Since_Last_AB = Case when Coalesce(DTV_ABs_Ever,0) = 0 then ''N/A'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 = 0 then ''0 Wks'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <= 2 then ''1-2 Wks'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <= 4 then ''3-4 Wks'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=6 then ''5-6 Wks'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=7 then ''7 Wks'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=8 then ''8 Wks'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=11 then ''9-11 Wks'' '
     || '       when (Cast(end_date as integer) - Cast(DTV_Last_Active_Block_Dt as integer))/7 <=12 then ''12 Wks'' '
     || '       else ''13+ Wks'' '
     || '  end '
     || ' ,Previous_AB_Count_Binned = Case when DTV_ABs_Ever <= 5 then '''' || DTV_ABs_Ever '
     || '       when DTV_ABs_Ever <= 20 then ''6-20'' '
     || '       when DTV_ABs_Ever > 20 then ''21+'' '
     || '       else ''0'' '
     || ' end '
     || ' ,Days_Since_Last_Payment_Dt = Cast(end_date-Case when day(end_date) < payment_due_day_of_month '
     || '           then Cast('''' || year(dateadd(month,-1,end_date)) || ''-'' || month(dateadd(month,-1,end_date)) || ''-'' || payment_due_day_of_month as date) '
     || '      when day(end_date) >= payment_due_day_of_month '
     || '           then Cast('''' || year(end_date) || ''-'' || month(end_date) || ''-'' || payment_due_day_of_month as date) '
     || ' end as integer) ';
  execute immediate
    ' Update ' || "Output_Table_Name" || ' Set'
     || '            Days_Since_Last_Payment_Dt_Binned = Case'
     || '                         when Days_Since_Last_Payment_Dt > 16 then ''> 16'' '
     || '            else '''' || Days_Since_Last_Payment_Dt '
     || '            End '
end
