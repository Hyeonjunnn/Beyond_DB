-- 서브 쿼리 실습
-- 하나의 SQL 문 안에 포함된 또 다른 SQL 문을 서브 쿼리라 한다.

-- 서브 쿼리 예시
-- 노옹철 사원과 같은 부서원들을 조회
-- 1) 노옹철 사원의 부서 코드를 조회
SELECT emp_name,
		 dept_code
FROM employee
WHERE emp_name = '노옹철'
;

-- 2) 부서 코드가 노옹철 사원의 부서 코드와 동일한 사원들을 조회
SELECT emp_name,
		 dept_code
FROM employee
WHERE dept_code = 'D9'
;

-- 3) 위의 2단계를 서브 쿼리를 사용하여 하나의 쿼리문으로 작성
SELECT emp_name,
		 dept_code
FROM employee
WHERE dept_code = (
	SELECT dept_code
   FROM employee
   WHERE emp_name = '노옹철'
	)
;

-- 서브 쿼리 구분
-- 서브 쿼리는 서브 쿼리를 수행한 결과값의 행과 열의 개수에 따라서 분류할 수 있다.

-- 1) 단일행 서브 쿼리
-- 서브 쿼리의 조회 결과 값의 개수가 1개 일 때

-- 전 직원의 평균 급여보다 더 많은 급여를 받고 있는 직원들의
-- 사번, 직원명, 직급 코드, 급여를 조회
SELECT emp_id,
		 emp_name,
		 job_code,
		 salary
FROM employee
WHERE salary >= (SELECT AVG(salary)
						 FROM employee
					 )
;

-- 노옹철 사원의 급여보다 더 많이 받는 사원의 사번, 직원명, 부서명, 급여 조회
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 B.dept_title AS '부서명',
		 A.salary AS '급여'
FROM employee A
LEFT OUTER JOIN department B
				 ON A.dept_code = B.dept_id 
WHERE A.salary > (SELECT salary
						FROM employee
						WHERE emp_name = '노옹철'
						)
;

-- 2) 다중행 서브 쿼리
-- 서브 쿼리의 조회 결과 값의 개수가 여러 행 일 때

-- 각 부서별 최고 급여를 받는 직원의 이름, 직급 코드, 부서 코드, 급여 조회
SELECT emp_name,
		 job_code,
		 dept_code,
		 salary
FROM employee
-- WHERE salary IN (2890000,3660000,2490000,3760000,3900000,2550000,8000000)
WHERE salary IN (SELECT MAX(salary)
					  FROM employee
					  GROUP BY dept_code
					  )
ORDER BY dept_code 					  
;

-- 직원들의 사번, 직원명, 부서 코드, 구분(사원/사수) 조회
-- 사수에 해당하는 사번을 조회
SELECT DISTINCT manager_id	 
FROM employee
WHERE manager_id IS NOT NULL
;

-- SELECT 절에 서브 쿼리를 사용하는 방법
SELECT emp_id AS '사번',
		 emp_name AS '직원명',
		 dept_code AS '부서 코드',
		 CASE
		 	when emp_id IN (SELECT DISTINCT manager_id	 
								 FROM employee
								 WHERE manager_id IS NOT NULL
								) then '사수'
		 	ELSE '사원'
		 END AS '구분'
FROM employee
;

-- 대리 직급임에도 과장 직급들의 최소 급여보다 많이 받는
-- 직원의 사번, 이름, 직급 코드, 급여 조회
-- ANY는 서브 쿼리의 결과 중 하나라도 조건을 만족하면 참이 된다.
SELECT emp_id AS '사번',
		 emp_name AS '이름',
		 job_code AS '직급 코드',
		 salary AS '급여 조회'
FROM employee
WHERE job_code = 'J6' 
  AND salary > ANY(SELECT salary
					    FROM employee
					    WHERE job_code = 'J5'
					   )
;

