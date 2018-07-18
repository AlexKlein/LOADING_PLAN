declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.i_landscape_relation');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create table l_plan.i_landscape_relation (domain_id    number not null,
                                          landscape_id number not null)
tablespace l_plan;

comment on table l_plan.i_landscape_relation is '����� ������� � ����������';

comment on column l_plan.i_landscape_relation.domain_id    is 'ID ������';
comment on column l_plan.i_landscape_relation.landscape_id is 'ID �� ��';

create unique index l_plan.i_landscape_relation_pk on l_plan.i_landscape_relation
(domain_id,
 landscape_id)
tablespace l_plan;