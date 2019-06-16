set echo on
set time on
set timing on

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool create_user_&log_date..log

CREATE USER NYADBA
  IDENTIFIED BY nyadba
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
;

GRANT DBA TO NYADBA;
GRANT UNLIMITED TABLESPACE TO NYADBA;
GRANT EXECUTE ON DBMS_LOCK TO NYADBA WITH GRANT OPTION;

spool off
exit
