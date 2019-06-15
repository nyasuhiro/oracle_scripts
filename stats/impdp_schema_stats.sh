#!/bin/bash

export ORACLE_SID=nyadb
export NLS_LANG=American_America.AL32UTF8

export ADMINUSER=NYADBA
export ADMINPASS=nyadba
export IMPUSER=SOE
export IMPPASS=soe
export TNS=nyapdb1

DMP_PATH=/u01/app/oracle/dpdump
DIROBJ_NAME=IMP_DIR

MODE=METADATA_ONLY
TS_ACTION=SKIP

TIMESTAMP=`date +"%Y%m%d_%H%M%S"`
BASE_NAME=${ORACLE_SID}_${IMPUSER}_STATS
DMP_NAME=${BASE_NAME}.dmp
LOG_NAME=${BASE_NAME}_${TIMESTAMP}.imp.log
JOB_NAME=JOB_${IMPUSER}_IMPSCHEMA_STATS

TABLELIST=`sqlplus -s ${IMPUSER}/${IMPPASS}@${TNS} << EOF
set head off
set feed off
select TABLE_NAME from user_tab_statistics order by TABLE_NAME;
exit;
EOF
`

echo "" > unlock_stats.sql
for TABLE in ${TABLELIST[@]}
do
  echo "exec dbms_stats.unlock_table_stats(ownname=>'${IMPUSER}',tabname=>'${TABLE}');" >> unlock_stats.sql
done

sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF | tee -a ${LOG_NAME}
set feed off
set line 1000
set pages 1000
col OWNER for a30
col DIRECTORY_NAME for a30
col DIRECTORY_PATH for a100
create or replace DIRECTORY ${DIROBJ_NAME} AS '${DMP_PATH}';
select DIRECTORY_NAME,DIRECTORY_PATH from DBA_DIRECTORIES where DIRECTORY_NAME='${DIROBJ_NAME}';
@unlock_stats.sql
EOF



impdp ${ADMINUSER}/${ADMINPASS}@${TNS} \
  SCHEMAS=${IMPUSER} \
  DIRECTORY=${DIROBJ_NAME} \
  DUMPFILE=${DMP_NAME} \
  LOGFILE=${LOG_NAME} \
  CONTENT=${MODE} \
  LOGTIME=ALL \
  TABLE_EXISTS_ACTION=${TS_ACTION} \
  INCLUDE=STATISTICS \
  METRICS=YES  

sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF
set feed off
drop DIRECTORY ${DIROBJ_NAME};
@unlock_stats.sql
EOF

ls -l ${DMP_PATH}/${BASE_NAME}*
cat ${DMP_PATH}/${LOG_NAME} >> ${LOG_NAME}
