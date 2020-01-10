create procedure "ase40"."test_proc"()
begin
  drop table if exists "ase40"."t1";
  select 1 as "id",'abc' as "name","getdate"() as "runtime"
    into "ase40"."t1"
end
