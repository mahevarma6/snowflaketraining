use database my_db2

-- create s3 bucket --snowpipe009
-- create s3 policy --snowpipe06
-- create Role -- snowpipe06


-- create AWS integration object
create or replace storage integration aws_integration
type = external_stage
storage_provider = s3
enabled = true
storage_aws_role_arn = 'arn:aws:iam::317576894557:role/snowpipe06'  
storage_allowed_locations = ('s3://snowpipedemo06/');

desc integration aws_integration

D--5) STORAGE_AWS_IAM_USER_ARN
--6) Storage AWS External ID 

-- create a file format

create or replace file format my_csv
type = csv field_delimiter = ',' skip_header = 1;

--------------------------------------------- snowpipe ----------------------------
create or replace stage snowpipe_aws

url = 's3://snowdatasets/'
file_format = my_csv;

list @snowpipe_aws
--- create a table
create or replace table emp_aws  (id string, first_name string, last_name
string, email string,gender string,ip_address string )

select * from emp_aws
truncate table emp_aws

-- create snowpipe
create or replace pipe snowpipe_aws auto_ingest=true as
    copy into emp_aws
    from @snowpipe_aws
    file_format = (type = 'csv' skip_header = 1);
show pipes;
desc pipe snowpipe_aws

-- if auto ingest is set to false then we have to manullay refresh the pipe.
alter pipe snowpipe refresh;

--- snowpipe status
select SYSTEM$PIPE_STATUS('snowpipe_aws')

 
 alter pipe snowpipe_aws set PIPE_EXECUTION_PAUSED =  True
 
 alter pipe snowpipe_aws refresh;
 
 show pipes
 
 drop pipe 
 
-- PIPE_USAGE_HISTORY View

select * from "SNOWFLAKE"."ACCOUNT_USAGE"."PIPE_USAGE_HISTORY"

-- latency upto 3hrs

-- query the history of data loaded into Snowflake tables using Snowpipe within the last 365 days 

-----------------------scenarios -------------------------------------
--- If there is an error snowpipe will not give you any notification. 


-- Validate

select SYSTEM$PIPE_STATUS('snowpipe_aws')

select * from table(validate_pipe_load(
  pipe_name=>'snowpipe_aws',
  start_time=>dateadd(hour, -4, current_timestamp())));
  
select *
from table(information_schema.copy_history(table_name=>'emp_aws', start_time=> dateadd(hours, -1, current_timestamp())));



select *
from table(information_schema.query_history())
order by start_time desc;
  
------------------------------- SCENARIO 2 : You can't update copy command. You can only re create pipe

-- We go and rectify the copy command. Once copy command is rectified we expect data to be loaded to table.
select * from demo_db.public.emp_snowpipe;

show pipes;

-- re creating your pipe will not change your notification channel.

--arn:aws:sqs:us-east-1:628993367716:sf-snowpipe-AIDAZE4XND2SCZEJXXYBR-gmNjf-iFPpApjNiM7VwsSQ
--arn:aws:sqs:us-east-1:628993367716:sf-snowpipe-AIDAZE4XND2SCZEJXXYBR-gmNjf-iFPpApjNiM7VwsSQ

/**********************************************************/

-- SCENARIO 3 : What if you accidently truncated the table and want to load the data again.
-- In this scenraio will snowpipe copies emp1 and emp2 files again?


truncate table demo_db.public.emp_snowpipe;

select * from demo_db.public.emp_snowpipe;  
                                           
                                            
                                          
                                            
                                             
       

/**********************************************************/


