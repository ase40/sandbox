create procedure "Decisioning_Procs"."Create_Fcast_PC_Hist"( in "Output_Table_Name" varchar(100) ) 
sql security invoker
begin
  declare "Dynamic_SQL" long varchar;
  execute immediate 'Drop table if exists ' || (select current user) || '.Fcast_PC_Hist';
  set "Dynamic_SQL" = ''
     || ' Select MoR.Account_Number,MoR.Event_Dt PC_Dt '
     || ' into Fcast_PC_Hist '
     || ' from ' || "Output_Table_Name" || ' Base '
     || '      inner join '
     || '      CITeam.PL_Entries_DTV MoR '
     || '      on MoR.account_number = Base.Account_Number '
     || '         and MoR.Event_Dt between base.end_date - 50*30 and base.end_date '
     || '         and MoR.Same_Day_Cancel + MoR.PC_Pipeline_Cancellation > 0';
  execute immediate "Dynamic_SQL";
  commit work;
  execute immediate 'Create hg   index idx_1 on ' || (select current user) || '.Fcast_PC_Hist(account_number)';
  execute immediate 'Create date   index idx_2 on ' || (select current user) || '.Fcast_PC_Hist(PC_Dt)'
end
