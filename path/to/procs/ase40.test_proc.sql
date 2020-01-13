create procedure "ase40"."test_proc"()
begin
  drop table if exists "ase40"."t1";
  select 2 as "id",'abc' as "name","getdate"() as "runtime"
    into "ase40"."t1"
end
