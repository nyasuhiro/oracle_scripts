#!/bin/bash

export ORACLE_SID=nyadb
export NLS_LANG=American_America.AL32UTF8

ADMINUSER=NYADBA
ADMINPASS=nyadba
IMPUSER=SOE
IMPPASS=soe
TNS=nyapdb1

DMP_PATH=/u01/app/oracle/dpdump
DIROBJ_NAME=IMP_DIR

MODE=ALL
TS_ACTION=SKIP

TIMESTAMP=`date +"%Y%m%d_%H%M%S"`
BASE_NAME=${ORACLE_SID}_${IMPUSER}_${MODE}
DMP_NAME=${BASE_NAME}.dmp
LOG_NAME=${BASE_NAME}_${TIMESTAMP}.imp.log
JOB_NAME=JOB_${IMPUSER}_IMPSCHEMA

sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF | tee -a ${LOG_NAME}
set feed off
drop user ${IMPUSER} cascade;
EOF

sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF | tee -a ${LOG_NAME}
set feed off
set line 1000
set pages 1000
col OWNER for a30
col DIRECTORY_NAME for a30
col DIRECTORY_PATH for a100
create or replace DIRECTORY ${DIROBJ_NAME} AS '${DMP_PATH}';
select DIRECTORY_NAME,DIRECTORY_PATH from DBA_DIRECTORIES where DIRECTORY_NAME='${DIROBJ_NAME}';
EOF

impdp ${ADMINUSER}/${ADMINPASS}@${TNS} \
  SCHEMAS=${IMPUSER} \
  DIRECTORY=${DIROBJ_NAME} \
  DUMPFILE=${DMP_NAME} \
  LOGFILE=${LOG_NAME} \
  CONTENT=${MODE} \
  LOGTIME=ALL \
  TABLE_EXISTS_ACTION=${TS_ACTION} \
  METRICS=YES  

sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF
set feed off
drop DIRECTORY ${DIROBJ_NAME};
EOF

ls -l ${DMP_PATH}/${BASE_NAME}*
cat ${DMP_PATH}/${LOG_NAME} >> ${LOG_NAME}


# GRANT for swintbench
sqlplus -s ${ADMINUSER}/${ADMINPASS}@${TNS} << EOF | tee -a ${LOG_NAME}
set feed off
GRANT EXECUTE ON DBMS_LOCK TO ${IMPUSER};
EOF

# COMPILE PACKAGE for swingbench
sqlplus -s ${IMPUSER}/${IMPPASS}@${TNS} << EOF | tee -a ${LOG_NAME}
set feed off
ALTER PACKAGE ORDERENTRY COMPILE; 
EOF
