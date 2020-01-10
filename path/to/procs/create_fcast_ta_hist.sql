create procedure "Decisioning_Procs"."Create_Fcast_TA_Hist"( in "Output_Table_Name" varchar(100) ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  execute immediate 'Drop table if exists ' || (select current user) || '.Fcast_TA_Hist';
  set "Dynamic_SQL" = ''
     || ' Select crr.Account_Number,crr.Event_Dt TA_Dt '
     || ' into Fcast_TA_Hist '
     || ' from ' || "Output_Table_Name" || ' Base '
     || '      inner join '
     || '      CITeam.Turnaround_Attempts crr '
     || '      on crr.account_number = Base.Account_Number '
     || '         and crr.Event_Dt between base.end_date - 380 and base.end_date '
     || '         and crr.Voice_Turnaround_Saved+Voice_Turnaround_Not_Saved > 0 ';
  execute immediate "Dynamic_SQL";
  commit work;
  execute immediate 'Create hg   index idx_1 on ' || (select current user) || '.Fcast_TA_Hist(account_number)';
  execute immediate 'Create date   index idx_2 on ' || (select current user) || '.Fcast_TA_Hist(TA_Dt)'
end
