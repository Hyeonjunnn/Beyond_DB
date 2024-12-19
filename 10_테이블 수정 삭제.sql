-- 테이블 수정 실습
-- 1. 열의  추가, 수정, 삭제
-- 1) 열의 추가
-- usertbl 테이블에 homepage 열을 추가
ALTER TABLE usertbl ADD homepage VARCHAR(30);

-- usertbl 테이블에 gender 열을 추가 (단, 기본값을 남자로 지정)
ALTER TABLE usertbl ADD gender CHAR(2) DEFAULT '남자' NOT NULL;

-- usertbl 테이블에 age 열을 추가(단, 기본값을 0으로, birthYear 뒤에 생성)
ALTER TABLE usertbl ADD age TINYINT DEFAULT 0 AFTER birthYear;

SELECT * FROM usertbl;

-- 2) 열의 수정
-- usertbl 테이블에서 name 열의 데이터 유형을 CHAR(15), NULL 허용으로 변경
ALTER TABLE usertbl MODIFY `name` CHAR(15) NULL;

-- usertbl 테이블에서 name 열의 데이터 유형을 CHAR(1), NOT NULL로 변경
-- 변경하려는 데이터 유형의 크기보다 이미 큰 값이 존재하기 때문에 에러 발생
ALTER TABLE usertbl MODIFY `name` CHAR(1) NOT NULL;

-- usertbl 테이블에서 name 열의 데이터 유형을 INT로 변경
-- 이미 name에 문자열이 저장되어 있기 때문에 에러 발생
ALTER TABLE usertbl MODIFY `name` INT NOT NULL;

-- usertbl 테이블에서 homepage 열의 데이터 유형을 INT로 변경
-- 값이 없으면 문자 타입을 정수 타입으로 변경이 가능하다.
ALTER TABLE usertbl MODIFY homepage INT;

-- usertbl 테이블에서 name 열의 이름을 uname으로 변경
ALTER TABLE usertbl RENAME COLUMN `name` TO uname;

ALTER TABLE usertbl RENAME COLUMN uname TO `name`;

-- 위 내용을 한 번에 변경
ALTER TABLE usertbl CHANGE COLUMN `name` uname VARCHAR(20) DEFAULT '없음' NOT NULL;

-- 3) 열의 삭제
-- usertbl 테이블에서 age, homepage, gender 열을 삭제
ALTER TABLE usertbl DROP COLUMN age;
ALTER TABLE usertbl DROP COLUMN homepage;
ALTER TABLE usertbl DROP COLUMN gender;

-- 참조되고 있는 열이 있다면 삭제가 불가능하다.
-- 제약 조건을 삭제하거나 참조하는 열이 없도록 한 후에 삭제해야 한다.
ALTER TABLE usertbl DROP COLUMN userid;

SELECT * FROM usertbl;

-- 실습 문제
CREATE TABLE tb_department(
	department_no VARCHAR(10),
	department_name VARCHAR(20) NOT NULL,
	category VARCHAR(20),
	open_yn CHAR(1),
	capacity INT,
	PRIMARY KEY(department_no)
);

CREATE TABLE tb_student(
	student_no VARCHAR(10) NOT NULL,
	department_no VARCHAR(10) REFERENCES td_department(department_no),
	student_name 
);




