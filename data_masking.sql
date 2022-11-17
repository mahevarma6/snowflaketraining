use role sysadmin ;

create a new virtual warehouse with sysadmin role

create or replace table DEMO_DB.PUBLIC.employee_info(employee_id number,
                     empl_join_date date,
                     dept varchar(10),
                     salary number,
                     manager_id number);

-- insert values into employee table
insert into  DEMO_DB.PUBLIC.employee_info values(1,'2020-10-01','HR',40000,4),
                                 (2,'2020-09-01','Technical',100000,9),
                                 (3,'2020-09-01','Marketing',50000,5),
                                 (4,'2020-09-01','HR',20000,5),
                                 (5,'2020-09-01','HR',35000,9),
                                 (6,'2021-09-01','Technical',90000,4),
                                 (7,'2021-09-01','Marketing',10000,1);

insert into  DEMO_DB.PUBLIC.employee_info values
                                 (8,'2021-09-01','R&D',20000,230);
                                 
                                 
                                 
select * from  DEMO_DB.PUBLIC.employee_info;


USE ROLE ACCOUNTADMIN;

--Currently Snowflake does not support different input output datatype for Masking Policy
create or replace masking policy sensitive_info_masking_string as (val STRING) returns STRING ->
  case
    when current_role() in ('ACCOUNTADMIN') then val
    else '****************'
  end;
  
create or replace masking policy sensitive_info_masking_numbers as (val NUMBER) returns NUMBER ->
  case
    when current_role() in ('ACCOUNTADMIN') then (val)
    else 9999999
  end;

  
  
  
-- apply masking policy to a table column
ALTER TABLE IF EXISTS DEMO_DB.PUBLIC.employee_info MODIFY COLUMN dept SET MASKING POLICY sensitive_info_masking_string; 
ALTER TABLE IF EXISTS DEMO_DB.PUBLIC.employee_info MODIFY COLUMN salary SET MASKING POLICY sensitive_info_masking_numbers; 

select * from  DEMO_DB.PUBLIC.employee_info ;
 

use role SYSADMIN;
 
SELECT * from DEMO_DB.PUBLIC.employee_info;


Create or replace view  DEMO_DB.PUBLIC.employee_set as select * from DEMO_DB.PUBLIC.employee_info;

select * from DEMO_DB.PUBLIC.employee_set;

use role ACCOUNTADMIN;


--Describe Masking Policy

DESC MASKING POLICY sensitive_info_masking_numbers;


--RECREATE MASKING POLICY
create or replace masking policy sensitive_info_masking_numbers as (val STRING) returns STRING ->
  case
    when current_role() not in ('ACCOUNTADMIN') then val
    else '****************'
  end;

--UNSET MASKING POLICY

ALTER TABLE IF EXISTS DEMO_DB.PUBLIC.employee_info MODIFY COLUMN dept UNSET MASKING POLICY;


ALTER TABLE IF EXISTS DEMO_DB.PUBLIC.employee_info MODIFY COLUMN dept SET MASKING POLICY sensitive_info_masking_numbers;
