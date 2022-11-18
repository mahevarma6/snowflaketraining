drop database demo
create database demo

-- Main table
create or replace table profile_info
(starttime timestamp,
 profile_name string
)

-- Stage table

create or replace table profile_stage
(starttime timestamp,
 profile_name string
)

-- create stream
create or replace stream my_stream on table profile_stage

-- check stream
show streams

--select streams
select * from my_stream

-- insert into stage table 

insert into profile_stage values(to_timestamp_ntz(current_timestamp()),'stream');

--check the stream if it has data or not
select system$stream_has_data('my_stream')

check the insert/update/delete scenarios on base table and see how data is reflecting on streams

