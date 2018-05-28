declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_dependency_subscriber');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create table l_plan.l_dependency_subscriber (dependency_id  number        not null,
                                             action_id      number        not null,
                                             description    varchar2(255))
tablespace l_plan;

comment on table l_plan.l_dependency_subscriber is '�������� �������� �� ����������� �����������';

comment on column l_plan.l_dependency_subscriber.dependency_id is 'ID �����������';
comment on column l_plan.l_dependency_subscriber.action_id     is 'ID ��������';
comment on column l_plan.l_dependency_subscriber.description   is '������� �������� ������������';
