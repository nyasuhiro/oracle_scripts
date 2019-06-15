set echo on
set time on
set timing on

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool modify_default_profile_&log_date..log

alter profile DEFAULT limit
   FAILED_LOGIN_ATTEMPTS unlimited
   PASSWORD_LIFE_TIME unlimited
   PASSWORD_LOCK_TIME unlimited
   PASSWORD_GRACE_TIME unlimited;

spool off
exit
