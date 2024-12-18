-- INNER JOIN 실습
-- 각 사원들의 사번, 직원명, 부서 코드, 부서명 조회
SELECT emp_id AS '사번',
		 emp_name AS '사원명',
		 dept_id AS '부서 코드',
		 dept_title AS '부서명'
FROM employee
INNER JOIN department ON dept_code = dept_id
;

-- 각 사원들의 사번, 사원명, 직급 코드, 직급명 조회
-- 연결할 테이블의 열 이름이 같을 경우
-- 방법 1) 테이블명을 이용하는 방법
SELECT employee.emp_id AS '사번',
		 employee.emp_name AS '사원명',
		 job.job_code AS '직급 코드',
		 job.job_name AS '직급명'
FROM employee
INNER JOIN job ON employee.job_code = job.job_code
;

-- 방법 2) 테이블 별칭을 이용하는 방법
SELECT a.emp_id AS '사번',
		 a.emp_name AS '사원명',
		 b.job_code AS '직급 코드',
		 b.job_name AS '직급명'
FROM employee a
INNER JOIN job b ON a.job_code = b.job_code
;

-- 방법 3) NATURAL JOIN을 이용하는 방법 => 실제로는 사용X, 참고용
SELECT emp_id AS '사번',
		 emp_name AS '사원명',
		 job_code AS '직급 코드',
		 job_name AS '직급명'
FROM employee
NATURAL JOIN job
;

-- 실습 문제
-- usertbl 테이블과 buytbl 테이블을 조인하여
-- JYP라는 아이디를 가진 회원의 이름, 주소, 연락처, 주문 상품 이름을 조회
SELECT A.`name` AS '회원명',
		 A.addr AS '주소',
		 CONCAT(A.mobile1, A.mobile2) AS '연락처',
		 B.prodName AS '주문 상품 이름'
FROM usertbl A
INNER JOIN buytbl B
		  ON A.userID = B.userID
WHERE A.userID = 'JYP'
;

-- employee 테이블과 department 테이블을 조인하여 보너스를 받는 사원들의 사번, 직원명, 보너스, 부서명을 조회
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 (A.salary * A.bonus) AS '보너스',
		 B.dept_title AS '부서명'
FROM employee A
INNER JOIN department B
		  ON A.dept_code = B.dept_id
WHERE A.bonus IS NOT NULL
;

-- employee 테이블과 department 테이블을 조인하여 인사관리부가 아닌 사원들의 직원명, 부서명, 급여를 조회
SELECT A.emp_name AS '직원명',
		 B.dept_title AS '부서명',
		 A.salary AS '급여'
FROM employee A
INNER JOIN department B
		  ON A.dept_code = B.dept_id
WHERE B.dept_id != 'D1'
;

-- employee 테이블과 department 테이블, job 테이블을 조인하여 사번, 직원명, 부서명, 직급명 조회 
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 B.dept_title AS '부서명',
		 C.job_name AS '직급명'
FROM employee A
INNER JOIN department B
		  ON A.dept_code = B.dept_id
INNER JOIN job C
		  ON A.job_code = C.job_code
;

-- OUTER JOIN 실습
-- 1) LEFT OUTER JOIN
-- 부서 코드가 없던 사원들의 정보가 출력된다.
SELECT A.emp_name,
		 B.dept_id,
		 B.dept_title,
		 A.salary
FROM employee A
LEFT OUTER JOIN department B
/* LEFT JOIN department B */
				 ON A.dept_code = B.dept_id
ORDER BY A.dept_code
;

-- 2) RIGHT OUTER JOIN
SELECT A.emp_name,
		 B.dept_id,
		 B.dept_title,
		 A.salary
FROM employee A
RIGHT OUTER JOIN department B
/* RIGHT JOIN department B */
				 ON A.dept_code = B.dept_id
ORDER BY A.dept_code
;

-- CROSS JOIN 실습
SELECT emp_name,
		 dept_title
FROM employee
CROSS JOIN department
;

-- SELF JOIN 실습
-- employee 에티블을 SELF JOIN하여 사번, 직원명, 부서 코드, 사수 사번, 사수명 조회
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 A.dept_code AS '부서 코드',
		 A.manager_id AS '사수 사번',
		 B.emp_name AS '사수명'
FROM employee A
INNER JOIN employee B
		  ON A.manager_id = B.emp_id
;

-- employee 테이블을 LEFT OUTER JOIN하여 사번, 직원명, 부서 코드, 사수 사번, 사수명 조회
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 A.dept_code AS '부서 코드',
		 A.manager_id AS '사수 사번',
		 B.emp_name AS '사수명'
FROM employee A
LEFT OUTER JOIN employee B
    		    ON A.manager_id = B.emp_id
;

-- NON EQUAL JOIN 실습
-- 조인 조건에 등호(=)를 사용하지 않는 조인문을 비등가 조인이라고 한다.
-- employee 테이블과 sal_grade 테이블을 비등가 조인하여 직원명, 급여, 급여 등급 조회
SELECT A.emp_name AS '직원명',
		 A.salary AS '급여',
		 B.sal_level AS '급여 등급'
FROM employee A
INNER JOIN sal_grade B
--        ON A.salary >= B.min_sal AND A.salary <= B.max_sal
        ON A.salary BETWEEN B.min_sal AND B.max_sal
;

