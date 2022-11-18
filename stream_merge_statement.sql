create or replace table source_table(id int, name string);

select * from source_table

create or replace  stream my_stream on table source_table;

select * from my_stream

-- Insert 3 rows into the source table.
insert into source_table values (0, 'John');
insert into source_table values (1, 'Roy');
insert into source_table values (2, 'Garry');

insert into source_table values (3, 'Jerry');
insert into source_table values (4, 'phill');
insert into source_table values (5, 'larry');

update source_table set name ='David' where id=0

delete from source_table where id=0

select * from source_table
-- Create consumer table

create or replace  
table target_table(id int, name string, stream_type string default null, rec_version number default 0,REC_DATE TIMESTAMP_LTZ);

select * from target_table
update source_table set name ='John paul' where id=0

 -- updating task

merge into target_table t
using my_stream s                                               
on t.id=s.id and (metadata$action='DELETE')
when matched and metadata$isupdate='FALSE' then update set rec_version=9999, stream_type='DELETE'
when matched and metadata$isupdate='TRUE' then update set rec_version=rec_version-1
when not matched then insert  (id,name,stream_type,rec_version,REC_DATE) 
values(s.id, s.name, metadata$action,0,CURRENT_TIMESTAMP() )





select * from source_table --3
select * from my_stream
select * from target_table


select SYSTEM$STREAM_HAS_DATA('my_stream')



 
