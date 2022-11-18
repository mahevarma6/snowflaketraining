-Context
use role accountadmin;
use database demo;
use schema public;
use warehouse demo_wh;
 
--Show all Tasks in Account
show tasks in account;
 
--Show all Tasks in Demo Database
show tasks;
--grant execute task on account to role taskadmin;

--Create a Task Warehouse
create warehouse if not exists task_wh with warehouse_size = 'xsmall' auto_suspend = 60;

--Create Generic 5 Task Dependant Workflow to Work from Snowflake Sample Data
/*-------------------------------------------------------------------------------------------------------------------------
T01_CTAS
T02_INSERT_SAMPLE
T03_CTAS_AGG
T04_INSERT_AGG
T05_DELETE_SAMPLE
-------------------------------------------------------------------------------------------------------------------------*/
--Task 01 CTAS
create or replace task demo.public.t01_ctas
  warehouse = task_wh
  schedule = '15 minute'
--SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles'
as
  create table tbl_sample if not exists as select * from snowflake_sample_data.tpcds_sf10tcl.store_sales limit 1;
;
 
--Start the Task
alter task demo.public.t01_ctas resume;
--Stop the Task to Add Child Tasks
alter task demo.public.t01_ctas suspend;
 
--Task History
select *
from table(
  information_schema.task_history(
  scheduled_time_range_start=>dateadd('hour',-24,current_timestamp()),
  result_limit => 100,
  task_name=>'t01_ctas'));
 
--Task 02 INSERT SAMPLE
create or replace task demo.public.t02_insert_sample
  warehouse = task_wh
  after demo.public.t01_ctas
as
  insert into tbl_sample (select * from (select * from snowflake_sample_data.tpcds_sf10tcl.store_sales sample block (0.5)))
;
 
--Task 03 CTAS AGG
create or replace task demo.public.t03_ctas_agg
  warehouse = task_wh
  after demo.public.t02_insert_sample
as
  create table tbl_sample_agg if not exists as
      select d_date,
      sum(ss_quantity) as sum_ss_quantity,
      sum(ss_ext_sales_price) as sum_ss_ext_sales_price
      from tbl_sample ts
      join snowflake_sample_data.tpcds_sf10tcl.date_dim dd on ts.ss_sold_date_sk = dd.d_date_sk
      group by d_date
      order by d_date desc;
;
 
--Task 04 INSERT AGG
create or replace task demo.public.t04_insert_agg
  warehouse = task_wh
  after demo.public.t03_ctas_agg
as
  insert into tbl_sample_agg (
      select d_date,
      sum(ss_quantity) as sum_ss_quantity,
      sum(ss_ext_sales_price) as sum_ss_ext_sales_price
      from tbl_sample ts
      join snowflake_sample_data.tpcds_sf10tcl.date_dim dd on ts.ss_sold_date_sk = dd.d_date_sk
      group by d_date
      order by d_date desc)
;
 
--Task 05 DELETE SAMPLE
create or replace task demo.public.t05_delete_sample
  warehouse = task_wh
  after demo.public.t04_insert_agg
as
  delete from tbl_sample
;
 
--Start the Task Group
alter task demo.public.t05_delete_sample resume;
alter task demo.public.t04_insert_agg resume;
alter task demo.public.t03_ctas_agg resume;
alter task demo.public.t02_insert_sample resume;
alter task demo.public.t01_ctas resume;
 
--Depedencies
show tasks;

