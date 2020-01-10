create procedure "Decisioning_procs"."Add_Software_Orders"( 
  in "Output_Table_Name" varchar(100),
  in "Observation_Dt" varchar(100),
  in "Prod_Type" varchar(100),
  in "Inc_Regrades" varchar(100) default 'Exclude Regrades', -- 'Include Regrades'
  in "Join_On" varchar(100) default 'Account_Number', -- Order_ID
  in "Where_Cond" varchar(250) default null,
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
  declare "Added_Cond" varchar(100);
  declare "Added_Cnt" varchar(100);
  declare "Removed_Cond" varchar(100);
  declare "Removed_Cnt" varchar(100);
  declare "Xtra_Cond" varchar(100);
  set temporary option "Query_Temp_Space_Limit" = 0;
  select * into #Update_Fields from "Decisioning_procs"."Temp_Update_Fields_Table"(
      "Field_1","Field_2", --)
      "Field_3","Field_4","Field_5","Field_6","Field_7","Field_8","Field_9","Field_10",
      "Field_11","Field_12","Field_13","Field_14","Field_15","Field_16","Field_17","Field_18","Field_19","Field_20",
      "Field_21","Field_22","Field_23","Field_24","Field_25","Field_26","Field_27","Field_28","Field_29","Field_30");
  -- Select * from #Update_Fields
  set "prod_type"
     = case when "str_replace"("lower"("prod_type"),' ','_') in( 'dtv','dtv_primary_viewing' ) then 'DTV'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'bb','broadband' ) then 'BB'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'bb_fibre_cap','fibre_cap','bb_fibre_capped','fibre_capped' ) then 'BB_Fibre_Cap'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'bb_fibre_unlimited','fibre_unlimited' ) then 'BB_Fibre_Unlimited'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'bb_fibre_unlimited_pro','fibre_unlimited_pro' ) then 'BB_Fibre_Unlimited_Pro'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'bb_lite' ) then 'BB_Lite'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'bb_unlimited' ) then 'BB_Unlimited'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'sports' ) then 'Sports'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'movies','cinema' ) then 'Movies'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'family' ) then 'FAMILY'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'hd basic','hd_basic' ) then 'HD_BASIC'
    --         when str_replace(lower(prod_type),' ','_') in ('bb_fibre_capped','fibre_capped') then 'HD_LEGACY'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'hd_premium','hd_pack','hd_sports' ) then 'HD_PREMIUM'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'sky_mobile_1gb_data_addon' ) then 'SKY_MOBILE_1GB_DATA_ADDON'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'sky_mobile_handset' ) then 'SKY_MOBILE_HANDSET'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'sky_mobile_international_addon' ) then 'SKY_MOBILE_INTERNATIONAL_ADDON'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'sky_mobile_talk_text_mobile' ) then 'SKY_MOBILE_TALK_TEXT_ADDON'
    when "str_replace"("lower"("prod_type"),' ','_') in( 'sky_mobile','sky _mobile_tariffs','mobile','mobile_subs' ) then 'SKY_MOBILE_TARIFFS'
    when "str_replace"("upper"("prod_type"),' ','_') in( 'MS+','MS_+''MULTISCREEN_PLUS_ADDED' ) then 'MULTISCREEN_PLUS'
    when "str_replace"("upper"("prod_type"),' ','_') in( 'MS','MULTISCREEN' ) then 'MULTISCREEN'
    when "str_replace"("upper"("prod_type"),' ','_') in( 'KIDS','SKYKIDS','SKY KIDS' ) then 'KIDS'
    when "str_replace"("upper"("prod_type"),' ','_') in( 'BOXSETS','SKYBOXSETS' ) then 'BOXSETS'
    when "str_replace"("upper"("prod_type"),' ','_') in( 'UOD' ) then 'UOD' end;
  if "Field_Update_Type" = 'Drop and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_Procs.Drop_Fields(''' || "Output_Table_Name" || ''''
  elseif "Field_Update_Type" = 'Rename and Replace' then
    set "Dynamic_SQL" = 'Call Decisioning_procs.Rename_Table_Fields(''' || "Output_Table_Name" || ''''
  end if;
  -- Delete fields
  set "Dynamic_SQL" = "Dynamic_SQL"
     || case when '_1st_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''_1st_order_' || "Prod_Type" || '_added_dt''' end
     || case when 'last_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''last_order_' || "Prod_Type" || '_added_dt''' end
     || case when 'next_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''next_order_' || "Prod_Type" || '_added_dt''' end
     || case when "Prod_Type" in( 'DTV','BB' ) 
    and 'last_order_' || "lower"("Prod_Type") || '_product_added' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''last_order_' || "Prod_Type" || '_product_added'''
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Next_60d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Next_30d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Next_7d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Next_24hrs''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Last_24hrs''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Last_7d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Last_30d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Last_60d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_90d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Last_90d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_180d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Last_180d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_1yr' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Added_In_Last_1yr''' end
     || case when '_1st_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''_1st_order_' || "Prod_Type" || '_removed_dt''' end
     || case when 'last_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''last_order_' || "Prod_Type" || '_removed_dt''' end
     || case when 'next_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''next_order_' || "Prod_Type" || '_removed_dt''' end
     || case when "Prod_Type" in( 'DTV','BB' ) 
    and 'last_order_' || "lower"("Prod_Type") || '_product_removed' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''last_order_' || "Prod_Type" || '_product_removed'''
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Next_60d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Next_30d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Next_7d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Next_24hrs''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Last_24hrs''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Last_7d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Last_30d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Last_60d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_90d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Last_90d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_180d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Last_180d''' end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_1yr' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then ',''Order_' || "Prod_Type" || '_Removed_In_Last_1yr''' end
     || ')';
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    execute immediate "Dynamic_SQL"
  end if;
  -- Add Fields
  if "Field_Update_Type" in( 'Drop and Replace','Rename and Replace' ) then
    set "Dynamic_SQL"
       = ' Alter table ' || "Output_Table_Name"
       || ' Add( '
       || case when '_1st_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_Order_' || "Prod_Type" || '_Added_Dt date default null,' end
       || case when 'last_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_Order_' || "Prod_Type" || '_Added_Dt date default null,' end
       || case when 'next_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Next_Order_' || "Prod_Type" || '_Added_Dt date default null,' end
       || case when "Prod_Type" in( 'DTV','BB' ) and 'last_order_' || "lower"("Prod_Type") || '_product_added' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_Order_' || "Prod_Type" || '_Product_Added varchar(80) default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Next_60d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Next_30d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Next_7d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Next_24hrs tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Last_24hrs tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Last_7d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Last_30d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Last_60d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_90d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Last_90d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_180d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Last_180d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_1yr' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Added_In_Last_1yr tinyint default null,' end
       || case when '_1st_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then '_1st_Order_' || "Prod_Type" || '_Removed_Dt date default null,' end
       || case when 'last_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_Order_' || "Prod_Type" || '_Removed_Dt date default null,' end
       || case when 'next_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Next_Order_' || "Prod_Type" || '_Removed_Dt date default null,' end
       || case when "Prod_Type" in( 'DTV','BB' ) and 'last_order_' || "lower"("Prod_Type") || '_product_removed' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Last_Order_' || "Prod_Type" || '_Product_Removed varchar(80) default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Next_60d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Next_30d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Next_7d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Next_24hrs tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Last_24hrs tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Last_7d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Last_30d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Last_60d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_90d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Last_90d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_180d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Last_180d tinyint default null,' end
       || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_1yr' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then 'Order_' || "Prod_Type" || '_Removed_In_Last_1yr tinyint default null,' end;
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1) || ')';
    execute immediate "Dynamic_SQL"
  end if;
  -- Select Dynamic_SQL
  if "Inc_Regrades" = 'Exclude Regrades' then
    set "Added_Cond" = ' and os.' || "Prod_Type" || '_Added > 0 ';
    set "Added_Cnt" = ' then os.' || "Prod_Type" || '_Added else 0 ';
    set "Removed_Cond" = ' and os.' || "Prod_Type" || '_Removed > 0 ';
    set "Removed_Cnt" = ' then os.' || "Prod_Type" || '_Removed else 0 '
  elseif "Inc_Regrades" = 'Include Regrades' and "Prod_Type" in( 'DTV','BB' ) then
    set "Added_Cond" = ' and os.' || "Prod_Type" || '_Added_Product is not null ';
    set "Added_Cnt" = ' then Case when os.' || "Prod_Type" || '_Added_Product is not null then 1 else 0 end else 0 ';
    set "Removed_Cond" = ' and os.' || "Prod_Type" || '_Removed_Product is not null ';
    set "Removed_Cnt" = ' then Case when os.' || "Prod_Type" || '_Removed_Product is not null then 1 else 0 end else 0 '
  else
    return
  end if;
  set "Xtra_Cond" = case "prod_type" when 'Sports' then 'os.Sports_Added != os.sports_removed and '
    when 'Movies' then 'os.movies_Added != os.movies_removed and ' end;
  ----------------------------------------------------------
  -- Create table of distinct accounts and obs dts
  ----------------------------------------------------------
  drop table if exists #Acc_Obs_Dts;
  execute immediate 'Select distinct account_number, '
     || "Observation_Dt"
     || ' into #Acc_Obs_Dts '
     || ' from ' || "Output_Table_Name" || ' '
     || case when "Where_Cond" is not null then ' Where ' end || "Where_Cond" || ' ' || ';';
  commit work;
  create hg index "idx_1" on #Acc_Obs_Dts("Account_number");
  execute immediate 'create date index idx_2 on #Acc_Obs_Dts(' || "Observation_Dt" || ');';
  ----------------------------------------------------------
  -- Create software orders data
  ----------------------------------------------------------
  set "Dynamic_SQL" = ''
     || ' Select '
     || case when "Join_On" = 'Account_Number' then ' base.account_number,base.' || "Observation_Dt"
    when "Join_On" = 'Order_ID' then ' base.order_id' end
     || ' , min(Case when ' || "Xtra_Cond" || ' os.order_dt <= base.' || "Observation_Dt" || "Added_Cond" || ' then os.order_dt end) as _1st_Order_Added_Dt '
     || ' , max(Case when ' || "Xtra_Cond" || ' os.order_dt <= base.' || "Observation_Dt" || "Added_Cond" || ' then os.order_dt end) as _Last_Order_Added_Dt '
     || ' , max(Case when ' || "Xtra_Cond" || ' os.order_dt > base.' || "Observation_Dt" || "Added_Cond" || ' then os.order_dt end) as _Next_Order_Added_Dt '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 60 ' || "Added_Cnt" || ' end) as Added_Next_60d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 30 ' || "Added_Cnt" || ' end) as Added_Next_30d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 7 ' || "Added_Cnt" || ' end) as Added_Next_7d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 1 ' || "Added_Cnt" || ' end) as Added_Next_24hrs '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' and base.' || "Observation_Dt" || "Added_Cnt" || ' end) as Added_Last_24hrs '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 6 and base.' || "Observation_Dt" || "Added_Cnt" || ' end) as Added_Last_7d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 29 and base.' || "Observation_Dt" || "Added_Cnt" || ' end) as Added_Last_30d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 59 and base.' || "Observation_Dt" || "Added_Cnt" || ' end) as Added_Last_60d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 89 and base.' || "Observation_Dt" || "Added_Cnt" || ' end) as Added_Last_90d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 179 and base.' || "Observation_Dt" || "Added_Cnt" || ' end) as Added_Last_180d '
     || ' , min(Case when ' || "Xtra_Cond" || ' os.order_dt <= base.' || "Observation_Dt" || "Removed_Cond" || ' then os.order_dt end) as _1st_Order_Removed_Dt '
     || ' , max(Case when ' || "Xtra_Cond" || ' os.order_dt <= base.' || "Observation_Dt" || "Removed_Cond" || ' then os.order_dt end) as _Last_Order_Removed_Dt '
     || ' , max(Case when ' || "Xtra_Cond" || ' os.order_dt > base.' || "Observation_Dt" || "Removed_Cond" || ' then os.order_dt end) as _Next_Order_Removed_Dt '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 60 ' || "Removed_Cnt" || ' end) as Removed_Next_60d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 30 ' || "Removed_Cnt" || ' end) as Removed_Next_30d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 7 ' || "Removed_Cnt" || ' end) as Removed_Next_7d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' + 1 and base.' || "Observation_Dt" || ' + 1 ' || "Removed_Cnt" || ' end) as Removed_Next_24hrs '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' and base.' || "Observation_Dt" || "Removed_Cnt" || ' end) as Removed_Last_24hrs '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 6 and base.' || "Observation_Dt" || "Removed_Cnt" || ' end) as Removed_Last_7d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 29 and base.' || "Observation_Dt" || "Removed_Cnt" || ' end) as Removed_Last_30d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 59 and base.' || "Observation_Dt" || "Removed_Cnt" || ' end) as Removed_Last_60d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 89 and base.' || "Observation_Dt" || "Removed_Cnt" || ' end) as Removed_Last_90d '
     || ' , sum(Case when ' || "Xtra_Cond" || ' os.order_dt between base.' || "Observation_Dt" || ' - 179 and base.' || "Observation_Dt" || "Removed_Cnt" || ' end) as Removed_Last_180d '
     || ' into #Software_Orders '
     || ' from #Acc_Obs_Dts as Base '
     || '      left join '
     || '      CITeam.Orders_Daily os '
     || '      on '
     || case when "Join_On" = 'Account_Number' then 'os.account_number  = Base.account_number '
    --                         || ' AND os.ORDER_DT between base.' || Observation_Dt || ' - 365'  || ' and base.' || Observation_Dt || ' + 30 '
    when "Join_On" = 'Order_ID' then 'os.order_id  = Base.order_id ' end
     || "Where_Cond"
     || case when "Join_On" = 'Account_Number' then ' group by base.account_number,base.' || "Observation_Dt"
    when "Join_On" = 'Order_ID' then ' group by Base.order_id' end;
  execute immediate "Dynamic_SQL";
  commit work;
  create hg index "idx1" on #Software_Orders("account_number");
  execute immediate 'create date index idx2 on #Software_Orders(' || "Observation_Dt" || ');';
  -- Select top 100 * from Decisioning.Orders_Daily
  set "Dynamic_SQL" = ''
     || ' Update ' || "Output_Table_Name"
     || ' Set '
     || case when '_1st_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      '_1st_Order_' || "Prod_Type" || '_Added_Dt = so._1st_Order_Added_Dt,'
    end
     || case when 'last_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'last_Order_' || "Prod_Type" || '_Added_Dt = so._last_Order_Added_Dt,'
    end
     || case when 'next_order_' || "lower"("Prod_Type") || '_added_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'next_Order_' || "Prod_Type" || '_Added_Dt = so._Next_Order_Added_Dt,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Next_60d = so.Added_Next_60d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Next_30d = so.Added_Next_30d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Next_7d = so.Added_Next_7d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_next_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Next_24hrs = so.Added_Next_24hrs,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Last_24hrs = so.Added_Last_24hrs,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Last_7d = so.Added_Last_7d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Last_30d = so.Added_Last_30d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Last_60d = so.Added_Last_60d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_90d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Last_90d = so.Added_Last_90d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_added_in_last_180d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Added_In_Last_180d = so.Added_Last_180d,'
    end
     || case when '_1st_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      '_1st_Order_' || "Prod_Type" || '_Removed_Dt = so._1st_Order_Removed_Dt,'
    end
     || case when 'last_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'last_Order_' || "Prod_Type" || '_Removed_Dt = so._last_Order_Removed_Dt,'
    end
     || case when 'next_order_' || "lower"("Prod_Type") || '_removed_dt' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'next_Order_' || "Prod_Type" || '_Removed_Dt = so._Next_Order_Removed_Dt,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Next_60d = so.Removed_Next_60d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Next_30d = so.Removed_Next_30d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Next_7d = so.Removed_Next_7d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_next_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Next_24hrs = so.Removed_Next_24hrs,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_24hrs' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Last_24hrs = so.Removed_Last_24hrs,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_7d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Last_7d = so.Removed_Last_7d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_30d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Last_30d = so.Removed_Last_30d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_60d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Last_60d = so.Removed_Last_60d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_90d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Last_90d = so.Removed_Last_90d,'
    end
     || case when 'order_' || "lower"("Prod_Type") || '_removed_in_last_180d' = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
      'Order_' || "Prod_Type" || '_Removed_In_Last_180d = so.Removed_Last_180d,'
    end;
  if "right"("Dynamic_SQL",1) = ',' then
    set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
       || ' from ' || "Output_Table_Name" || ' as base'
       || '     inner join'
       || '     #Software_Orders so '
       || '      on '
       || case when "Join_On" = 'Account_Number' then 'so.account_number  = Base.account_number '
         || ' AND so.' || "Observation_Dt" || ' = base.' || "Observation_Dt"
      when "Join_On" = 'Order_ID' then 'so.order_id  = Base.order_id ' end;
    execute immediate "Dynamic_SQL"
  -- select dynamic_sql
  end if;
  if "Prod_Type" in( 'DTV','BB' ) then
    set "Dynamic_SQL"
       = ' Select so.account_number,so.' || "Observation_Dt" || ',od.order_dt,od.Order_ID '
       || '       ,Case when od.order_dt = so._Last_Order_Removed_Dt then 1 else 0 end as Last_Order_Removed '
       || '       ,Case when od.order_dt = so._Last_Order_Added_Dt then 1 else 0 end as Last_Order_Added '
       || '       ,od.' || "Prod_Type" || '_Added_Product as Last_Added_Product '
       || '       ,od.' || "Prod_Type" || '_Removed_Product as Last_Removed_Product '
       || ' into #Products_Orders '
       || ' from #Software_Orders so '
       || '      inner join '
       || '      CITeam.Orders_Daily od '
       || '      on od.account_number = so.account_number '
       || '         and (od.order_dt = so._Last_Order_Added_Dt or od.order_dt = so._Last_Order_Removed_Dt) ';
    execute immediate "Dynamic_SQL";
    commit work;
    create hg index "idx_1" on #Products_Orders("Account_Number");
    execute immediate 'create date index idx_2 on #Products_Orders(' || "Observation_Dt" || ')';
    create hg index "idx_3" on #Products_Orders("Order_ID");
    set "Dynamic_SQL" = ''
       || ' Update ' || "Output_Table_Name"
       || ' Set '
       || case when "Prod_Type" in( 'DTV','BB' ) 
      and "Lower"('last_order_' || "Prod_Type" || '_Product_Added') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
        'Last_Order_' || "Prod_Type" || '_Product_Added = so.Last_Added_Product,'
      end;
    if "right"("Dynamic_SQL",1) = ',' then
      set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
         || ' from ' || "Output_Table_Name" || ' as base'
         || '     inner join'
         || '     #Products_Orders so '
         || '      on '
         || case when "Join_On" = 'Account_Number' then 'so.account_number  = Base.account_number '
           || ' AND so.' || "Observation_Dt" || ' = base.' || "Observation_Dt"
        when "Join_On" = 'Order_ID' then 'so.order_id  = Base.order_id ' end
         || ' AND Last_Order_Added = 1 ';
      execute immediate "Dynamic_SQL"
    -- select dynamic_sql
    end if;
    set "Dynamic_SQL" = ''
       || ' Update ' || "Output_Table_Name"
       || ' Set '
       || case when "Prod_Type" in( 'DTV','BB' ) 
      and "Lower"('last_order_' || "Prod_Type" || '_Product_Removed') = any(select "lower"("Update_Fields") from #Update_Fields) or "Field_1" is null then
        'Last_Order_' || "Prod_Type" || '_Product_Removed = so.Last_Removed_Product,'
      end;
    if "right"("Dynamic_SQL",1) = ',' then
      set "Dynamic_SQL" = "substr"("Dynamic_SQL",1,"len"("Dynamic_SQL")-1)
         || ' from ' || "Output_Table_Name" || ' as base'
         || '     inner join'
         || '     #Products_Orders so '
         || '      on '
         || case when "Join_On" = 'Account_Number' then 'so.account_number  = Base.account_number '
           || ' AND so.' || "Observation_Dt" || ' = base.' || "Observation_Dt"
        when "Join_On" = 'Order_ID' then 'so.order_id  = Base.order_id ' end
         || ' AND Last_Order_Removed = 1 ';
      execute immediate "Dynamic_SQL"
    -- select dynamic_sql
    end if
  end if
end
