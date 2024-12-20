-- 뷰 실습
-- 1. 뷰 생성
-- 사원들의 사번, 직원명, 부서명, 직급명, 입사일
CREATE VIEW v_employee
AS (SELECT A.emp_id,
		 	  A.emp_name,
		 	  B.dept_title,
		 	  C.job_name,
		 	  A.hire_date
FROM employee A
LEFT OUTER JOIN department B
				 ON A.dept_code = B.dept_id
LEFT OUTER JOIN job C
				 ON A.job_code = C.job_code
);

-- 가상의 테이블로 실제 데이터가 담겨있는 것은 아니다.
SELECT *
FROM v_employee;

-- 직급이 대리인 사원의 모든 데이터 조회
SELECT *
FROM v_employee
WHERE job_name = '대리'
;

-- 부서가 없는 사원의 모든 데이터 조회
SELECT *
FROM v_employee
WHERE dept_title IS NULL
;

-- 사원의 사번, 직원명, 성별, 급여 조회할 수 있는 뷰를 생성
-- SELECT 절에 함수나 산술 연산이 기술되어 있는 경우 별칭을 지정해야 한다.
CREATE OR REPLACE VIEW v_employee
AS (SELECT emp_id,
			  emp_name,
			  IF(SUBSTRING(emp_no, INSTR(8, 1) - 1) = '1', '남자', '여자') AS gender,
			  salary
	 FROM employee)
;

SELECT emp_name,
		 gender
FROM v_employee;

-- 2. 뷰 수정
-- 회원의 아이디, 이름, 구매 제품, 주소, 연락처를 조회하는 뷰를 생성
CREATE VIEW v_userbuytbl
AS (SELECT A.userId,
		 	  A.uname,
		 	  B.prodName,
		 	  A.addr,
		 	  CONCAT(A.mobile1, A.mobile2)
	FROM usertbl A
	LEFT OUTER JOIN buytbl B
					 ON A.userID = B.userID
	)
;

-- 뷰의 수정
ALTER VIEW v_userbuytbl
AS (SELECT A.userId,
		 	  A.uname,
		 	  B.prodName,
		 	  A.addr,
		 	  CONCAT(A.mobile1, A.mobile2) AS 'mobile'
	FROM usertbl A
	LEFT OUTER JOIN buytbl B
					 ON A.userID = B.userID
	)
;

-- 3. 뷰를 이용해서 DML(INSERT, UPDATE, DELETE) 사용
CREATE VIEW v_job
AS (SELECT *
	 FROM job
	)
;

-- SELECT
SELECT job_code,
		 job_name
FROM v_job
;

-- INSERT
INSERT INTO v_job 
VALUES ('J8', '알바')
;

-- UPDATE
UPDATE v_job
SET job_name = '인턴'
WHERE job_code = 'J8'
;

-- DELETE
DELETE
FROM v_job
WHERE job_code = 'J8'
;

-- 4. DML 조작이 불가능한 경우
-- 뷰 정의에 포함되지 않은 열을 조작하는 경우
CREATE OR REPLACE VIEW v_job
AS (SELECT job_code
	 FROM job
	)
;

-- INSERT
INSERT INTO v_job 
VALUES ('J8', '알바') -- 에러 발생
;

-- UPDATE
UPDATE v_job
SET job_name = '인턴'
WHERE job_code = 'J7' -- 에러 발생
;

-- DELETE
DELETE
FROM v_job
WHERE job_name = '사원' -- 에러 발생
;

-- 2) 산술 표현법으로 정의된 열을 조작하는 경우
CREATE VIEW v_emp_salary
AS (SELECT emp_id,
			  emp_name,
			  emp_no,
			  salary * 12 AS 'salary'
   FROM employee
	)
;

-- INSERT
INSERT INTO v_emp_salary
VALUES ('300', '홍길동', '950525-1234567', 30000000) -- 에러 발생
;

-- UPDATE
UPDATE v_emp_salary
SET salary = 30000000
WHERE emp_id = '200' -- 에러 발생
;

SELECT * FROM v_emp_salary;

-- 5. 뷰 옵션
-- WITH CHECK OPTION
-- 서브 쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류가 발생한다.
CREATE OR REPLACE VIEW v_employee
AS (SELECT *
	 FROM employee
	 WHERE salary >= 3000000
	)
WITH CHECK OPTION
;

-- 선동일 사원의 급여를 200만원으로 변경
-- 서브 쿼리의 조건에 부합하지 않기 때문에 변경이 불가능하다.
UPDATE v_employee
SET salary = 2000000
WHERE emp_id = '200'
;

-- 선동일 사원의 급여를 400만원으로 변경
-- 서브 쿼리의 조건에 부합하기 때문에 변경이 가능하다.
UPDATE v_employee
SET salary = 4000000
WHERE emp_id = '200'
;

SELECT *
FROM v_employee;

SELECT *
FROM employee;

-- 6. 뷰 삭제
DROP VIEW v_userbuyttb_departmentbl;
DROP VIEW v_employee, v_emp_salary, v_job;
