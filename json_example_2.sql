put file:///D:\Datasets\json\emp_data.json 


create or replace table my_json(Json_data variant)

copy into my_json from 
@my_stage/emp_data.json.gz
file_format = my_json

select * from my_json


select empd.value:kind,
  empd.value:fullName,
  empd.value:age,
  empd.value:gender,   
  empd.value:phoneNumber,
  empd.value:phoneNumber.areaCode, -- if data is in {} we have to use dot (.) notation, if data is inside [] (Array) the we have use the colon
  empd.value:phoneNumber.number ,
 -- empd.value:children ,-- flattening childrean 
  chldrn.value:name,
  chldrn.value:gender,
  chldrn.value:age,
  city.value:place,
  yr.value
  
from my_json emp,
  lateral flatten(input=>emp.Json_data:empDetails) empd , 
  lateral flatten(input=>empd.value:children, OUTER => TRUE) chldrn,  
  lateral flatten(input=>empd.value:citiesLived) city,
  lateral flatten(input=>city.value:yearsLived) yr
