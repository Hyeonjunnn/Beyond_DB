-- https://dev.mysql.com/doc/index-other.html
-- 'employee data' 다운
-- cmd에서 'source employees.sql' 입력하여 employees 데이터베이스 생성

-- 인덱스 실습
-- 실행 계획 확인
SELECT * FROM employees;
EXPLAIN SELECT * FROM employees;

SELECT * FROM employees WHERE emp_no = 48730;
EXPLAIN SELECT * FROM employees WHERE emp_no = 48730;

SELECT * FROM employees WHERE first_name = 'moon';
EXPLAIN SELECT * FROM employees WHERE first_name = 'moon';

-- 인덱스 생성
CREATE INDEX idx_employees_first_name ON employees(first_name);

ANALYZE TABLE employees;

SELECT * FROM employees WHERE first_name = 'moon';
EXPLAIN SELECT * FROM employees WHERE first_name = 'moon';

CREATE INDEX idx_employees_first_name_last_name
    ON employees(first_name, last_name);

ANALYZE TABLE employees;

SELECT *
FROM employees
WHERE first_name = 'moon'
AND last_name = 'Yetto'
;

EXPLAIN SELECT * 
FROM employees 
WHERE first_name = 'moon' 
  AND last_name = 'Yetto'
;


