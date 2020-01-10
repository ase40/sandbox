create procedure "Decisioning_Procs"."Add_Broadband_Postcode_Exchange_To_Base"( 
  in "Output_Table_Name" varchar(100),
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
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2","Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20");
  -- Delete fields
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
       || case when 'cb_address_postcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode''' end
       || case when 'country_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Country_Name''' end
       || case when 'government_region' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Government_Region''' end
       || case when 'local_authority_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Local_Authority_Name''' end
       || case when 'exchange_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Exchange_Name''' end
       || case when 'exchange_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Exchange_Status''' end
       || case when 'adsl_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''ADSL_Enabled''' end
       || case when 'broadband_average_demand' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''broadband_average_demand''' end
       || case when 'bt_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''bt_consumer_market_share''' end
       || case when 'sky_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''sky_consumer_market_share''' end
       || case when 'virgin_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''virgin_consumer_market_share''' end
       || case when 'talktalk_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''talktalk_consumer_market_share''' end
       || case when 'cable_postcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cable_postcode''' end
       || case when 'superfast_available_end_2013' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2013''' end
       || case when 'superfast_available_end_2014' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2014''' end
       || case when 'superfast_available_end_2015' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2015''' end
       || case when 'superfast_available_end_2016' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2016''' end
       || case when 'superfast_available_end_2017' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2017''' end
       || case when 'throughput_speed' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''throughput_speed''' end
       || ')';
    execute immediate "Dynamic_SQL"
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
       || case when 'cb_address_postcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cb_address_postcode''' end
       || case when 'country_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Country_Name''' end
       || case when 'government_region' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Government_Region''' end
       || case when 'local_authority_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Local_Authority_Name''' end
       || case when 'exchange_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Exchange_Name''' end
       || case when 'exchange_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Exchange_Status''' end
       || case when 'adsl_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''ADSL_Enabled''' end
       || case when 'broadband_average_demand' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''broadband_average_demand''' end
       || case when 'bt_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''bt_consumer_market_share''' end
       || case when 'sky_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''sky_consumer_market_share''' end
       || case when 'virgin_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''virgin_consumer_market_share''' end
       || case when 'talktalk_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''talktalk_consumer_market_share''' end
       || case when 'cable_postcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''cable_postcode''' end
       || case when 'superfast_available_end_2013' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2013''' end
       || case when 'superfast_available_end_2014' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2014''' end
       || case when 'superfast_available_end_2015' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2015''' end
       || case when 'superfast_available_end_2016' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2016''' end
       || case when 'superfast_available_end_2017' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''superfast_available_end_2017''' end
       || case when 'throughput_speed' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''throughput_speed''' end
       || ')';
    execute immediate "Dynamic_SQL"
  end if;
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL" = ' Alter Table ' || "Output_Table_Name" || ' Add('
       || case when 'country_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Country_Name varchar(150) default null null,' end
       || case when 'government_region' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Government_Region varchar(255) default null null,' end
       || case when 'local_authority_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Local_Authority_Name varchar(255) default null null,' end
       || case when 'exchange_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Exchange_Name varchar(100) default null null,' end
       || case when 'exchange_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Exchange_Status varchar(10) default null null,' end
       || case when 'adsl_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'ADSL_Enabled varchar(1) default null null,' end
       || case when 'broadband_average_demand' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Broadband_Average_Demand decimal(30,2) default null null,' end
       || case when 'bt_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'BT_Consumer_Market_Share decimal(30,2) default null null,' end
       || case when 'sky_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Sky_Consumer_Market_Share decimal(30,2) default null null,' end
       || case when 'virgin_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Virgin_Consumer_Market_Share decimal(30,2) default null null,' end
       || case when 'talktalk_consumer_market_Share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'TalkTalk_Consumer_Market_Share decimal(30,2) default null null,' end
       || case when 'cable_postcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Cable_Postcode varchar(1) default null null,' end
       || case when 'superfast_available_end_2013' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Superfast_Available_End_2013 decimal(30,2) default null null,' end
       || case when 'superfast_available_end_2014' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Superfast_Available_End_2014 decimal(30,2) default null null,' end
       || case when 'superfast_available_end_2015' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Superfast_Available_End_2015 decimal(30,2) default null null,' end
       || case when 'superfast_available_end_2016' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Superfast_Available_End_2016 decimal(30,2) default null null,' end
       || case when 'superfast_available_end_2017' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Superfast_Available_End_2017 decimal(30,2) default null null,' end
       || case when 'throughput_speed' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Throughput_Speed decimal(30,2) default null null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name" || ' as Base '
     || ' Set '
     || case when 'Country_Name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Country_Name = c.Country_Name,' end
     || case when 'government_region' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Government_Region = c.Government_Region,' end
     || case when 'local_authority_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Local_Authority_Name = c.LA_Name,' end
     || case when 'exchange_name' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Exchange_Name = c.Exchange_Name,' end
     || case when 'exchange_status' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Exchange_Status = c.Exchange_Status,' end
     || case when 'adsl_enabled' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' ADSL_Enabled = Upper(c.ADSL_Enabled),' end
     || case when 'broadband_average_demand' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Broadband_Average_Demand = c.Broadband_Average_Demand,' end
     || case when 'bt_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' BT_Consumer_Market_Share = c.BT_Consumer_Market_Share,' end
     || case when 'sky_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Sky_Consumer_Market_Share = c.Sky_Consumer_Market_Share,' end
     || case when 'virgin_consumer_market_share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Virgin_Consumer_Market_Share = c.Virgin_Consumer_Market_Share,' end
     || case when 'talktalk_consumer_market_Share' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' TalkTalk_Consumer_Market_Share = c.TalkTalk_Consumer_Market_Share,' end
     || case when 'cable_postcode' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Cable_Postcode = Upper(c.Cable_Postcode),' end
     || case when 'superfast_available_end_2013' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Superfast_Available_End_2013 = c.Superfast_Available_End_2013,' end
     || case when 'superfast_available_end_2014' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Superfast_Available_End_2014 = c.Superfast_Available_End_2014,' end
     || case when 'superfast_available_end_2015' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Superfast_Available_End_2015 = c.Superfast_Available_End_2015,' end
     || case when 'superfast_available_end_2016' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Superfast_Available_End_2016 = c.Superfast_Available_End_2016,' end
     || case when 'superfast_available_end_2017' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Superfast_Available_End_2017 = c.Superfast_Available_End_2017,' end
     || case when 'throughput_speed' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ' Throughput_Speed = c.Throughput_Speed,' end;
  set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
     || ' from ' || "Output_Table_Name" || ' as Base '
     || '     inner join'
     || '     cust_single_account_view sav'
     || '     on sav.account_number = base.account_number'
     || '     inner join '
     || '     broadband_postcode_exchange c '
     || '     on replace(c.cb_address_postcode, '' '','''') = replace(sav.cb_address_postcode,'' '','''') '; --get cable_postcode (should contain all postcodes);
  execute immediate "Dynamic_SQL"
end
