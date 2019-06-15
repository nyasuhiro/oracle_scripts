set lines 1000
set pages 1000
set echo on
set time on
set timing on

alter session set NLS_DATE_FORMAT = 'YYYY/MM/DD HH24:MI:SS';

clear col
col TABLE_NAME format a40
col COLUMN_NAME format a40

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool select_column_stats_&log_date..log

select
  TABLE_NAME,
  COLUMN_NAME,
  HISTOGRAM,
  LAST_ANALYZED
from
  USER_TAB_COL_STATISTICS
order by
  TABLE_NAME,COLUMN_NAME;

spool off
exit
