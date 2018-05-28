create or replace package body l_plan.meta_do_plan_pkg
/******************************* ALFA HISTORY *******************************************\
����        �����            ID       ��������
----------  ---------------  -------- ----------------------------------------------------
05.05.2017  ����� �.�.      [000000]  �������� ������.
20,04,2018  ����� �.�.      [000000]  ���������� ���������� �����, �������� ����� ��������
\******************************* ALFA HISTORY *******************************************/
is

-- ��������� ��������� ����������
    procedure my_exception
      is
    begin
        dbms_output.put_line('������ '  ||chr(10)||
        dbms_utility.format_error_stack||
        dbms_utility.format_error_backtrace());
        commit;

    end my_exception;

-- ��������� �������� ��������� �����
    procedure finish_plan
        is
    begin
        
        -- ���������� �����
        update l_plan.l_loading_plan
        set    run_id = null
        where  run_id = vCurrentRunID;
    
        commit;
        
    exception
        when others then
            -- ����������� ������
            make_log ('������ ���������� ��������� finish_plan '||sqlcode||' '||sqlerrm);
            my_exception;
                        
    end finish_plan;
   
-- ��������� ������������� �����
    procedure make_arch_logs
        is
    begin
        -- ���������� ����� � �����
        insert into l_plan.l_log_loading_arch (time_stamp,
                                               project_id,
                                               environment_id,
                                               db_um_id,
                                               domain_id,
                                               int_service_id,
                                               action_desc,
                                               user_name,
                                               action_id,
                                               run_id,
                                               workflow_run_id,
                                               workflow_start,
                                               workflow_end)
        select time_stamp,
               project_id,
               environment_id,
               db_um_id,
               domain_id,
               int_service_id,
               action_desc,
               user_name,
               action_id,
               run_id,
               workflow_run_id,
               workflow_start,
               workflow_end
        from   l_plan.l_log_loading
        where (environment_id,
               project_id,
               db_um_id,
               domain_id,
               int_service_id) in (select environment_id,
                                          project_id,
                                          db_um_id,
                                          domain_id,
                                          int_service_id
                                   from   l_plan.l_loading_plan
                                   where  run_id = vCurrentRunID);
        
        commit;
                         
        -- ������� ������� ����������� �����
        delete from l_plan.l_log_loading
        where (environment_id,
               project_id,
               db_um_id,
               domain_id,
               int_service_id) in (select environment_id,
                                          project_id,
                                          db_um_id,
                                          domain_id,
                                          int_service_id
                                   from   l_plan.l_loading_plan
                                   where  run_id = vCurrentRunID);
            
        commit;
            
    exception
        when others then  
            -- ����������� ������
            make_log ('������ ���������� ��������� make_arch_logs '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end make_arch_logs;

-- ��������� ������� ������������� ���� �������
    procedure make_arch_fall (pRunID    number,
                              pActionID number)
        is
    begin
        -- ���������� ����� � �����
        insert into l_plan.l_log_loading_arch (time_stamp,
                                               project_id,
                                               environment_id,
                                               db_um_id,
                                               domain_id,
                                               int_service_id,
                                               action_desc,
                                               user_name,
                                               action_id,
                                               run_id,
                                               workflow_run_id,
                                               workflow_start,
                                               workflow_end)
        select time_stamp,
               project_id,
               environment_id,
               db_um_id,
               domain_id,
               int_service_id,
               action_desc,
               user_name,
               action_id,
               run_id,
               workflow_run_id,
               workflow_start,
               workflow_end
        from   l_plan.l_log_loading
        where  action_desc like '������� �����%' and
               action_id = pActionID and
               run_id    = pRunID;
        
        commit;
                         
        -- ������� ������� ����������� �����
        delete from l_plan.l_log_loading
        where  action_desc like '������� �����%' and
               action_id = pActionID and
               run_id    = pRunID;
            
        commit;
            
    exception
        when others then  
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '����� �������� ����� '||pRunID||chr(10)||
                      '����� ������������ �������� '||pActionID||chr(10)||
                      '������ ���������� ��������� make_arch_fall '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end make_arch_fall;

-- ��������� ������� ������������� ���� ����������� ��������
    procedure make_arch_run (pRunID    number,
                             pActionID number)
        is
    begin
        -- ���������� ����� � �����
        insert into l_plan.l_log_loading_arch (time_stamp,
                                               project_id,
                                               environment_id,
                                               db_um_id,
                                               domain_id,
                                               int_service_id,
                                               action_desc,
                                               user_name,
                                               action_id,
                                               run_id,
                                               workflow_run_id,
                                               workflow_start,
                                               workflow_end)
        select time_stamp,
               project_id,
               environment_id,
               db_um_id,
               domain_id,
               int_service_id,
               action_desc,
               user_name,
               action_id,
               run_id,
               workflow_run_id,
               workflow_start,
               workflow_end
        from   l_plan.l_log_loading
        where  action_desc like '���������� ��������' and
               action_id = pActionID and
               run_id    = pRunID;
        
        commit;
                         
        -- ������� ������� ����������� �����
        delete from l_plan.l_log_loading
        where  action_desc like '���������� ��������' and
               action_id = pActionID and
               run_id    = pRunID;
            
        commit;
            
    exception
        when others then  
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '����� �������� ����� '||pRunID||chr(10)||
                      '����� ������������ �������� '||pActionID||chr(10)||
                      '������ ���������� ��������� make_arch_run '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end make_arch_run;
    
-- ��������� �����������
    procedure make_log (pMsg varchar2)
    is
        vProject_id     number;  -- ������
        vEnvironment_id number;  -- ����� ������
        vDB_um_id       number;  -- �� �������
        vDomain_id      number;  -- ����� IPC
        vInt_service_id number;  -- �������������� ������
    begin
        -- ����� ���������� ����� �� ������� ����������� ����
        select distinct
               environment_id,
               project_id,
               db_um_id,
               domain_id,
               int_service_id
        into   vEnvironment_id,
               vProject_id,
               vDB_um_id,
               vDomain_id,
               vInt_service_id
        from   l_plan.l_loading_plan lp
        where  run_id    = vCurrentRunID and
               action_id = vCurrentActionID;
                   
        -- ������� ������ � ��� �����
        insert into l_plan.l_log_loading (time_stamp,
                                          project_id,
                                          environment_id,
                                          db_um_id,
                                          domain_id,
                                          int_service_id,
                                          action_desc,
                                          user_name,
                                          action_id,
                                          run_id,
                                          workflow_run_id,
                                          workflow_start) values (systimestamp,
                                                                  vProject_id,
                                                                  vEnvironment_id,
                                                                  vDB_um_id,
                                                                  vDomain_id,
                                                                  vInt_service_id,
                                                                  pMsg,
                                                                  vUserName,
                                                                  vCurrentActionID,
                                                                  vCurrentRunID,
                                                                  vCurrentWFrunID,
                                                                  vCurrentWFstart);
        commit;
    
    exception
        when others then
            my_exception;
                                                                        
    end make_log;

-- ��������� ������ ����� � �������� �������
    procedure get_workflow (pWorkflowUK in  number,
                            pFolder     out varchar2,
                            pWorkflow   out varchar2)
        is
    begin
        
        -- ����� ����� � ������
        select folder,
               name
        into   pFolder,
               pWorkflow
        from   l_plan.l_workflow
        where  uk = pWorkflowUK;      
        
    exception
        when others then
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '������ ���������� ��������� get_workflow ��� ������ ����� � �������� ������'||chr(10)||
                      '� ������� '||sqlcode||' '||sqlerrm);
            
            -- ����������� ������ �������� �������
            select '' as folder,
                   '' as workflow
            into   pFolder,
                   pWorkflow
            from   dual;
            my_exception;
            
    end get_workflow;