-- 실습 문제
-- 이름에 '형'자가 들어있는 직원들의 사번, 직원명, 직급명을 조회
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 B.job_name AS '직급명'
FROM employee A
LEFT OUTER JOIN job B
			    ON A.job_code = B.job_code
WHERE A.emp_name LIKE '%형%'
;

-- 70년대생 이면서 여자이고, 성이 전 씨인 직원들의 직원명, 주민번호, 부서명, 직급명을 조회하세요.
SELECT A.emp_name AS '직원명',
		 A.emp_no AS '주민번호',
		 B.dept_title AS '부서명',
		 C.job_name AS '직급명'
FROM employee A
LEFT OUTER JOIN department B
			    ON A.dept_code = B.dept_id
LEFT OUTER JOIN job C
				 ON A.job_code = C.job_code
WHERE SUBSTRING(A.emp_no, 1, 2) LIKE '7%'
AND A.emp_name LIKE '전%'
;

-- 각 부서별 평균 급여를 조회하여 부서명, 평균 급여를 조회
-- 단, 부서 배치가 안된 사원들의 평균도 같이 나오게끔 조회해 주세요.
SELECT IFNULL(B.dept_title, '부서 없음') AS '부서명',
		 ROUND(AVG(A.salary)) AS '평균 급여'
FROM employee A
LEFT OUTER JOIN department B
				 ON A.dept_code = B.dept_id
GROUP BY A.dept_code
;

-- 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회
SELECT B.dept_title AS '부서명',
		 SUM(A.salary) AS '조회'
FROM employee A
LEFT OUTER JOIN department B
				 ON A.dept_code = B.dept_id
GROUP BY A.dept_code
HAVING SUM(A.salary) >= 10000000
;

-- 해외영업팀에 근무하는 직원들의 직원명, 직급명, 부서 코드, 부서명을 조회
SELECT A.emp_name AS '직원명',
		 B.job_name AS '직급명',
		 C.dept_id AS '부서 코드',
		 C.dept_title AS '부서명'
FROM employee A
LEFT OUTER JOIN job B
				 ON A.job_code = B.job_code
LEFT OUTER JOIN department C
				 ON A.dept_code = C.dept_id
WHERE C.location_id != 'L1'
;

-- 테이블을 다중 JOIN 하여 사번, 직원명, 부서명, 지역명, 국가명 조회
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 B.dept_title AS '부서명',
		 C.local_name AS '지역명',
		 D.national_name AS '국가명'
FROM employee A
LEFT OUTER JOIN department B
				 ON A.dept_code = B.dept_id
LEFT OUTER JOIN location C
				 ON B.location_id = C.local_code
LEFT OUTER JOIN national D
				 ON C.national_code = D.national_code
;

-- 테이블을 다중 JOIN 하여 사번, 직원명, 부서명, 지역명, 국가명, 급여 등급 조회
SELECT A.emp_id AS '사번',
		 A.emp_name AS '직원명',
		 B.dept_title AS '부서명',
		 C.local_name AS '지역명',
		 D.national_name AS '국가명',
		 E.sal_level AS '급여 등급'
FROM employee A
LEFT OUTER JOIN department B
				 ON A.dept_code = B.dept_id
LEFT OUTER JOIN location C
				 ON B.location_id = C.local_code
LEFT OUTER JOIN national D
				 ON C.national_code = D.national_code
LEFT OUTER JOIN sal_grade E
				 ON A.salary BETWEEN E.min_sal AND E.max_sal
;

-- 부서가 있는 직원들의 직원명, 직급명, 부서명, 지역명을 조회하시오.
SELECT A.emp_name AS '직원명',
		 B.job_name AS '직급명',
		 C.dept_title AS '부서명',
		 D.local_name AS '지역명'
FROM employee A
LEFT OUTER JOIN job B
				 ON A.job_code = B.job_code
LEFT OUTER JOIN department C
				 ON A.dept_code = C.dept_id
LEFT OUTER JOIN location D
				 ON C.location_id = D.local_code
WHERE C.dept_id IS NOT NULL
;

-- 한국과 일본에서 근무하는 직원들의 직원명, 부서명, 지역명, 근무 국가를 조회하세요.
SELECT A.emp_name AS '직원명',
		 B.dept_title AS '부서명',
		 C.local_name AS '지역명',
		 D.national_name AS '근무 국가'
FROM employee A
LEFT OUTER JOIN department B
				 ON A.dept_code = B.dept_id
LEFT OUTER JOIN location C
				 ON B.location_id = C.local_code
LEFT OUTER JOIN national D
				 ON C.national_code = D.national_code				 
WHERE D.national_code IN ('KO', 'JP')			 
;

-- UNION / UNION ALL 연산자 실습
-- employee 테이블에서 부서 코드가 D5인 사원들의 사번, 직원명, 부서 코드, 급여 조회
-- 1) UNION 연산자
SELECT emp_id,
		 emp_name,
		 dept_code,
		 salary
FROM employee
WHERE dept_code = 'D5'

UNION

SELECT emp_id,
		 emp_name,
		 dept_code,
		 salary
FROM employee
WHERE salary >= 3000000
;


-- 2) UNION ALL 연산자
SELECT emp_id,
		 emp_name,
		 dept_code,
		 salary
FROM employee
WHERE dept_code = 'D5'

UNION ALL

SELECT emp_id,
		 emp_name,
		 dept_code,
		 salary
FROM employee
WHERE salary >= 3000000
;



