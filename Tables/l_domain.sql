declare
    object_not_found exception;
    pragma exception_init(object_not_found, -00942);
begin
    execute immediate ('drop table l_plan.l_domain');
exception
    when object_not_found then
        null;
    when others then
        dbms_output.put_line('������ '||sqlerrm);
end;
/
create table l_plan.l_domain (id        number       not null,
                              ccode     varchar2(50),
                              name      varchar2(255),
                              user_name varchar2(50),
                              user_pass varchar2(50))
tablespace l_plan;

comment on table l_plan.l_domain is '���������� �������';

comment on column l_plan.l_domain.id        is 'ID ������';
comment on column l_plan.l_domain.ccode     is '��������� ��� ������';
comment on column l_plan.l_domain.name      is '��� ������';
comment on column l_plan.l_domain.user_name is 'LogIn ������������ �� ��� �������� �������������� ������';
comment on column l_plan.l_domain.user_pass is '������ ������������ �� ��� �������� �������������� ������';

create unique index l_plan.domain_pk_id on l_plan.l_domain
(id)
tablespace l_plan;

alter table l_plan.l_domain
add (constraint domain_pk_id primary key (id) using index domain_pk_id);

create or replace trigger l_plan.tr_l_domain before insert
on l_plan.l_domain 
referencing new as new old as old
for each row
begin

    if :new.id is null then
    
        select (max(id)+1) 
        into   :new.id 
        from   l_plan.l_domain;
    end if;
end;
/

insert into l_plan.l_domain (id,
                             ccode,
                             name) values (1,
                                           'DOMAIN_DW_TST',
                                           '�������� �����');
commit;