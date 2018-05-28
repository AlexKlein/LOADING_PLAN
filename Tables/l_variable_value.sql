declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_variable_value');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create table l_plan.l_variable_value (param_id        number        not null,
                                      param_value     varchar2(255) not null,
                                      environment_id  number        not null,
                                      project_id      number        not null,
                                      db_um_id        number        not null,
                                      domain_id       number        not null,
                                      int_service_id  number        not null)
tablespace l_plan;

comment on table l_plan.l_variable_value is '�������� ���������� � ������� ���������';

comment on column l_plan.l_variable_value.param_id       is 'ID ����������';
comment on column l_plan.l_variable_value.param_value    is '�������� ����������';
comment on column l_plan.l_variable_value.environment_id is 'ID �����';
comment on column l_plan.l_variable_value.project_id     is 'ID �������';
comment on column l_plan.l_variable_value.db_um_id       is 'ID �� ��';
comment on column l_plan.l_variable_value.domain_id      is 'ID ������';
comment on column l_plan.l_variable_value.int_service_id is 'ID ��������������� �������';