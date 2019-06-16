#!/bin/bash

export ORACLE_SID=nyadb
USER=NYADBA
PASS=nyadba
TNS=nyapdb1

sqlplus -s ${USER}/${PASS}@${TNS} << EOF
set lines 120
set pages 100
set echo on
set time on
set timing on
clear col
column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;
spool snapshot_&log_date..log
select 
  MAX(SNAP_ID) 
from 
  AWR_PDB_SNAPSHOT;
exec DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT ();
select 
  MAX(SNAP_ID)
from 
  AWR_PDB_SNAPSHOT;
spool off
exit
EOF
