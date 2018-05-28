declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_loading_plan');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create table l_plan.l_loading_plan (action_id       number         not null,
                                    comments        varchar2(4000),
                                    environment_id  number         not null,
                                    project_id      number         not null,
                                    db_um_id        number         not null,
                                    domain_id       number         not null,
                                    int_service_id  number         not null,
                                    run_id          number)
tablespace l_plan;

comment on table l_plan.l_loading_plan is '���� ��������';

comment on column l_plan.l_loading_plan.action_id      is '��������';
comment on column l_plan.l_loading_plan.comments       is '�����������';
comment on column l_plan.l_loading_plan.environment_id is 'ID �����';
comment on column l_plan.l_loading_plan.project_id     is 'ID �������';
comment on column l_plan.l_loading_plan.db_um_id       is 'ID �� ��';
comment on column l_plan.l_loading_plan.domain_id      is 'ID ������';
comment on column l_plan.l_loading_plan.int_service_id is 'ID ��������������� �������';
comment on column l_plan.l_loading_plan.run_id         is 'ID ������� � ������ �����';