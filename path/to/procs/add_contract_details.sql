create procedure "Decisioning_Procs"."Add_Contract_Details"( in "Output_Table_Name" varchar(100),in "Obs_Dt_Field" varchar(100),in "Product_Type" varchar(80),
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
  in "Where_Cond" long varchar default null ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  declare "Target_Table" varchar(100);
  declare "Target_Table_Conditions" varchar(1000);
  declare "Addition_Val" varchar(100);
  declare "Existing_Activation_Val" varchar(100);
  declare "Prod_Reinstate_Val" varchar(100);
  declare "Plat_Reinstate_Val" varchar(100);
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10");
  set "Product_Type" = case "upper"("Product_Type")
    when 'DTV' then 'DTV'
    when 'DTV PRIMARY VIEWING' then 'DTV'
    when 'BROADBAND' then 'BB'
    when 'BB' then 'BB'
    when 'SKY TALK SELECT' then 'Talk'
    when 'TALK' then 'Talk' end;
  if "Product_Type" not in( 'DTV','BB','Talk' ) then
    return
  end if;
  -- Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when "lower"("Product_Type") || '_curr_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Curr_Contract_Start_Dt''' end
       || case when "lower"("Product_Type") || '_curr_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Curr_Contract_Intended_End_Dt''' end
       || case when "lower"("Product_Type") || '_prev_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Prev_Contract_Start_Dt''' end
       || case when "lower"("Product_Type") || '_prev_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Prev_Contract_Intended_End_Dt''' end
       || case when "lower"("Product_Type") || '_prev_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Prev_Contract_Actual_End_Dt''' end
       || case when "lower"("Product_Type") || '_next_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Next_Contract_Start_Dt''' end
       || case when "lower"("Product_Type") || '_next_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Next_Contract_Intended_End_Dt''' end
       || case when "lower"("Product_Type") || '_next_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Next_Contract_Actual_End_Dt''' end
       || case when "lower"("Product_Type") || '_contracts_applied_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_contracts_applied_in_next_7d''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when "lower"("Product_Type") || '_curr_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Curr_Contract_Start_Dt''' end
       || case when "lower"("Product_Type") || '_curr_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Curr_Contract_Intended_End_Dt''' end
       || case when "lower"("Product_Type") || '_prev_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Prev_Contract_Start_Dt''' end
       || case when "lower"("Product_Type") || '_prev_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Prev_Contract_Intended_End_Dt''' end
       || case when "lower"("Product_Type") || '_prev_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Prev_Contract_Actual_End_Dt''' end
       || case when "lower"("Product_Type") || '_next_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Next_Contract_Start_Dt''' end
       || case when "lower"("Product_Type") || '_next_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Next_Contract_Intended_End_Dt''' end
       || case when "lower"("Product_Type") || '_next_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_Next_Contract_Actual_End_Dt''' end
       || case when "lower"("Product_Type") || '_contracts_applied_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''' || "Product_Type" || '_contracts_applied_in_next_7d''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  -- Add Fields
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL"
       = ' Alter table ' || "Output_Table_Name"
       || ' Add( '
       || case when "lower"("Product_Type") || '_curr_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Curr_Contract_Start_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_curr_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Curr_Contract_Intended_End_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_prev_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Prev_Contract_Start_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_prev_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Prev_Contract_Intended_End_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_prev_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Prev_Contract_Actual_End_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_next_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Next_Contract_Start_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_next_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Next_Contract_Intended_End_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_next_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Next_Contract_Actual_End_Dt date default null null,' end
       || case when "lower"("Product_Type") || '_contracts_applied_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then "Product_Type" || '_Contracts_Applied_in_Next_7D smallint default 0 null,' end;
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
  ----------------------------------------------------------
  -- Contracts Applied
  ----------------------------------------------------------
  drop table if exists #Contracts_Applied;
  execute immediate
    'Select base.account_number,base.' || "Obs_Dt_Field" || ' '
     || '        ,sum(Case when con.created_dt between base.' || "Obs_Dt_Field" || ' + 1 and base.' || "Obs_Dt_Field" || ' + 7 then 1 else 0 end) Contracts_Applied_In_Next_7D '
     || ' into #Contracts_Applied '
     || ' from #Acc_Obs_Dts base '
     || '     inner join '
     || '     CITeam.Contracts con '
     || '     on con.account_number = base.account_number '
     || '        and con.subscription_type = ' || case "Product_Type"
    when 'DTV' then ' ''Primary DTV'' '
    when 'BB' then ' ''Broadband'' '
    when 'Talk' then ' ''Sky Talk'' ' end
     || ' group by base.account_number,base.' || "Obs_Dt_Field" || ' ';
  set "Dynamic_SQL"
     = ' Update ' || "Output_Table_Name" || ' as base '
     || ' Set '
     || case when "lower"("Product_Type") || '_contracts_applied_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_contracts_applied_in_next_7d = contract.Contracts_Applied_In_Next_7D,'
    else ''
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base '
       || '        inner join '
       || '        #Contracts_Applied contract '
       || '        on contract.account_number = base.account_number '
       || '            and base.' || "Obs_Dt_Field" || ' = contract.' || "Obs_Dt_Field"
       || case when "Where_Cond" is not null then ' Where base.' end || "Where_Cond";
    execute immediate "Dynamic_SQL"
  end if;
  ----------------------------------------------------------
  -- Product Contracts
  ----------------------------------------------------------
  set "Dynamic_SQL"
     = ' Update ' || "Output_Table_Name" || ' as base '
     || ' Set '
     || case when "lower"("Product_Type") || '_curr_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Curr_Contract_Start_Dt = contract.Start_Date,'
    else ''
    end
     || case when "lower"("Product_Type") || '_curr_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Curr_Contract_Intended_End_Dt = contract.Expected_Contract_End_Date,'
    else ''
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base '
       || '        inner join '
       || '        CITEAM.CONTRACTS contract '
       || '        on contract.account_number = base.account_number '
       || '            and base.' || "Obs_Dt_Field" || ' between contract.start_date and contract.Actual_Contract_End_Date - 1 '
       || '            and contract.subscription_type = ' || case "Product_Type"
      when 'DTV' then '''Primary DTV'''
      when 'BB' then '''Broadband'''
      when 'Talk' then '''Sky Talk''' end
       || case when "Where_Cond" is not null then ' Where base.' end || "Where_Cond";
    execute immediate "Dynamic_SQL"
  end if;
  -- Previous Contracts
  set "Dynamic_SQL"
     = ' Select base.account_number,base.' || "Obs_Dt_Field" || ', '
     || ' contract.Start_Date as Prev_Contract_Start_Dt, '
     || ' contract.Expected_Contract_End_Date as Prev_Contract_Intended_End_Dt, '
     || ' contract.Actual_Contract_End_Date as Prev_Contract_Actual_End_Dt, '
     || ' Row_Number() over(partition by base.account_number, base.' || "Obs_Dt_Field"
     || ' order by Prev_Contract_Actual_End_Dt desc,contract.Actual_Contract_End_Date desc) as Prev_Contract_Rnk '
     || ' into #Contracts '
     || ' from #Acc_Obs_Dts as base '
     || '        inner join '
     || '        CITEAM.CONTRACTS contract '
     || ' on contract.account_number = base.account_number '
     || '    and contract.Actual_Contract_End_Date <=  base.' || "Obs_Dt_Field"
     || '    and contract.subscription_type =  ' || case "Product_Type"
    when 'DTV' then '''Primary DTV'''
    when 'BB' then '''Broadband'''
    when 'Talk' then '''Sky Talk''' end;
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #Contracts("account_number");
  set "Dynamic_SQL" = 'create date index idx_2 on #Contracts(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create lf index "idx_3" on #Contracts("Prev_Contract_Rnk");
  set "Dynamic_SQL"
     = ' Update ' || "Output_Table_Name" || ' as base '
     || ' Set '
     || case when "lower"("Product_Type") || '_prev_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Prev_Contract_Start_Dt = contract.Prev_Contract_Start_Dt,'
    else ''
    end
     || case when "lower"("Product_Type") || '_prev_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_prev_contract_intended_end_dt = contract.Prev_Contract_Intended_End_Dt,'
    else ''
    end
     || case when "lower"("Product_Type") || '_prev_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Prev_Contract_Actual_End_Dt = contract.Prev_Contract_Actual_End_Dt,'
    else ''
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base '
       || '        inner join '
       || ' #Contracts contract '
       || ' on contract.account_number = base.account_number '
       || '    and contract.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    and contract.Prev_Contract_Rnk = 1 '
       || case when "Where_Cond" is not null then ' Where base.' end || "Where_Cond";
    execute immediate "Dynamic_SQL"
  end if;
  -- Next Contract
  set "Dynamic_SQL"
     = ' Select base.account_number,base.' || "Obs_Dt_Field" || ', '
     || ' contract.Start_Date as Next_Contract_Start_Dt, '
     || ' contract.Expected_Contract_End_Date as Next_Contract_Intended_End_Dt, '
     || ' contract.Actual_Contract_End_Date as Next_Contract_Actual_End_Dt, '
     || ' Row_Number() over(partition by base.account_number, base.' || "Obs_Dt_Field"
     || ' order by contract.Start_Date,contract.Expected_Contract_End_Date desc) as Next_Contract_Rnk '
     || ' into #Next_Contracts '
     || ' from #Acc_Obs_Dts as base '
     || '        inner join '
     || '        CITEAM.CONTRACTS contract '
     || ' on contract.account_number = base.account_number '
     || '    and contract.Start_Date >  base.' || "Obs_Dt_Field"
     || '    and contract.subscription_type =  ' || case "Product_Type"
    when 'DTV' then '''Primary DTV'''
    when 'BB' then '''Broadband'''
    when 'Talk' then '''Sky Talk''' end;
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx_1" on #Next_Contracts("account_number");
  set "Dynamic_SQL" = 'create date index idx_2 on #Next_Contracts(' || "Obs_Dt_Field" || ')';
  execute immediate "Dynamic_SQL";
  create lf index "idx_3" on #Next_Contracts("Next_Contract_Rnk");
  set "Dynamic_SQL"
     = ' Update ' || "Output_Table_Name" || ' as base '
     || ' Set '
     || case when "lower"("Product_Type") || '_next_contract_start_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_Next_Contract_Start_Dt = contract.Next_Contract_Start_Dt,'
    else ''
    end
     || case when "lower"("Product_Type") || '_next_contract_intended_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_next_contract_intended_end_dt = contract.next_Contract_Intended_End_Dt,'
    else ''
    end
     || case when "lower"("Product_Type") || '_next_contract_actual_end_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      "Product_Type" || '_next_Contract_Actual_End_Dt = contract.next_Contract_Actual_End_Dt,'
    else ''
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base '
       || '        inner join '
       || ' #Next_Contracts contract '
       || ' on contract.account_number = base.account_number '
       || '    and contract.' || "Obs_Dt_Field" || ' = base.' || "Obs_Dt_Field"
       || '    and contract.Next_Contract_Rnk = 1 '
       || case when "Where_Cond" is not null then ' Where base.' end || "Where_Cond";
    execute immediate "Dynamic_SQL"
  end if
end
