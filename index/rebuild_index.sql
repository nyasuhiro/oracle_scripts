set echo on 
set time on 
set timing on

column log_date new_value log_date noprint
select to_char(sysdate,'yyyymmdd_HH24MISS') log_date from dual;

spool index_rebuild_&log_date..log

alter index ADDRESS_CUST_IX rebuild online;
alter index ADDRESS_PK rebuild online;
alter index CARDDETAILS_CUST_IX rebuild online;
alter index CARD_DETAILS_PK rebuild online;
alter index CUSTOMERS_PK rebuild online;
alter index CUST_ACCOUNT_MANAGER_IX rebuild online;
alter index CUST_DOB_IX rebuild online;
alter index CUST_EMAIL_IX rebuild online;
alter index CUST_FUNC_LOWER_NAME_IX rebuild online;
alter index INVENTORY_PK rebuild online;
alter index INV_PRODUCT_IX rebuild online;
alter index INV_WAREHOUSE_IX rebuild online;
alter index ORDER_PK rebuild online;
alter index ORD_CUSTOMER_IX rebuild online;
alter index ORD_ORDER_DATE_IX rebuild online;
alter index ORD_SALES_REP_IX rebuild online;
alter index ORD_WAREHOUSE_IX rebuild online;
alter index ITEM_ORDER_IX rebuild online;
alter index ITEM_PRODUCT_IX rebuild online;
alter index ORDER_ITEMS_PK rebuild online;
alter index PRD_DESC_PK rebuild online;
alter index PROD_NAME_IX rebuild online;
alter index PRODUCT_INFORMATION_PK rebuild online;
alter index PROD_CATEGORY_IX rebuild online;
alter index PROD_SUPPLIER_IX rebuild online;
alter index WAREHOUSES_PK rebuild online;
alter index WHS_LOCATION_IX rebuild online;

spool off
exit
