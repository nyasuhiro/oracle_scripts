set echo on 
set time on 
set timing on
set line 1000
set pages 1000

col TABLE_NAME for a40
column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool select_lock_stats_&log_date..log
select TABLE_NAME,STATTYPE_LOCKED from user_tab_statistics order by TABLE_NAME;

spool off
exit
