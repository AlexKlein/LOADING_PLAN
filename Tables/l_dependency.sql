declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_dependency');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create table l_plan.l_dependency (id                number        not null,
                                  type_id           number        not null,
                                  dependency_ccode  varchar2(255),
                                  description       varchar2(255))
tablespace l_plan;

comment on table l_plan.l_dependency is '�������� ��������� ������������ ��� ��������';

comment on column l_plan.l_dependency.id               is 'ID �����������';
comment on column l_plan.l_dependency.type_id          is '��� �����������';
comment on column l_plan.l_dependency.dependency_ccode is '��� ����������� �� ������� <XXX>_<YYY>_<ZZZ>, ������ ������� �������';
comment on column l_plan.l_dependency.description      is '������� �������� �����������';

create unique index l_plan.dependency_pk_id on l_plan.l_dependency
(id)
tablespace l_plan;

alter table l_plan.l_dependency
add (constraint dependency_pk_id primary key (id) using index dependency_pk_id);

create or replace trigger l_plan.tr_l_dependency 
before insert
on l_plan.l_dependency 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_dependency;

    end if;

end;
/
