 select department,count(*) from emp group by department

UPDATE EMP SET department='Finance'

select * from emp

update emp set department = 'xyz' where id = 1

-- by time  (how long we can travel back depends on table retention period)

SELECT * from EMP at(offset => -120*60);


-- statement

select * from EMP before(statement => '019ba41b-0000-11bb-0000-d3290004d536');

-- Time stamp

select * from EMP before(timestamp => '2021-04-17 02:31:56.786'::timestamp)

-- show tables ( explain about retention period)

-- drop database 

drop database demo_db

-- undrop database

undrop database demo_db

-- retnetion_time
show databases 

-- 
ALTER DATABASE demo_db SET DATA_RETENTION_TIME_IN_DAYS = 20;


ALTER TABLE emp SET DATA_RETENTION_TIME_IN_DAYS = 1;

--Once this retention period is over, your data will be moved to Fail-Safe.

select oldt.DEPARTMENT as old_department,newt.DEPARTMENT as new_department
  from emp before(statement => '019ba44d-0000-11bc-0000-d3290004c776') as oldt
    full outer join emp at(statement => '019ba408-0000-11bb-0000-d3290004d37e') as newt
    on oldt.id = newt.id
    
-- Recovery

create or replace table emp_backup
as select * from emp at(offset => -60*7.8);

show tables history;

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;


