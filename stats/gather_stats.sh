#!/bin/bash

export ORACLE_SID=nyadb
export USER=SOE
export PASS=soe
export TNS=nyapdb1

BASENAME=gather_stats
SQLFILE=${BASENAME}.sql

TABLELIST=`sqlplus -s ${USER}/${PASS}@${TNS} << EOF
set head off
set feed off
select TABLE_NAME from user_tables order by TABLE_NAME;
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
echo "spool gather_stats_&log_date..log"
echo ""
} > ${SQLFILE}

for TABLE in ${TABLELIST[@]}
do
  {
    echo "exec dbms_stats.gather_table_stats( -"
    echo "       ownname=>'${USER}', -"
    echo "       tabname=>'${TABLE}', -"
    echo "       estimate_percent=>100, -"
    echo "       method_opt=>'FOR ALL COLUMNS SIZE 1', -"
    echo "       cascade=>true);"
  } >> ${SQLFILE}
done

{
echo ""
echo "spool off"
echo "exit"
} >> ${SQLFILE}

sqlplus ${USER}/${PASS}@${TNS} @${SQLFILE}
