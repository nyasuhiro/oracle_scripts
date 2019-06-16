#!/bin/bash

export ORACLE_SID=nyadb
export USER=NYADBA
export PASS=nyadba
export TNS=nyapdb1

if [ $# -ne 1 ];then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには1個の引数が必要です。" 1>&2
  echo "実行例：sh awrsqlrpt.sh <AWRレポートファイル名>" 1>&2
  exit 1
fi

if [ ! -f $1 ]; then
  echo "ファイル：$1は存在しません。" 1>&2
  echo "実行例：sh awrsqlrpt.sh <AWRレポートファイル名>" 1>&2
  exit 1
fi

export AWRFILE=$1 
export BEGIN_SNAP=`cat ${AWRFILE} |grep "Begin Snap:" | awk '{print $3}'`
export END_SNAP=`cat ${AWRFILE} |grep "End Snap:" | awk '{print $3}'`

export SQL_LIST=`sqlplus -s ${USER}/${PASS}@${TNS} << EOF
set head off
set feed off
set pages 0
select distinct SQL_ID from DBA_HIST_SQLSTAT where SNAP_ID in (${BEGIN_SNAP},${END_SNAP}) order by SQL_ID;
exit
EOF
`

for SQLID in ${SQL_LIST[@]}
do
sqlplus -s ${USER}/${PASS}@${TNS} << EOF
define report_type=text;
define awr_location=AWR_PDB;
define num_days=1;
define begin_snap=${BEGIN_SNAP};
define end_snap=${END_SNAP};
define sql_id=${SQLID};
define report_name=sqlrpt_${TNS}_${BEGIN_SNAP}_${END_SNAP}_${SQLID}.log;
@${ORACLE_HOME}/rdbms/admin/awrsqrpt.sql;
EOF
done

