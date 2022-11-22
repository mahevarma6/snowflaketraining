
create database test2
---------------------------------------- 1 SQL UDF Example (Function Overloading example)-----------------------------------
 
create or replace function add5 (n number)
returns number
 as 'n + 5';
  
SELECT add5(10)

select C_ACCTBAL,add5(C_ACCTBAL) from "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"

create function add5 (s string)
  returns string
  as 's || '' 5''';
 
 -- Call UDF
 SELECT add5('Snowflake')
 
 ---------------------------------------- 2 SQL UDF Example  (Get Largest between two)-----------------------------------
 
 create or replace function sql_udf_bignum (n1 float, n2 float)
 returns float
 as 
 $$
	select case when n1 > n2 then n1 else n2 end
 $$
 ;
 
 SELECT sql_udf_bignum(36.5,88.54)
  -------------------------------------- 3 Nested SQL UDF Example --------------------------------------------------------------
 
 create or replace function nested_udf_test (n1 float, n2 float, n3 float, n4 float)
 returns float
 as 
 $$
    select 
      case 
         when sql_udf_bignum(n1, n2) > sql_udf_bignum(n3, n4) then sql_udf_bignum(n1, n2) 
         else sql_udf_bignum(n3, n4) 
         end
 $$
 ;
 
 select nested_udf_test(1,2,33,4) as largest_num;


-------------------------------------4 SQL Table User defined functions ----------------------------------------------

create function sql_table_functions()
returns table(msg varchar)
as
    $$
        select 'Hello'
        union
        select 'World'
    $$;

select * from table(sql_table_functions())
 
  -------------------------------------- 5 JavaScript UDF Example --------------------------------------------------------------
 
 create or replace function js_udf_bignum (n1 float, n2 float)
 returns float
 language javascript
 as 
 $$
	if (N1>N2) { return N1 } else { return N2}
 $$
 ;
 
 SELECT js_udf_bignum (78.69,40.0)
 
 

 
 -------------------------------------- 6 JavaScript UDF Example Using JavaScript APIs ----------------------------------------------------
 
 CREATE OR REPLACE FUNCTION array_sort(a array)
  RETURNS array
  LANGUAGE JAVASCRIPT
AS
$$
                return A.sort();
         
$$
;

-- Call the UDF with a small array.
SELECT ARRAY_SORT(PARSE_JSON('[2,4,5,3,1]'));

------------------------------------ 6 JavaScript UDF Example with Error Handling --------------------------------------

CREATE FUNCTION validate_ID(ID FLOAT)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS $$
    try {
        if (ID < 0) {
            throw "ID cannot be negative!";
        } else {
            return "ID validated.";
        }
    } catch (err) {
        return "Error: " + err;
    }
$$;

-- Call Function
SELECT validate_ID('mahesh')

