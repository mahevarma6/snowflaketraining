-- Agenda
Snowflake Internal stage

1)user stage
2)table stage
3)Named stage

1)User stage (@~) : accessed by a single user but need to be copied into multiple tables.
limition : only accessed by one person

2)Table stage (@%) : Each table has a Snowflake stage allocated to it by default for storing files.
  This  stage  is  a  convenient  option  if  your  files  need  to  be  accessible
  to multiple users and only need to be copied into a single table.

3)Named stage (@) : - it is a database object, multiple users can access the data and we can copy data into multiple tables

create database demo

table stage :

create or replace table users_table_stage(
id number(30),first_name varchar(25),
LAST_NAME VARCHAR(25),
EMAIL VARCHAR(70),
GENDER VARCHAR(25),
IP_ADDRESS VARCHAR(25)
);

list @%users_table_stage


put file:///D:\Datasets\users_dataset @%users_table_stage


select * from users_table_stage

copy into users_table_stage
from @%users_table_stage
file_format = ( type = 'csv' skip_header = 1)


remove @%USERS_TABLE_STAGE/Users_data.csv.gz

----------------- NAMED STAGE ---------------------------------

create stage named_stage_example

describe stage named_stage_example

list @named_stage_example


copy into users_table_stage
from @named_stage_example
file_format = ( type = 'csv' skip_header = 1)
on_error = 'skip_file'

---------------------------------- user stage ---------------------------------------------
list @%users_table_stage -- table stage

list @~/users_table_stage


copy into users_table_stage
from @~/users_table_stage
file_format = ( type = 'csv' skip_header = 1)
on_error = 'skip_file'


