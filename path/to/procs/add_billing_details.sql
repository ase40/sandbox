create procedure "Decisioning_Procs"."Add_Billing_Details"( 
  in "Output_Table_Name" varchar(100),
  in "Obs_Dt_Field" varchar(100),
  in "Field_Update_Type" varchar(30) default 'Drop and Replace',
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
  "Where_Cond" long varchar default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  set temporary option "Query_Temp_Space_Limit" = 0;
  commit work;
  ------------------------------------------------------------------------------------------------------------
  -- 1. Get non NULL fields
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1",
      "Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10");
  ------------------------------------------------------------------------------------------------------------
  -- Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  set "Dynamic_SQL" = "Dynamic_SQL"
     || case when "LOWER"('Payment_Due_Day_of_Month') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Payment_Due_Day_of_Month''' end
     || case when "LOWER"('Last_Payment_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Last_Payment_Dt''' end
     || case when "LOWER"('Days_Since_Last_Payment_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Days_Since_Last_Payment_Dt''' end
     || case when "LOWER"('Bill_Day_Of_Month') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Bill_Day_Of_Month''' end
     || case when "LOWER"('Last_Bill_Date') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then ',''Last_Bill_Date''' end
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
       || case when "LOWER"('Payment_Due_Day_of_Month') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Payment_Due_Day_of_Month tinyint default null null,' end
       || case when "LOWER"('Last_Payment_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Last_Payment_Dt date default null null,' end
       || case when "LOWER"('Days_Since_Last_Payment_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Days_Since_Last_Payment_Dt tinyint default null null,' end
       || case when "LOWER"('Bill_Day_Of_Month') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Bill_Day_Of_Month tinyint default null null,' end
       || case when "LOWER"('Last_Bill_Date') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then 'Last_Bill_Date date default null null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  ----------------------------------------------------------
  -- Create table of distinct accounts and obs dts
  ----------------------------------------------------------
  execute immediate 'Select distinct account_number, ' || "Obs_Dt_Field" || ' into #Acc_Obs_Dts from ' || "Output_Table_Name" || ' ' || case when "Where_Cond" is not null then ' Where ' end || "Where_Cond" || ' ' || ';';
  commit work;
  create hg index "idx_1" on #Acc_Obs_Dts("Account_number");
  execute immediate 'create date index idx_2 on #Acc_Obs_Dts(' || "Obs_Dt_Field" || ');';
  -------------------------------------------------------------
  -- Part 1- payment_due_dt for last 5 months bills --
  -------------------------------------------------------------
  set "Dynamic_SQL" = ''
     || ' Select base.account_number, '
     || '       base.' || "Obs_Dt_Field" || ', '
     || '       DAY(bills.payment_due_dt) as payment_due_day_of_month, ' --select day of month
     || '       count(payment_due_day_of_month) as payment_due_day_counts, ' -- count how many times each day is encountered
     || '       Row_number() over(partition by base.account_number, base.' || "Obs_Dt_Field" || ' order by payment_due_day_counts desc) payment_due_day_Rnk ' --rank dates starting with mode
     || ' into #payment_due_day_of_month '
     || ' from #Acc_Obs_Dts as base '
     || '     inner join '
     || '     cust_bills as bills '
     || '     on base.account_number= bills.account_number '
     || '            and payment_due_dt between base.' || "Obs_Dt_Field" || '-5*31 and base.' || "Obs_Dt_Field" || ' ' --select month days from last 5 month's bills
     || ' group by base.account_number, base.' || "Obs_Dt_Field" || ', payment_due_day_of_month ';
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #payment_due_day_of_month("Account_number");
  set "Dynamic_SQL" = 'create date index idx_2 on #payment_due_day_of_month(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create lf index "idx_3" on #payment_due_day_of_month("payment_due_day_Rnk");
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as base '
     || ' Set '
     || case when "LOWER"('payment_due_day_of_month') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then
      'payment_due_day_of_month   = source.payment_due_day_of_month,'
    end
     || case when "LOWER"('Last_Payment_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then
      'Last_Payment_Dt   = '
       || '    Case when day(base.' || "Obs_Dt_Field" || ') < source.payment_due_day_of_month '
       || '           then Cast('''' || year(dateadd(month,-1,base.' || "Obs_Dt_Field" || ')) || ''-'' || month(dateadd(month,-1,base.' || "Obs_Dt_Field" || ')) || ''-'' || source.payment_due_day_of_month as date) '
       || '         when day(base.' || "Obs_Dt_Field" || ') >= source.payment_due_day_of_month '
       || '           then Cast('''' || year(base.' || "Obs_Dt_Field" || ') || ''-'' || month(base.' || "Obs_Dt_Field" || ') || ''-'' || source.payment_due_day_of_month as date) '
       || '    end,'
    end
     || case when "LOWER"('Days_Since_Last_Payment_Dt') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then
      'Days_Since_Last_Payment_Dt   = '
       || '    Cast(base.' || "Obs_Dt_Field" || '- Case when day(base.' || "Obs_Dt_Field" || ') < source.payment_due_day_of_month '
       || '           then Cast('''' || year(dateadd(month,-1,base.' || "Obs_Dt_Field" || ')) || ''-'' || month(dateadd(month,-1,base.' || "Obs_Dt_Field" || ')) || ''-'' || source.payment_due_day_of_month as date) '
       || '           when day(base.' || "Obs_Dt_Field" || ') >= source.payment_due_day_of_month '
       || '           then Cast('''' || year(base.' || "Obs_Dt_Field" || ') || ''-'' || month(base.' || "Obs_Dt_Field" || ') || ''-'' || source.payment_due_day_of_month as date) '
       || '    end as integer),'
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base '
       || '      inner join '
       || '      #payment_due_day_of_month source '
       || '      on source.account_number = base.account_number '
       || '         and source.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' '
       || '         and source.payment_due_day_Rnk=1 '
       || case when "Where_Cond" is not null then ' Where base.' end || "Where_Cond";
    execute immediate "Dynamic_SQL"
  end if;
  -------------------------------------------------------------
  -- Part 2- Billing Date for last 5 Months --
  -------------------------------------------------------------
  set "Dynamic_SQL" = ''
     || ' Select base.account_number, '
     || '        base.' || "Obs_Dt_Field" || ', '
     || '        DAY(bills.created_dt) as bill_day_of_month, ' --select day of month
     || '        count(bill_day_of_month) as bill_day_counts, ' -- count how many times each day is encountered
     || '        Row_number() over(partition by base.account_number, base.' || "Obs_Dt_Field" || ' order by bill_day_counts desc) bill_day_Rnk ' --rank dates starting with mode
     || ' into #bill_day_of_month '
     || ' from #Acc_Obs_Dts as base '
     || '      inner join '
     || '      cust_bills as bills '
     || '    on base.account_number= bills.account_number '
     || '             and bills.created_dt between base.' || "Obs_Dt_Field" || '-5*31 and base.' || "Obs_Dt_Field" || ' ' --select month days from last 5 month's bills
     || ' group by base.account_number, base.' || "Obs_Dt_Field" || ', bill_day_of_month ';
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #bill_day_of_month("Account_number");
  set "Dynamic_SQL" = 'create date index idx_2 on #bill_day_of_month(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create lf index "idx_3" on #bill_day_of_month("bill_day_Rnk");
  set "Dynamic_SQL" = ''
     || ' Select base.account_number, '
     || '        base.' || "Obs_Dt_Field" || ', '
     || '        MAX(bills.created_dt) as last_bill_date  ' --select bill date
     || ' into #last_bill_date '
     || ' from #Acc_Obs_Dts as base '
     || '      inner join '
     || '      cust_bills as bills '
     || '    on base.account_number= bills.account_number '
     || '             and created_dt  < base.' || "Obs_Dt_Field" || '  ' --select bills on or before observation date
     || ' group by base.account_number, base.' || "Obs_Dt_Field" || ' ';
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #last_bill_date("account_number");
  set "Dynamic_SQL" = 'create date index idx_2 on #last_bill_date(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as base '
     || ' Set '
     || case when "LOWER"('Bill_Day_Of_Month') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then
      'Bill_Day_Of_Month   = source.bill_day_of_month,'
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base '
       || '      inner join '
       || '      #bill_day_of_month source '
       || '      on source.account_number = base.account_number '
       || '         and source.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' '
       || '         and source.bill_day_Rnk=1 '
       || case when "Where_Cond" is not null then ' Where base.' end || "Where_Cond";
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as base '
     || ' Set '
     || case when "LOWER"('Last_Bill_Date') = any(select "LOWER"("update_fields") from #update_fields) or "field_1" is null then
      'Last_Bill_Date   = source.Last_Bill_Date,'
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base '
       || '      inner join '
       || '      #last_bill_date source '
       || '      on source.account_number = base.account_number '
       || '         and source.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field" || ' '
       || case when "Where_Cond" is not null then ' Where base.' end || "Where_Cond";
    execute immediate "Dynamic_SQL"
  end if
end
