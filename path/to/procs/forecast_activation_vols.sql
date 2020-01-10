create procedure "Decisioning_Procs"."Forecast_Activation_Vols"( in "Y2W01" integer,in "Y3W52" integer ) 
result( "Subs_Week_Of_Year" smallint,"Reinstates" integer,"Acquisitions" integer,"New_Customers" integer,"CusCan" integer ) 
sql security invoker
begin
  set temporary option "Query_Temp_Space_Limit" = 0;
  drop table if exists #Sky_Calendar;
  create table #Sky_Calendar(
    "calendar_date" date null,
    "subs_week_of_year" integer null,);
  create lf index "idx_1" on #Sky_Calendar("calendar_date");
  insert into #Sky_Calendar
    select "calendar_date","subs_week_of_year"
      from "sky_calendar"
      where "subs_week_and_year" between "Y2W01" and "Y3W52"
      and "subs_last_day_of_week" = 'Y'
      and "subs_week_of_year" <> 53;
  drop table if exists #Activation_Vols;
  select "end_date",
    cast(null as integer) as "Subs_Week_Of_Year",
    "sum"(case when "DTV_Last_Activation_Dt" between("end_date"-6) and "end_date" and "DTV_1st_Activation_Dt" < "DTV_Last_Activation_Dt" then 1 else 0 end) as "Reinstates",
    "sum"(case when "DTV_Last_Activation_Dt" between("end_date"-6) and "end_date" and("DTV_1st_Activation_Dt" = "DTV_Last_Activation_Dt") then 1 else 0 end) as "Acquisitions",
    "Reinstates"+"Acquisitions" as "New_Customers",
    "sum"("DTV_PO_Cancellations_In_Next_7D"+"DTV_SameDayCancels_In_Next_7D") as "CusCan"
    into #Activation_Vols
    from "citeam"."cust_weekly_Base" as "base" --_PoC base
    where "base"."end_date" = any(select "calendar_date" from #Sky_Calendar)
    group by "end_date";
  update #Activation_Vols as "av"
    set "subs_week_of_year" = "sc"."subs_week_of_year" from
    #Activation_Vols as "av"
    join #Sky_Calendar as "sc"
    on "sc"."calendar_date" = "av"."end_date";
  select "Subs_Week_Of_Year",
    "Avg"("Coalesce"("av"."Reinstates",0)) as "Reinstates",
    "Avg"("Coalesce"("av"."Acquisitions",0)) as "Acquisitions",
    "Avg"("Coalesce"("av"."New_Customers",0)) as "New_Customers",
    "Avg"("Coalesce"("av"."CusCan",0)) as "CusCan"
    from #Activation_Vols as "av"
    group by "Subs_Week_Of_Year"
end
