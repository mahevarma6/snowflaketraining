################################################# JavaScript Stored Procedures ##############################################


----------------------------------- 1 JavaScript Stored Procedure - with if else Block -------------------------------------------

create or replace procedure proc_if_else_test(N1 float, N2 float)
 returns float not null
 language javascript
 as 
 $$
	if (N1>N2) 
    { 
    return N1
    }
    else 
    { 
    return N2
    }
 $$
 ; 

CALL proc_if_else_test(545, 70);


----------------------------------- 2 JavaScript Stored Procedure - with Switch statement -------------------------------------------

 create or replace procedure proc_switch_test()
 returns varchar not null
 language javascript
 as 
 $$
	switch (new Date().getDay()) {
	  case 0:
		return "Sunday";
		break;
	  case 1:
		return "Monday";
		break;
	  case 2:
		 return "Tuesday";
		break;
	  case 3:
		return "Wednesday";
		break;
	  case 4:
		return "Thursday";
		break;
	  case 5:
		return "Friday";
		break;
	  case 6:
		return "Saturday";
	}
 $$
 ; 
 
 CALL proc_switch_test()
 

----------------------------------- 3 JavaScript Stored Procedure - with While statement -------------------------------------------
 
 create or replace procedure proc_while_test()
 returns float not null
 language javascript
 as 
 $$
	var total = 0
	var i = 0
	while (i < 10) {
	  total = total + i	
	  i++;
	}
	return total
 $$
 ;
 
 CALL proc_while_test()
 
 
	
 
----------------------------------- 5 JavaScript Stored Procedure - For Loop  ------------------------------------------

 create or replace procedure proc_for_test()
 returns float not null
 language javascript
 as 
 $$
	var total = 0
	var i = 0
	for ( i = 0; i < 10; i ++)
	{
	  total = total + i	
	  i++;
	}
	return total
 $$
 ;
 
 CALL proc_for_test()
------------------------------------ 6 JavaScript Stored Procedure Row Count ----------------------------------------------------------

create or replace procedure get_row_count(table_name VARCHAR)
    returns float 
    not null
    language javascript
    as
    $$
                        var row_count = 0;
                        // Dynamically compose the SQL statement to execute.
                        // Note that we uppercased the input parameter name.
                       
                       
                        var sql_command = "select count(*) from " + TABLE_NAME;
                        
                        // Run the statement.
               
                        
                        var stmt = snowflake.createStatement(
                               {
                               sqlText: sql_command
                               }
                            );
                        var res = stmt.execute();
                        
                           
                        // Get back the row count. Specifically, ...
                        // ... first, get the first (and in this case only) row from the result set ...
                        res.next();
                        // ... then extract the returned value (which in this case is the number of rows in the table).
                        row_count = res.getColumnValue(1);
                        return row_count;
    $$
    ;
    
  -- Call Stored Procedure
  call get_row_count('DWH.DIMCUSTOMER');
  
  -- Verify data
  select count(*) from DWH.DIMCUSTOMER


------------------------------------ 7 JavaScript Stored Procedure Using Try Catch ----------------------------------------------------------
-- Executing multiple SQL Statements
-- Use of Try-Catch Statement for better error handling

CREATE OR REPLACE PROCEDURE SP_DMLOperations()
    returns string
    language javascript
   as
    $$

                 var PARAM1           = 35;
                 var PARAM2           = 'Prasad';
                 var SQL1_DropTable   = "DROP TABLE IF EXISTS SALES.DWH.USERS;";
                 var SQL2_CreateTable = "CREATE TABLE DWH.USERS (name varchar(50), age int);";
                 var SQL3_InsertData  = "INSERT INTO DWH.USERS (name, age) VALUES ('Prasad',30),('Satish',40);"
                 var SQL4_UpdateData  = "UPDATE DWH.USERS SET AGE = (" + PARAM1 + ") WHERE NAME = ('" + PARAM2 + "')";
          

                try {
                        
                        snowflake.execute({sqlText: SQL1_DropTable});
                        snowflake.execute({sqlText: SQL2_CreateTable});
                        
                        snowflake.execute({sqlText: SQL3_InsertData});
                        snowflake.execute({sqlText: SQL4_UpdateData});

                        return "Operation Succeeded.";   // Return a success/error indicator.
                    }
                catch (err)  
                    {
                        return "Operation Failed: " + err;   // Return a success/error indicator.
                    }
    $$
    ;
    
    
    
    -- Call Stored Procedure
    CALL SP_DMLOperations();
    
    SELECT * FROM SALES.DWH.USERS

CREATE OR REPLACE PROCEDURE SP_EXAMPLE1 (ID FLOAT)
returns Array
language javascript
as
$$
var query = 'select * from target_table where id = ?';
var statement = snowflake.createStatement({sqlText:query, binds : [ID]});
var resultset = statement.execute()

var res1 = []
while(resultset.next()){
res1.push(resultset.getColumnValue(2))

return res1;

}

$$ ;



Stored Procedure 

Step 1 -- Prepate Query Variable by Assigning a SQL Query 

Step 2 -- Var statement = snowflake.createStatement({sqlText : query, binds : [<input parameter]]}

Step 3 -- var resultset = statement.execute()


Java script is case Senstive we should pass all parameters in capital case

either we should bind input parameter with query or alternatively we can concat input parameters with query

to access each row from resultset, we need to call resultset.next() one time.


create or replace procedure Customer_Accnt_bal (C_CUSTKEY float) 
returns Array
language javascript
as
$$
var query = 'select * from "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER" where C_CUSTKEY = ?' ;
var SQL_statement = snowflake.createStatement({sqlText : query , binds : [C_CUSTKEY]}) ;
var resultSet = SQL_statement.execute()

var resultArray = []

while(resultSet.next()){

resultArray.push(resultSet.getColumnValue(1)) ;

}
return resultArray ;

$$

call Customer_Accnt_bal(30001)


$$


   
