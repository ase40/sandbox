create procedure "Decisioning_Procs"."Add_Churn_BB"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Field_Update_Type" varchar(30) default 'Drop and Replace', --'Rename and Replace','Update Only'
  in "Field_1" varchar(100) default null,
  in "Field_2" varchar(100) default null,
  in "Field_3" varchar(100) default null,
  in "Field_4" varchar(100) default null,
  in "Field_5" varchar(100) default null,
  in "Field_6" varchar(100) default null,
  in "Field_7" varchar(100) default null,
  in "Field_8" varchar(100) default null,
  in "Field_9" varchar(100) default null,
  in "Field_10" varchar(100) default null,
  in "Field_11" varchar(100) default null,
  in "Field_12" varchar(100) default null,
  in "Field_13" varchar(100) default null,
  in "Field_14" varchar(100) default null,
  in "Field_15" varchar(100) default null,
  in "Field_16" varchar(100) default null,
  in "Field_17" varchar(100) default null,
  in "Field_18" varchar(100) default null,
  in "Field_19" varchar(100) default null,
  in "Field_20" varchar(100) default null,
  in "Field_21" varchar(100) default null,
  in "Field_22" varchar(100) default null,
  in "Field_23" varchar(100) default null,
  in "Field_24" varchar(100) default null,
  in "Field_25" varchar(100) default null,
  in "Field_26" varchar(100) default null,
  in "Field_27" varchar(100) default null,
  in "Field_28" varchar(100) default null,
  in "Field_29" varchar(100) default null,
  in "Field_30" varchar(100) default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Product_Type" varchar(50);
  declare "Target_Table" varchar(50);
  declare "Dynamic_SQL_Start" long varchar;
  set "Product_Type" = 'BB';
  set "Target_Table" = 'CITeam.Churn_BB';
  set temporary option "Query_Temp_Space_Limit" = 0;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30");
  ------------------------------------------------------------------------------------------------------------
  -- 2. Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL_Start" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL_Start"
     || case when "LOWER"("Product_Type" || '_1st_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_1st_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Last_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Last_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Churn_Dt''' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Churn_Cust_Type''' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Churn_ProdPlat_Type''' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Next_Churn_Type''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_1D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_7D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_30D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_90D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_180D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_1Yr''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_3Yr''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Last_5Yr''' end
     || case when "LOWER"("Product_Type" || '_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_Ever''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Next_7D''' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''' || "Product_Type" || '_Churns_In_Next_30D''' end
     || ')';
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    execute immediate "Dynamic_SQL"
  end if;
  -- SELECT (Dynamic_SQL);
  ------------------------------------------------------------------------------------------------------------
  -- 3. Add columns
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ''
       || ' ALTER TABLE ' || "Output_Table_Name" || ' ADD('
       || case when "LOWER"("Product_Type" || '_1st_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Churn_Dt date default null,' end
       || case when "LOWER"("Product_Type" || '_Last_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Churn_Dt date default null,' end
       || case when "LOWER"("Product_Type" || '_Next_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Dt date default null,' end
       || case when "LOWER"("Product_Type" || '_Next_Churn_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Cust_Type varchar(20) default null,' end
       || case when "LOWER"("Product_Type" || '_Next_Churn_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_ProdPlat_Type varchar(10) default null,' end
       || case when "LOWER"("Product_Type" || '_Next_Churn_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Type varchar(20) default null,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1D tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_7D tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_30D tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_90D tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_180D tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1Yr tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_3Yr tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_5Yr tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_Ever tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_7D tinyint default 0,' end
       || case when "LOWER"("Product_Type" || '_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_30D tinyint default 0,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ------------------------------------------------------------------------------------------------------------
  -- 4. Select columns and insert into Temp table
  set "Dynamic_SQL" = 'DROP TABLE IF EXISTS #Prod_Churn';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ', '
     || ' MIN(case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _1st_Churn_Dt, '
     || ' MAX(case when trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _Last_Churn_Dt, '
     || ' MIN(case when trgt.event_dt > base.' || "Obs_Dt_Field" || ' then trgt.event_dt end) AS _Next_Churn_Dt, '
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt = base.' || "Obs_Dt_Field" || '  then 1 else 0 end) as _Churns_In_Last_1D,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 6 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_7D,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 29 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_30D,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 89 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_90D ,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' - 179 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_180D,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between dateadd(yy,-1,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_1Yr,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between dateadd(yy,-3,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_3Yr,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between dateadd(yy,-5,base.' || "Obs_Dt_Field" || ')+1 and base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_In_Last_5Yr,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt <= base.' || "Obs_Dt_Field" || ' then 1 else 0 end) as _Churns_Ever, '
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) as _Churns_In_Next_7D,'
     || ' sum(Case when trgt.BB_Subscriber_Churn > 0 and trgt.event_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 30 then 1 else 0 end) as _Churns_In_Next_30D'
     || ' INTO #Prod_Churn '
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || "Target_Table" || ' as Trgt '
     || '        ON Trgt.account_number = base.account_number '
    //|| '            AND Trgt.event_dt <= Base.' || Obs_Dt_Field || ' + 30 '
     || ' GROUP BY base.account_number,base.' || "Obs_Dt_Field" || ',trgt.Status_Code,trgt.Product_Holding ';
  execute immediate "Dynamic_SQL";
  //Select * into #Prod_Churn from Prod_Churn
  //Select * from #Prod_Churn
  ------------------------------------------------------------------------------------------------------------
  -- 5. Update output table
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_1st_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_1st_Churn_Dt   = trgt._1st_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Last_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Last_Churn_Dt   = trgt._Last_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Dt   = trgt._Next_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1D   = trgt._Churns_In_Last_1D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_7D   = trgt._Churns_In_Last_7D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_30D   = trgt._Churns_In_Last_30D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_90D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_90D   = trgt._Churns_In_Last_90D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_180D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_180D  = trgt._Churns_In_Last_180D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_1Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_1Yr   = trgt._Churns_In_Last_1Yr,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_3Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_3Yr   = trgt._Churns_In_Last_3Yr,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Last_5Yr') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Last_5Yr   = trgt._Churns_In_Last_5Yr,' end
     || case when "LOWER"("Product_Type" || '_Churns_Ever') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_Ever   = trgt._Churns_Ever,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_7D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_7D   = trgt._Churns_In_Next_7D,' end
     || case when "LOWER"("Product_Type" || '_Churns_In_Next_30D') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Churns_In_Next_30D   = trgt._Churns_In_Next_30D,' end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' FROM ' || "Output_Table_Name" || ' as base '
     || '        INNER JOIN '
     || '        #Prod_Churn as trgt '
     || ' ON trgt.account_number = base.account_number '
     || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field";
  execute immediate "Dynamic_SQL";
  -- Next PL Entry Details -----------------------------------------------------
  //Select top 1000 * from CITeam.Churn_BB
  //If BB_Cust_Type = 'All' and ProdPlat_Churn_Type = 'All' then
  //BEGIN
  drop table if exists #Next_Churn;
  set "Dynamic_SQL" = 'SELECT base.account_number,base.' || "Obs_Dt_Field" || ','
     || ' base._Next_Churn_Dt as BB_Next_Churn_Dt, '
     || ' trgt.BB_Cust_Type,trgt.ProdPlat_Churn_Type, '
     || ' Case when trgt.Enter_SysCan > 0 then ''Enter SysCan'' '
     || '      when trgt.Enter_CusCan > 0 then ''Enter CusCan'' '
     || '      when trgt.Enter_HM > 0 then ''Enter Home Move'' '
     || '      when trgt.Enter_3rd_Party > 0 then ''Enter 3rd Party'' '
     || ' end Churn_PL, '
     || ' Row_Number() over(partition by base.account_number,base.' || "Obs_Dt_Field" || ' order by trgt.event_dt desc) as Rnk '
     || ' INTO #Next_Churn '
     || ' FROM #Prod_Churn as base '
     || '        INNER JOIN '
     || '        CITeam.PL_Entries_BB as Trgt '
     || '        ON Trgt.account_number = base.account_number '
     || '            and Trgt.event_dt <= Base._Next_Churn_Dt '
     || '            and enter_cuscan+enter_syscan+enter_3rd_Party+Enter_HM > 0 ';
  execute immediate "Dynamic_SQL";
  //Select top 1000 * from #Next_Churn;
  set "Dynamic_SQL"
     = ' UPDATE ' || "Output_Table_Name" || ' AS base '
     || ' SET '
     || case when "LOWER"("Product_Type" || '_Next_Churn_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Dt   = trgt.BB_Next_Churn_Dt,' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Cust_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Cust_Type   = trgt.BB_Cust_Type,' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_ProdPlat_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_ProdPlat_Type   = trgt.ProdPlat_Churn_Type,' end
     || case when "LOWER"("Product_Type" || '_Next_Churn_Type') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then "Product_Type" || '_Next_Churn_Type   = trgt.Churn_PL,' end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' FROM ' || "Output_Table_Name" || ' as base '
       || '        INNER JOIN '
       || '        #Next_Churn as trgt '
       || ' ON trgt.account_number = base.account_number '
       || '    AND trgt.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' '
       || '    and trgt.Rnk = 1 ';
    execute immediate "Dynamic_SQL"
  //END;
  //End If;
  end if
end
