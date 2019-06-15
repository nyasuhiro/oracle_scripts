set lines 120
set pages 100
set echo on
set time on
set timing on

clear col
col PROFILE format a15
col RESOURCE_NAME format a30
col RESOURCE_TYPE format a15
col LIMIT format a15

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool select_default_profile_&log_date..log

select
  profile,
  resource_name,
  resource_type,
  limit
from
  dba_profiles
where
  profile = 'DEFAULT'
order by
  resource_type, resource_name;

spool off
exit
