-- 스토어드 프로시저 실습
-- 프로시저 생성

DELIMITER $$
CREATE PROCEDURE userProc()
BEGIN
	SELECT * FROM usertbl;
END$$
DELIMITER ;	-- delimiter ; 띄우기

CALL userProc;

-- 매개 변수 사용
-- 회원의 이름을 입력받아 조회하는 프로시저 생성
DELIMITER $$
CREATE OR REPLACE PROCEDURE userProc(
	IN userName VARCHAR(10))
BEGIN
	SELECT * 
	FROM usertbl
	WHERE uname = userName;
END$$
DELIMITER ;

CALL userProc('이승기');

-- 회원의 주소와 전화번호 앞자리(010, 011, 018, ...)
-- 값을 받아서 조회하는 프로시저 생성
DELIMITER $$
CREATE OR REPLACE PROCEDURE userProc(
	IN userAddr VARCHAR(10),
		userMobile1 VARCHAR(3))
BEGIN
	SELECT * 
	FROM usertbl
	WHERE addr = userAddr
	  AND mobile1 = userMobile1;
END$$
DELIMITER ;

CALL userProc('서울', '011');

-- 사용자의 아이디를 입력받아서 이름을 돌려주는 프로시저 생성
-- 변수 선언
DELIMITER $$
CREATE OR REPLACE PROCEDURE userProc(
	IN id CHAR(8),
	OUT userName CHAR(20)
)
BEGIN
	SELECT uname
	INTO userName
	FROM usertbl
	WHERE userID = id;
END $$
DELIMITER ;

CALL userProc('SSK', @uname);

SELECT @uname;

-- if 실습
DELIMITER $$
CREATE OR REPLACE PROCEDURE empProc(
	IN id CHAR(3)
)
BEGIN 
	DECLARE `year` INT;
	
	SELECT YEAR(hire_date)
	INTO `year`
	FROM employee
	WHERE emp_id = id;
	
	IF `year` >= 2010 THEN
		SELECT '2010년대에 입사하셨네요!';
	ELSEIF `year` >= 2000 THEN
		SELECT '2000년 대에 입사하셨네요!';
   ELSE
   	SELECT '1900년 대에 입사하셨네요!';
   END IF;
END $$
DELIMITER ;

CALL empProc('209');

-- case 실습
DELIMITER $$
CREATE OR REPLACE PROCEDURE gradeProc(
	IN score TINYINT
)
BEGIN
	DECLARE grade CHAR(1);
	
	CASE
		WHEN score >= 90 
			THEN SET grade = 'A';
		WHEN score >= 80
			THEN SET grade = 'B';
		WHEN score >= 70
			THEN SET grade = 'C';
		WHEN score >= 60
			THEN SET grade = 'D';
		ELSE
			SET grade = 'F';
	END CASE;
	
	SELECT score AS '점수',
			 grade AS '등급';
END $$
DELIMITER ;

CALL gradeProc(59);

-- WHILE 실습
-- 1 ~ 10 까지의 합계
DELIMITER $$
CREATE OR REPLACE PROCEDURE sumProc()
BEGIN      
	DECLARE i INT;
	DECLARE `sum` INT;
           
	SET i = 1;
	SET `sum` = 0;
	        
	WHILE i <= 10 DO 
		SET `sum` = `sum` + i;
		SET i = i + 1;
	END WHILE;
	
	SELECT CONCAT('1부터 10까지의 합은 : ', `sum`);
END$$     
DELIMITER ;

CALL sumProc();

-- 구구단 출력
DELIMITER $$
CREATE OR REPLACE PROCEDURE multiProc(
	IN num INT
)
BEGIN
	DECLARE i INT;
	DECLARE result VARCHAR(100);
	
	SET i = 1;
	SET result = '';
		
	WHILE i < 10 DO
		SET result = CONCAT(result, num, ' X ', i, ' = ', num * i, '\n');
		SET i = i + 1;
	END WHILE;
	
	SELECT result;
END $$
DELIMITER ;

CALL multiProc(6);

-- 에러 처리 테스트
DELIMITER $$
CREATE OR REPLACE PROCEDURE errorProc()
BEGIN
	DECLARE CONTINUE HANDLER FOR 1146 
		SELECT '테이블이 없어요ㅠㅠ' AS '메시지';
	SELECT *
	FROM noTable;
END $$
DELIMITER ;

CALL errorProc();

-- 프로시저 삭제
DROP PROCEDURE empProc;
DROP PROCEDURE errorProc;
DROP PROCEDURE gradeProc;
DROP PROCEDURE multiProc;
DROP PROCEDURE sumProc;
DROP PROCEDURE userProc;