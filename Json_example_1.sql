select dept.$1:deptName::string dept_name,dept.$1:deptno,dept.$1:deptLocation,dept.$1:deptLocState,
emp.value:empno, emp.value:ename, emp.value:job, emp.value:hiredate
from @my_stage4 (file_format => 'my_json' ) dept,
lateral flatten (input=>$1:EmployeeDtls) emp
;
