begin
    execute immediate('drop package l_plan.meta_do_plan_pkg');
exception
    when others then
        null;
end;
/
create or replace package l_plan.meta_do_plan_pkg
/******************************* ALFA HISTORY *******************************************\
����        �����            ID       ��������
----------  ---------------  -------- ----------------------------------------------------
08.09.2017  ����� �.�.      [000000]  �������� ������.
20,04,2018  ����� �.�.      [000000]  ���������� ���������� �����, �������� ����� ��������
\******************************* ALFA HISTORY *******************************************/
is
    -- ����������
    vCurrentRunID    number;         -- ������� ���� ��� ����������
    vCurrentActionID number;         -- ������� �������� �����
    vCurrentWFrunID  number;         -- ������� ID ������ � �����������
    vCurrentWFstart  date;           -- ���� � ����� ������� ������
    vUserName        varchar2(256);  -- ������������, ����������� ����
    
    -- ���������
    procedure my_exception;
    procedure finish_plan;
    procedure make_arch_logs;
    procedure make_arch_fall(pRunID           number,
                             pActionID        number);
    procedure make_arch_run (pRunID           number,
                             pActionID        number);
    procedure make_log      (pMsg             varchar2);
    procedure get_workflow  (pWorkflowUK  in  number,
                             pFolder      out varchar2,
                             pWorkflow    out varchar2);
    procedure check_depends (pRunID       in  number,
                             pActionID    in  number,
                             pRepSchema   in  varchar2,
                             pDbUmCcode   in  varchar2,
                             pLogMsg      out varchar2);
    procedure check_wf_end  (pIntServiceCcode varchar2,
                             pDbUmCcode       varchar2);
    procedure exec_param    (pParameterUK in  number,
                             pDbUmCcode   in  varchar2,
                             pFailFalg    out varchar2);
    procedure exec_workflow (pFolder          varchar2,
                             pWorkflow        varchar2,
                             pDomainCode      varchar2,
                             pDomainUsr       varchar2,
                             pDomainPass      varchar2,
                             pIntServiceCcode varchar2,
                             pDbUmCcode       varchar2);
    procedure prepare_plan  (pEnvironmentID   number,
                             pProjectID       number,
                             pDbUmID          number,
                             pDomainID        number,
                             pIntServiceID    number);
    procedure do_plan       (pUserName        varchar2 default 'ETL_USER');    
    
    -- �������
    function get_parameter  (pParameterUK number) return varchar2;
    
end meta_do_plan_pkg;
/