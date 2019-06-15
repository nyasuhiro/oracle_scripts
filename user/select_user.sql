set lines 120
set pages 100
set echo on
set time on
set timing on

clear col
col USERNAME format a40

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool select_user_&log_date..log

select
  USERNAME
from
  DBA_USERS
order by
  USERNAME;

spool off
exit
