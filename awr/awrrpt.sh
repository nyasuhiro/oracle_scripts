#!/bin/bash

export ORACLE_SID=nyadb
export USER=NYADBA
export PASS=nyadba
export TNS=nyapdb1

SNAP_TMP=`sqlplus -s ${USER}/${PASS}@${TNS} << EOF
set head off
set feed off
select MAX(SNAP_ID) from awr_pdb_snapshot;
exit;
EOF
`
export SNAP_BEFORE=$((${SNAP_TMP}-1))
export SNAP_AFTER=$((${SNAP_TMP}))

sqlplus -s ${USER}/${PASS}@${TNS} << EOF
define report_type=text;
define awr_location=AWR_PDB;
define num_days=1;
define begin_snap=${SNAP_BEFORE};
define end_snap=${SNAP_AFTER};
define report_name=awrrpt_${TNS}_${SNAP_BEFORE}_${SNAP_AFTER}.log;
@${ORACLE_HOME}/rdbms/admin/awrrpt.sql;
EOF

