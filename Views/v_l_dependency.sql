declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.v_l_dependency');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create or replace view l_plan.v_l_dependency (depend_type,
                                              depend_subscribe,
                                              depend_ccode,
                                              depend_desc,
                                              depend_action,
                                              depend_id)
as
    select typ.description      as depend_type,
           sub.description      as depend_subscribe,
           dep.dependency_ccode as depend_ccode,
           dep.description      as depend_desc,
           sub.action_id        as depend_action,
           dep.id               as depend_id
    from   l_plan.l_dependency dep
    inner join l_plan.l_dependency_type typ 
            on dep.type_id = typ.id
    left outer join l_plan.l_dependency_subscriber sub
                 on dep.id = sub.dependency_id;

comment on column l_plan.v_l_dependency.depend_type      is '������� �������� ���� �����������';
comment on column l_plan.v_l_dependency.depend_subscribe is '������� �������� ������������';
comment on column l_plan.v_l_dependency.depend_ccode     is '��� ����������� �� ������� <XXX>_<YYY>_<ZZZ>, ������ ������� �������';
comment on column l_plan.v_l_dependency.depend_desc      is '������� �������� �����������';
comment on column l_plan.v_l_dependency.depend_action    is 'ID ��������';
comment on column l_plan.v_l_dependency.depend_id        is 'ID �����������';
/