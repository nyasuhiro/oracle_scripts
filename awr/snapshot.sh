#!/bin/bash

export ORACLE_SID=nyadb
USER=NYADBA
PASS=nyadba
TNS=nyapdb1
SQLFILE=snapshot.sql

sqlplus ${USER}/${PASS}@${TNS} @${SQLFILE}
