set echo on 
set time on 
set timing on

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool gather_stats_&log_date..log

exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'ADDRESSES', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'CARD_DETAILS', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'CUSTOMERS', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'INVENTORIES', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'LOGON', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'ORDERENTRY_METADATA', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'ORDERS', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'ORDER_ITEMS', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'PRODUCT_DESCRIPTIONS', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'PRODUCT_INFORMATION', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);
exec dbms_stats.gather_table_stats( -
       ownname=>'SOE', -
       tabname=>'WAREHOUSES', -
       estimate_percent=>100, -
       method_opt=>'FOR ALL COLUMNS SIZE 1', -
       cascade=>true);

spool off
exit
