#!/bin/bash

export ORACLE_SID=nyadb
export USER=SOE
export PASS=soe
export TNS=nyapdb1

BASENAME=rebuild_index
SQLFILE=${BASENAME}.sql

INDEXLIST=`sqlplus -s ${USER}/${PASS}@${TNS} << EOF
set head off
set feed off
select INDEX_NAME from user_indexes order by TABLE_NAME,INDEX_NAME;
exit;
EOF
`
{
echo "set echo on " 
echo "set time on "
echo "set timing on"
echo ""
echo "column log_date new_value log_date noprint"
echo "select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;"
echo ""
echo "spool index_rebuild_&log_date..log"
echo ""
} > ${SQLFILE}

for INDEX in ${INDEXLIST[@]}
do
  echo "alter index ${INDEX} rebuild online;" >> ${SQLFILE}
done

{
echo ""
echo "spool off"
echo "exit"
} >> ${SQLFILE}

sqlplus ${USER}/${PASS}@${TNS} @${SQLFILE}
