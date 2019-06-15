set echo on
set time on
set timing on

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool create_dirobj_&log_date..log

CREATE OR REPLACE DIRECTORY OBJECT &1 AS '&2'; 

GRANT READ ON DIRECTORY TO $3;
GRANT WRITE ON DIRECTORY TO $3;

spool off
exit
