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