-- ��������� �������� ������������
    procedure check_depends (pRunID       in  number,
                             pActionID    in  number,
                             pRepSchema   in  varchar2,
                             pDbUmCcode   in  varchar2,
                             pLogMsg      out varchar2)
    is
        -- ������ ����� �������� ������������
        cursor cSubS (p_run_id number,
                      p_action_id number)
            is
        select row_number () over (partition by sub.action_id 
               order by sub.type_id, sub.dependency_ccode) as rn,
               nvl(sub.type_id,0) as type_id,   
               sub.dependency_ccode,
               case
                   when max(lg.action_id) is null then
                       'N'
                   else
                       'Y'
               end as existing_flag,
               substr(sub.dependency_ccode,1,
               instr(sub.dependency_ccode,'~')-1) as folder,
               substr(sub.dependency_ccode, 
               instr(sub.dependency_ccode,'~')+1) as workflow
        from   dual
        left outer join (select dep.type_id,
                                dep.dependency_ccode,
                                sub.action_id
                         from   l_plan.l_dependency_subscriber sub
                         inner join l_plan.l_dependency dep
                                 on sub.dependency_id = dep.id
                         inner join l_plan.l_dependency_type typ
                                 on dep.type_id = typ.id
                         where  sub.action_id = p_action_id) sub 
                     on  1 = 1
        left outer join l_plan.l_log_loading lg
                     on lg.run_id    = p_run_id    and
                        lg.action_id = p_action_id and
                        lg.workflow_run_id is not null
        group by sub.action_id, 
                 sub.type_id,
                 sub.dependency_ccode
        order by nvl(sub.type_id,0);
                     
        vFlag varchar2(5);           -- ���� ���������� �������
        
        type CurTyp is ref cursor;   -- ��� ������ ��� ������������� SQL
        cCursorSubs CurTyp;          -- ������ ��� �������� ��������
        cCursorTxt  varchar2(4000);  -- ����� ������� �������� ��������
        
        
    begin
        
        -- �������� �������� ������������ ��������
        for l in cSubS(pRunID,
                       pActionID) loop
                
            -- �������� �� ������ ������ �����
            if l.existing_flag = 'Y' then
                -- ��������� ����� �������
                if pLogMsg is null then 
                    -- ������� �������� ������
                    pLogMsg := '������ �� ����� �������� ���� � ����'||chr(10)||
                               '������ ****��������****'; 
                else 
                    -- � �������� �������� ��� ���� ������
                    pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                               '������ �� ����� �������� ���� � ����'||chr(10)||
                               '������ ****��������****';
                end if;
                
            end if;
            
            -- ������������ ���
            if    l.type_id = 0 then
                        
                -- ��������� ����� ����������
                if pLogMsg is null then 
                    -- ������� �������� ������
                    pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                               '��� ������������ - 0 (��� ������������)'||chr(10)||
                               '������ ****��������****'; 
                else 
                    -- � �������� �������� ��� ���� ������
                    pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                               '����������� � ������ �������� ����� '||l.rn||chr(10)||
                               '��� ������������ - 0 (��� ������������)'||chr(10)||
                               '������ ****��������****';
                end if;
                           
                               
            -- ����������� �� ��������� WF
            elsif l.type_id = 1 then
                        
                -- ������ ������� � ���������
                cCursorTxt := 
                    'select case '||chr(10)||
                    '           when max(ld.as_of_day) is null then '||chr(10)||
                    '               ''NULL'' '||chr(10)||
                    '           when max(ld.as_of_day)-max(mas.as_of_day) = 0 then '||chr(10)|| 
                    '               ''Y'' '||chr(10)||
                    '           else '||chr(10)||
                    '               ''N'' '||chr(10)||
                    '       end as is_finish_flag '||chr(10)||
                    'from   dual '||chr(10)||
                    'left outer join loading@'||pDbUmCcode||' ld '||chr(10)||
                    '             on folder_name   = '''||l.folder||'''   and '||chr(10)||
                    '                workflow_name = '''||l.workflow||''' and '||chr(10)||
                    '                end_dttm is not null '||chr(10)||
                    'left outer join (select max(as_of_day) as as_of_day '||chr(10)||
                    '                 from as_of_day@'||pDbUmCcode||') mas '||chr(10)||
                    '             on 1 = 1 '||chr(10)||
                    'group by folder_name, '||chr(10)||
                    '         workflow_name';
                        
                -- ������ ������� � ��������
                open cCursorSubs for cCursorTxt;
                        
                -- ����� ����� �������
                fetch cCursorSubs into vFlag;
                    
                -- �������� ������� � ���������
                close cCursorSubs;
                    
                -- �������� ����� ���������� �������
                if    vFlag = 'NULL' then
                
                    -- ��������� ����� �������
                    if pLogMsg is null then 
                        -- ������� �������� ������
                        pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 1 (����������� �� ���������� ������ ������)'||chr(10)||
                                   '����������� �� ���������� ������ '||l.dependency_ccode||chr(10)||
                                   '� �� ������� ������ �������� ������� ������ '||chr(10)||
                                   '������ ****��������****';
                    
                    else 
                        -- � �������� �������� ��� ���� ������
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 1 (����������� �� ���������� ������ ������)'||chr(10)||
                                   '����������� �� ���������� ������ '||l.dependency_ccode||chr(10)||
                                   '� �� ������� ������ �������� ������� ������ '||chr(10)||
                                   '������ ****��������****';
                    end if;
                    
                elsif vFlag = 'Y'    then

                    -- ��������� ����� ����������
                    if pLogMsg is null then 
                        -- ������� �������� ������
                        pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 1 (����������� �� ���������� ������ ������)'||chr(10)||
                                   '����������� �� ���������� ������ '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    else 
                        -- � �������� �������� ��� ���� ������
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 1 (����������� �� ���������� ������ ������)'||chr(10)||
                                   '����������� �� ���������� ������ '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    end if;
                    
                else

                    -- ��������� ����� �������
                    if pLogMsg is null then 
                        -- ������� �������� ������
                        pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 1 (����������� �� ���������� ������ ������)'||chr(10)||
                                   '����������� �� ���������� ������ '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    
                    else 
                        -- � �������� �������� ��� ���� ������
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 1 (����������� �� ���������� ������ ������)'||chr(10)||
                                   '����������� �� ���������� ������ '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    end if;
                    
                end if;
                    
            -- ����������� �� �����
            elsif l.type_id = 2 then
                        
                -- ������ ������� � ���������
                cCursorTxt := 
                    'select case '||chr(10)||
                    '           when (sysdate - dtime) >= 0 then '||chr(10)|| 
                    '               ''Y'' '||chr(10)||
                    '           else '||chr(10)||
                    '               ''N'' '||chr(10)||
                    '       end as is_finish_flag '||chr(10)||
                    'from  (select case '||chr(10)||
                    '                  when length(dependency_ccode) < 8 then '||chr(10)||
                    '                       to_date(to_char(sysdate, ''dd.mm.yyyy'')|| '||chr(10)||
                    '                       dep.dependency_ccode, '||chr(10)|| 
                    '                     ''dd.mm.yyyy hh24:mi'') '||chr(10)||
                    '                  else '||chr(10)||
                    '                      to_date(dep.dependency_ccode, ''dd.mm.yyyy hh24:mi'') '||chr(10)||
                    '              end as dtime '||chr(10)||
                    '       from   l_plan.l_dependency_subscriber sub '||chr(10)||
                    '       inner join l_plan.l_dependency dep '||chr(10)||
                    '               on sub.dependency_id = dep.id '||chr(10)||
                    '       where  sub.action_id = '||pActionID||')';
                        
                -- ������ ������� � ��������
                open cCursorSubs for cCursorTxt;
                        
                -- ����� ����� �������
                fetch cCursorSubs into vFlag;
                    
                -- �������� ������� � ���������
                close cCursorSubs;
                    
                -- �������� ����� ���������� �������
                if vFlag = 'Y' then
                    
                    -- ��������� ����� ����������
                    if pLogMsg is null then 
                        -- ������� �������� ������
                        pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 2 (����������� �� ����� ������� ������)'||chr(10)||
                                   '����������� �� ����/����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    else 
                        -- � �������� �������� ��� ���� ������
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 2 (����������� �� ����� ������� ������)'||chr(10)||
                                   '����������� �� ����/����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    end if;
                    
                else
                    
                    -- ��������� ����� �������
                    if pLogMsg is null then 
                        -- ������� �������� ������
                        pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 2 (����������� �� ����� ������� ������)'||chr(10)||
                                   '����������� �� ����/����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    else 
                        -- � �������� �������� ��� ���� ������
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 2 (����������� �� ����� ������� ������)'||chr(10)||
                                   '����������� �� ����/����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    end if;
                    
                end if;   
                    
            -- ����������� �� ���������� ������ �����
            elsif l.type_id = 3 then

                -- ������ ������� � ���������
                cCursorTxt := 
                    'select case '||chr(10)||
                    '           when wf.run_status_code = 1 then '||chr(10)|| 
                    '               ''Y'' '||chr(10)||
                    '           else '||chr(10)||
                    '               ''N'' '||chr(10)||
                    '       end as is_finish_flag '||chr(10)||
                    'from  dual '||chr(10)||
                    'left outer join '||pRepSchema||'.opb_wflow_run@'||pDbUmCcode||' wf '||chr(10)||
                    '             on 1 = 1 and '||chr(10)||
                    '                wf.end_time is not null and '||chr(10)||
                    '                wf.workflow_run_id in (select workflow_run_id '||chr(10)||
                    '                                       from   l_plan.l_log_loading '||chr(10)||
                    '                                       where  run_id = '||pRunID||' and '||chr(10)||
                    '                                              action_id = '||l.dependency_ccode||' and '||chr(10)||
                    '                                              workflow_run_id is not null)';
                        
                -- ������ ������� � ��������
                open cCursorSubs for cCursorTxt;
                        
                -- ����� ����� �������
                fetch cCursorSubs into vFlag;
                
                -- �������� ������� � ���������
                close cCursorSubs;
                    
                -- �������� ����� ���������� �������
                if vFlag = 'Y' then
                    
                    -- ��������� ����� ����������
                    if pLogMsg is null then 
                        -- ������� �������� ������
                        pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 3 (����������� �� ���������� ������ ������ �����)'||chr(10)||
                                   '����������� �� ����� ����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    else 
                        -- � �������� �������� ��� ���� ������
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 3 (����������� �� ���������� ������ ������ �����)'||chr(10)||
                                   '����������� �� ����� ����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    end if;
                    
                else
                    
                    -- ��������� ����� �������
                    if pLogMsg is null then 
                        -- ������� �������� ������
                        pLogMsg := '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 3 (����������� �� ���������� ������ ������ �����)'||chr(10)||
                                   '����������� �� ����� ����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    
                    else 
                        -- � �������� �������� ��� ���� ������
                        pLogMsg := pLogMsg||chr(10)||chr(10)||chr(10)||
                                   '����������� � ������ �������� ����� '||l.rn||chr(10)||
                                   '��� ������������ - 3 (����������� �� ���������� ������ ������ �����)'||chr(10)||
                                   '����������� �� ����� ����� '||l.dependency_ccode||chr(10)||
                                   '������ ****��������****';
                    
                    end if;
                                   
                end if;
                
            end if;
             
        end loop;
    
    exception
        when others then
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '������ ���������� ��������� check_depends'||chr(10)||
                      '� ������� ' ||sqlcode||' '||sqlerrm||chr(10)||
                      '�� ����� �������� ������������');
            my_exception;
                
    end check_depends;

-- ��������� �������� ���������� ������ �������
    procedure check_wf_end (pIntServiceCcode varchar2,
                            pDbUmCcode       varchar2)
    is
        type CurTyp is ref cursor;   -- ��� ������ ��� ������������� SQL
        cCursorRun  CurTyp;          -- ������ ��� ������ ID ������
        cCursorRTxt varchar2(4000);  -- ����� ������� ��� ������ ID ������
        
        vWFrunID    number;          -- ID ����������� ������
        vWFendTime  date;            -- ���� ���������� ������
    begin
        -- ����� ID ������ ����������� ��� ������� � ���
        cCursorRTxt := 'select wf.workflow_run_id, '||chr(10)||
                       '       wf.end_time '||chr(10)||
                       'from   '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_wflow_run@'||pDbUmCcode||'   wf '||chr(10)||
                       'inner join '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_subject@'||pDbUmCcode||' subj '||chr(10)||
                       '        on subj.subj_id = wf.subject_id '||chr(10)||
                       'where  wf.end_time is not null and '||chr(10)||
                       '       wf.run_status_code = 1  and '||chr(10)||
                       '       workflow_run_id in (select distinct workflow_run_id '||chr(10)||
                       '                           from   l_plan.l_log_loading '||chr(10)||
                       '                           where  workflow_run_id is not null and '||chr(10)||
                       '                                  workflow_end    is null)';
        
        -- ������ ������� � ���������� �����������
        open cCursorRun for cCursorRTxt;
        
        loop
            -- ����� �� ����� ����� ��������� ������ �������
            exit when cCursorRun%notfound;
            
            -- ����� ID � ������� ���������� ������
            fetch cCursorRun into vWFrunID,
                                  vWFendTime;
            
            update l_plan.l_log_loading
            set    workflow_end    = vWFendTime
            where  workflow_run_id = vWFrunID;
            
            commit; 
            
        end loop;
        
        -- �������� ������� � ���������� ����������� 
        close cCursorRun;
    
    exception
        when others then
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '������ ���������� ��������� check_wf_end '||chr(10)||
                      '� ������� ' ||sqlcode||' '||sqlerrm);
            my_exception;
    
    end check_wf_end;

-- ��������� ������� ����������
    procedure exec_param (pParameterUK in  number,
                          pDbUmCcode   in  varchar2,
                          pFailFalg    out varchar2) 
    is
        vSQL varchar2(4000);  -- ����� ���������
    begin
        -- ����� ������ ������� ���������
        vSQL := get_parameter(pParameterUK);
                                
        -- ������ ��������� db_link �� ��������
        vSQL := replace(vSQL,'*DB_UM*',pDbUmCcode);
                                    
        -- ������ ���� ����������
        for i in (select var.param_name,
                         varv.param_value 
                  from   l_plan.l_variable_value varv
                  inner join l_plan.l_variable   var
                          on varv.param_id = var.id
                  where (varv.environment_id,
                         varv.project_id,
                         varv.domain_id,
                         varv.int_service_id) in (select environment_id,
                                                         project_id,
                                                         domain_id,
                                                         int_service_id
                                                  from   l_plan.l_loading_plan
                                                  where  run_id = vCurrentRunID)
                  order by var.param_name) loop
                                                  
            if vSQL like '%*'||i.param_name||'*%' then
                                            
                vSQL := replace(vSQL,'*'||i.param_name||'*',i.param_value);
                                            
            end if;
                                        
        end loop;
                                
        -- �������� ������� ���������
        if vSQL is not null then
                                    
            -- ����������� ��������� ����������
            make_log ('������ ������� ����������� ���������� '||chr(10)||
                      '��� ������ ��� ������������ '||chr(10)||
                      vSQL);
                                    
            -- ������ ��������� ����������
            execute immediate (vSQL);
                                    
        end if;
                         
        commit;
        
        -- ������� �� ���� ��� ������� ����������
        pFailFalg := 'N';
        
    exception
        when others then
            -- ��������� ����� �������
            pFailFalg := 'Y';
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '������ ���������� ��������� exec_param '||chr(10)||
                      '�� ����� ����������� ����������'||chr(10)||
                      '� ������� ' ||sqlcode||' '||sqlerrm);
            my_exception;
            
    end exec_param;

-- ��������� ������� �������
    procedure exec_workflow (pFolder          varchar2,
                             pWorkflow        varchar2,
                             pDomainCode      varchar2,
                             pDomainUsr       varchar2,
                             pDomainPass      varchar2,
                             pIntServiceCcode varchar2,
                             pDbUmCcode       varchar2)
    is

        type CurTyp is ref cursor;   -- ��� ������ ��� ������������� SQL
        cCursorRun  CurTyp;          -- ������ ��� ������ ID ������
        cCursorRTxt varchar2(4000);  -- ����� ������� ��� ������ ID ������
        
    begin
        
        -- ����������� ����������
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',1,pDomainCode);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',2,pIntServiceCcode);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',3,pDomainUsr);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',4,pDomainPass);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,pFolder);
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,pWorkflow);
                                
        -- ������ ������
        dbms_scheduler.run_job('EXEC_WORKFLOW_JOB');
                                
        -- �������� ������� ����������
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,'');
                            
        -- ����� ID ������ ����������� ��� ������� � ���
        cCursorRTxt := 'select wf.workflow_run_id, '||chr(10)||
                       '       wf.start_time '||chr(10)||
                       'from   '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_wflow_run@'||pDbUmCcode||'   wf '||chr(10)||
                       'inner join '||replace(lower(pIntServiceCcode),'int','rep')||'.opb_subject@'||pDbUmCcode||' subj '||chr(10)||
                       '        on subj.subj_id = wf.subject_id '||chr(10)||
                       'where  end_time is null and '||chr(10)||
                       '       subj.subj_name = '''||pFolder||''' and '||chr(10)||
                       '       wf.workflow_name = '''||pWorkflow||'''';
        
        -- ������� ID � ���� ������� ������ � �����������
        vCurrentWFrunID := null;
        vCurrentWFstart := null;
        
        -- ������ ������� � ���������� �����������
        open cCursorRun for cCursorRTxt;
                            
        -- ����� ID ������
        fetch cCursorRun into vCurrentWFrunID,
                              vCurrentWFstart;
        
        -- �������� ������� � ���������� ����������� 
        close cCursorRun;
                            
        -- ����������� ������� ������
        make_log ('���������� ��������');
                                
        commit;             
    
    exception
        when others then
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '������ ���������� ��������� exec_workflow '||chr(10)||
                      '�� ����� ������� ������'||chr(10)||
                      '� ������� ' ||sqlcode||' '||sqlerrm);
            my_exception;
                     
    end exec_workflow;

-- ��������� ���������� �����
    procedure prepare_plan (pEnvironmentID number,
                            pProjectID     number,
                            pDbUmID        number,
                            pDomainID      number,
                            pIntServiceID  number)
    is
        vRun_ID number;  -- ����� �����
    begin
        
        -- ����� ������ ������ �����
        vRun_ID := l_plan.l_s_run.nextval;
    
        -- ��������� ����������� ID ����� ��� ������� �������
        update l_plan.l_loading_plan
        set    run_id = vRun_ID
        where  environment_id = pEnvironmentID and
               project_id     = pProjectID     and
               db_um_id       = pDbUmID        and
               domain_id      = pDomainID      and
               int_service_id = pIntServiceID;
               
        commit;                             
        
    exception
        when others then
            -- ����������� ������
            make_log ('������ ���������� ��������� prepare_plan '||chr(10)||
                      '� ������� ' ||sqlcode||' '||sqlerrm);
            my_exception;
    
    end prepare_plan;
    
-- ��������� ������� ����� ��������
    procedure do_plan (pUserName varchar2 default 'ETL_USER')
    is
        -- ������ ���������������� �������� �����
        cursor cToDoList 
            is
        select distinct 
               act.parameter_uk,
               act.workflow_uk,
               lp.action_id,
               lp.run_id,
               lp.environment_id,
               lp.project_id,
               lp.db_um_id,
               lp.domain_id,
               lp.int_service_id
        from   l_plan.l_action act
        inner join l_plan.l_loading_plan lp
                on lp.action_id = act.id
        where((lp.action_id,
               lp.run_id) not in (select distinct 
                                         lg.action_id,
                                         lg.run_id
                                  from   l_plan.l_log_loading lg
                                  where (lg.action_desc  like '���������� ��������' and 
                                         lg.workflow_end is not null)               or
                                         lg.action_desc  like '������� �����%')     or
              (lp.action_id,
               lp.run_id) in (select distinct 
                                     lg.action_id,
                                     lg.run_id
                              from   l_plan.l_log_loading lg
                              where  lg.workflow_run_id is not null and 
                                     lg.workflow_start  is not null and
                                     lg.workflow_end    is null)) and
               lp.run_id is not null
        order by lp.environment_id,
                 lp.project_id,
                 lp.db_um_id,
                 lp.domain_id,
                 lp.int_service_id,
                 lp.run_id,
                 lp.action_id;
        
        vDomain_ccode      varchar2(50);  -- ����� ��� �������
        vDomain_user       varchar2(50);  -- LogIn �� ��� �������� ����� ������
        vDomain_pass       varchar2(50);  -- ������ ��� �������
        vInt_service_ccode varchar2(50);  -- �������������� ������
        vDB_Um_ccode       varchar2(50);  -- ��
        
        vWFlog    varchar2(255);          -- ��� ������������ ��������
        vFail     varchar2(1);            -- ���� ������� ��������� ����������� ���������� 
        vFinish   varchar2(1);            -- ���� ��������� ������ �����
        vJobFlag  varchar2(1);            -- ���� ������� Job ������� �������
        vLogMsg   varchar2(4000);         -- ����� ����������� ��������
        
        vFolder   varchar2(50);           -- ����� ������� ������
        vWorkflow varchar2(50);           -- ����������� �����
        
        exNoJob   exception;              -- ���������������� ���������� ���������� Job
        -- ������������� ����������������� ����������
        pragma exception_init(exNoJob, -20001);

    begin
        -- ������� ����������, ����� �� ����������� ������ �������
        vWFlog   := null;
        vFail    := null;
        vFinish  := null;
        vJobFlag := null;
        vLogMsg  := null;
        
        vFolder   := null;
        vWorkflow := null;
        
        -- �������� ������� job ��� ������� �������
        select case
                   when count(1) > 0 then
                       'Y'
                   else
                       'N'
               end as JobFlag
        into   vJobFlag
        from   all_scheduler_jobs
        where  lower(owner)    = 'l_plan' and
               lower(job_name) = 'exec_workflow_job';
        
        if vJobFlag != 'Y' then
            
            -- ����� ����������������� ���������� �� ���������� job
            --raise_application_error(-20001, '���������� Job, ��� ������������ ��������� ����');
            -- �������� job
            dbms_scheduler.create_job(job_name     => 'EXEC_WORKFLOW_JOB',
                                          program_name => 'EXEC_WORKFLOW',
                                          auto_drop    => false);
            dbms_scheduler.enable('EXEC_WORKFLOW_JOB');
            
            make_log ('�������� Job');
            
        end if;
        
        -- ������� ���������� ��������� ������� �������
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',1,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',2,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',3,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',4,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,'');
        
        -- ���������� �������� ������
        for r in cToDoList loop
        
            -- ��������� ���������� ������� 
            vCurrentRunID    := r.run_id;
            vCurrentActionID := r.action_id;
            vUserName        := pUserName;
            
            -- ���� ����� ���������� �������
            select ccode,
                   user_name,
                   user_pass
            into   vDomain_ccode,
                   vDomain_user,
                   vDomain_pass
            from   l_plan.l_domain
            where  id = r.domain_id;
            
            select ccode
            into   vInt_service_ccode
            from   l_plan.l_int_service
            where  id = r.int_service_id;
            
            select ccode
            into   vDB_Um_ccode
            from   l_plan.l_db_um
            where  id = r.db_um_id;
            
            -- ����������� ���������� ������� ������
            check_wf_end (vInt_service_ccode,
                          vDB_Um_ccode);
            
            -- �������� ������������ ��������
            check_depends (r.run_id,
                           r.action_id,
                           replace(lower(vInt_service_ccode),'int','rep'),
                           vDB_Um_ccode,
                           vLogMsg);
            
            -- �������� ���������� �������
            if lower(vLogMsg) not like '%****��������****%' then 
                
                -- ����� ����� � ������
                get_workflow(r.workflow_uk,
                             vFolder,
                             vWorkflow);
                                 
                -- ����������� ����������� ��������
                make_log ('�������� ��������, ��������� ������ ������ '||vFolder||'.'||vWorkflow);
                    
                -- ����� ����� � ������
                get_workflow(r.workflow_uk,
                             vFolder,
                             vWorkflow);
                    
                -- ��������� ����������
                if r.parameter_uk is not null then
                                    
                    exec_param (r.parameter_uk,
                                vDB_Um_ccode,
                                vFail);
                               
                end if;
                                
                -- �������� �� ������� ������ �������
                if vFolder   is not null and
                   vWorkflow is not null and
                   nvl(vFail, 'N') = 'N' then
                                
                    -- ����������� ������� ������
                    make_log ('������ ������ '||vFolder||'\'||vWorkflow);
                                    
                    -- ������ ������
                    exec_workflow (vFolder,
                                   vWorkflow,
                                   vDomain_ccode,
                                   vDomain_user,
                                   vDomain_pass,
                                   vInt_service_ccode,
                                   vDB_Um_ccode);
                                       
                    -- ������� ������ � ���� ������
                    vCurrentWFrunID := null;
                    vCurrentWFstart := null;
                                                   
                -- ��� ������
                else
                    -- ����������� ������� ������
                    make_log ('������ ������ '||vFolder||'\'||vWorkflow||' ����������');
                                
                end if;
                                    
                commit;
            
            end if;
        
            -- ������������ ����� ���������� �����
            select case
                       when count(action_id) = 0 then
                           'Y'
                       else
                           'N'
                   end
            into   vFinish
            from  (select distinct action_id 
                   from   l_plan.l_loading_plan
                   where  run_id = r.run_id
                   minus
                   select distinct action_id
                   from   l_plan.l_log_loading
                   where  environment_id = r.environment_id and
                          project_id     = r.project_id     and
                          db_um_id       = r.db_um_id       and
                          domain_id      = r.domain_id      and
                          int_service_id = r.int_service_id and
                          action_desc not like '������� �����%'  and
                          action_desc like '���������� ��������' and
                          not exists (select distinct 1 
                                      from   l_plan.l_log_loading
                                      where  environment_id = r.environment_id and
                                             project_id     = r.project_id     and
                                             db_um_id       = r.db_um_id       and
                                             domain_id      = r.domain_id      and
                                             int_service_id = r.int_service_id and
                                             workflow_run_id is not null and
                                             workflow_end    is null));
                          
            -- �������� ���������� �����
            if vFinish = 'Y' then
                
                -- ����������� ���������� �����
                make_log ('���������� ����� '||r.run_id);
                
                -- �������� ����� � �����
                make_arch_logs;
                
                -- ���������� �����
                finish_plan;
                
            end if;

        end loop;
        
        commit;
        
        -- ������� ���������� ��������� ������� �������
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',1,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',2,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',3,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',4,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',5,'');
        dbms_scheduler.set_job_argument_value('EXEC_WORKFLOW_JOB',6,'');
        
    exception
        when exNoJob then
            make_log ('������ '||sqlcode||' '||sqlerrm);
            
        when others then  
            make_log ('������� �����'||chr(10)||
                      '������ ���������� ��������� do_plan'||chr(10)||
                      '� ������� '||sqlcode||' '||sqlerrm);
            my_exception;
            
    end do_plan;

-- ������� ������ ������� ���������
    function get_parameter (pParameterUK number) return varchar2
    as
        res varchar2(4000);
    begin
        
        -- ����� ������ ���������
        select param_desc
        into   res
        from   l_plan.l_parameter
        where  uk = pParameterUK;
        
        -- ������� ������
        return res;
        
    exception
        when others then
            -- ����������� ������
            make_log ('������� �����'||chr(10)||
                      '������ ���������� ������� get_parameter '||chr(10)||
                      '��� ������ ��������� � �����'||chr(10)||
                      '� ������� ' ||sqlcode||' '||sqlerrm);
            my_exception;
            return '';
            
    end get_parameter;

end meta_do_plan_pkg;
/