-- 과장 직급임에도 차장 직급의 최대 급여보다 더 많이 받는 작원들의
-- 직원의 사번, 이름, 직급 코드,급여 조회
-- ALL은 서브 쿼리의 결과 모두가 조건을 만족하면 참이 된다.
SELECT emp_id AS '사번',
		 emp_name AS '이름',
		 job_code AS '직급 코드',
		 salary AS '급여'
FROM employee
WHERE job_code = 'J5'
  AND salary > ALL(SELECT salary
					    FROM employee
					    WHERE job_code = 'J4'
					   )
;

-- 3) 다중열 서브 쿼리
-- 서브 쿼리의 조회 결과 값은 항 행이지만 열의 수가 여러개 일 때

-- 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당하는 사원들을 조회
-- 하이유 사원의 부서 코드와 직급 코드를 조회
SELECT emp_name AS '직원명',
		 dept_code AS '부서 코드',
		 job_code AS '직급 코드'
FROM employee
-- WHERE (dept_code, job_code) = (SELECT dept_code,
-- 		 											job_code
-- 										 FROM employee
-- 										 WHERE emp_name = '하이유'
-- 										 )
WHERE (dept_code, job_code) IN (SELECT dept_code,
													 job_code
											FROM employee
											WHERE emp_name = '하이유'
											)

;

-- 박나라 사원과 직급 코드가 일치하면서 같은 사수를 가지고 있는
-- 사원들의 사번, 직원명, 직급 코드, 사수 사번 조회

-- 박나라 사원의 직급 코드와 사수의 사번을 조회
SELECT job_code,
		 manager_id
FROM employee
WHERE emp_name = '박나라';

-- 다중열 서브 쿼리를 사용해서 쿼리를 작성
SELECT emp_id AS '사번',
		 emp_name AS '직원명',
		 job_code AS '직급 코드',
		 manager_id AS '사수 사번'
FROM employee
WHERE (job_code, manager_id) IN (SELECT job_code,
		 											 manager_id
											FROM employee
										   WHERE emp_name = '박나라'
											)
;

-- 4) 다중행 다중열 서브 쿼리
-- 서브 쿼리의 조회 결과값이 여러 행, 여러 열 일 때

-- 각 부서별 최고 급여를 받는 직원의 사번, 직원명, 부서 코드, 급여 조회
-- 부서별 최고 급여 조회
SELECT dept_code,
		 MAX(salary)
FROM employee
GROUP BY dept_code
;

-- 각 부서별 최고 급여를 받는 직원들을 조회
SELECT emp_id,
		 emp_name,
		 dept_code,
		 salary
FROM employee
WHERE (dept_code, salary) IN (SELECT dept_code,
									 			 MAX(salary)
										FROM employee
										GROUP BY dept_code
										)
ORDER BY dept_code
;

-- 각 직급별로 최소 급여를 받는 사원들의 사번, 직원명, 직급 코드, 급여 조회
-- 각 직급별 최소 급여 조회
SELECT MIN(salary)
FROM employee
GROUP BY job_code
;						

-- 다중행, 다중열 서브 쿼리를 사용해서 조회
SELECT emp_id AS '사번',
		 emp_name AS '직원명',
		 job_code AS '직급 코드',
		 salary AS '급여'
FROM employee
WHERE salary IN (SELECT MIN(salary)
						FROM employee
						GROUP BY job_code
						)
ORDER BY job_code
;

-- 인라인 뷰
-- FROM 절에 서브 쿼리를 작성하고
-- 서브 쿼리를 수행한 결과를 테이블 대신에 사용한다.
SELECT A.*
FROM (SELECT emp_id AS '사번',
				 emp_name AS '이름',
				 salary AS '급여',
				 salary * 12 AS '연봉'
		FROM employee
		) A
;

-- employee 테이블에서 급여로 순위를 매겨서 출력
SELECT A.num,
		 A.emp_name,
		 A.salary
FROM (SELECT ROW_NUMBER() OVER(ORDER BY salary DESC) AS 'num',
		 		 emp_name,
		 		 salary
		FROM employee) A
WHERE A.num BETWEEN 6 AND 10
;








