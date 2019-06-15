set lines 1000
set pages 1000
set echo on
set time on
set timing on

alter session set NLS_DATE_FORMAT = 'YYYY/MM/DD HH24:MI:SS';

clear col
col TABLE_NAME format a40
col INDEX_NAME format a40
col PARTITION_NAME format a40

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool select_index_stats_&log_date..log

select
  TABLE_NAME,
  INDEX_NAME,
  PARTITION_NAME,
  NUM_ROWS,
  SAMPLE_SIZE,
  LAST_ANALYZED
from
  USER_IND_STATISTICS
order by
  TABLE_NAME,INDEX_NAME,PARTITION_NAME;

spool off
exit
