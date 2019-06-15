#!/bin/bash

export ORACLE_SID=nyadb
export NLS_LANG=American_America.AL32UTF8
ADMINUSER=NYADBA
ADMINPASS=nyadba
EXPUSER=SOE
TNS=nyapdb1
EXP_PATH=/u01/app/oracle/dpdump
DIROBJ_NAME=EXP_DIR
TIMESTAMP=`date +"%Y%m%d_%H%M%S"`
MODE=METADATA_ONLY
BASE_NAME=${ORACLE_SID}_${EXPUSER}_STATS
DMP_NAME=${BASE_NAME}.dmp
LOG_NAME=${BASE_NAME}_${TIMESTAMP}.exp.log
JOB_NAME=JOB_${EXPUSER}_EXPSCHEMA_STATS

sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF | tee -a ${LOG_NAME}
set feed off
set line 1000
set pages 1000
col OWNER for a30
col DIRECTORY_NAME for a30
col DIRECTORY_PATH for a100
create or replace DIRECTORY ${DIROBJ_NAME} AS '${EXP_PATH}';
select DIRECTORY_NAME,DIRECTORY_PATH from DBA_DIRECTORIES where DIRECTORY_NAME='${DIROBJ_NAME}';
EOF

expdp ${ADMINUSER}/${ADMINPASS}@${TNS} \
  SCHEMAS=${EXPUSER} \
  DIRECTORY=${DIROBJ_NAME} \
  DUMPFILE=${DMP_NAME} \
  LOGFILE=${LOG_NAME} \
  CONTENT=${MODE} \
  LOGTIME=ALL \
  METRICS=YES  

sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF
set feed off
drop DIRECTORY ${DIROBJ_NAME};
EOF

ls -l ${EXP_PATH}/${BASE_NAME}*
cat ${EXP_PATH}/${LOG_NAME} >> ${LOG_NAME}
