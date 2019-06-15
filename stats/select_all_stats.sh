#!/bin/bash

export ORACLE_SID=nyadb
USER=SOE
PASS=soe
TNS=nyapdb1

sqlplus ${USER}/${PASS}@${TNS} @select_table_stats.sql
sqlplus ${USER}/${PASS}@${TNS} @select_index_stats.sql
sqlplus ${USER}/${PASS}@${TNS} @select_column_stats.sql
