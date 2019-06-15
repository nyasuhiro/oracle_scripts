set echo on
set time on
set timing on

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool drop_user_&log_date..log

DROP USER NYADBA CASCADE;

spool off
exit
