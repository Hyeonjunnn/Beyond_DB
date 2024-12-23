-- 트리거 실습
-- 상품 입/출고 관련 예시
-- 1. 상품에 대한 데이터를 보관할 테이블 생성
CREATE TABLE product(
	pcode INT AUTO_INCREMENT PRIMARY KEY,	-- 상품 코드
	pname VARCHAR(100),							-- 상품 이름 
	brand VARCHAR(100),							-- 브랜드 이름
	price INT,										-- 가격
	stock INT DEFAULT 0							-- 재고
);

INSERT INTO product(pname, brand, price)
VALUES ('아이폰 15 pro', '애플', 1200000);

INSERT INTO product(pname, brand, price)
VALUES ('갤럭시 24', '삼성', 1500000);

-- 2. 상품 입/출고 상세 이력 테이블 생성
CREATE TABLE prodetail(
	`dcode` INT AUTO_INCREMENT PRIMARY KEY,							-- 입/출고 이력 코드
	`status` VARCHAR(2) CHECK(`status` IN ('입고', '출고')),		--  상태
	`amount` INT,																-- 수량
	`pcode` INT REFERENCES product,										-- 상품 코드(외래키)
	`ddate` DATE DEFAULT CURDATE()										-- 상품 입출고 일자	
);

-- 1번 상품이 2024-12-01 날짜로 10개 입고
INSERT INTO prodetail(`status`, amount, pcode, ddate)
VALUES ('입고', 10, 1, '2024-12-01');

-- 1번 상품의 재고 수량도 변경해야 한다.
UPDATE product
SET stock = stock + 10
WHERE pcode = 1;

-- 1번 상품이 2024-12-02 날짜로 5개 출고
INSERT INTO prodetail(`status`, amount, pcode, ddate)
VALUES('출고', 5, 1, '2024-12-02');

-- 1번 상품의 재고 수량도 변경해야 한다.
UPDATE product
SET stock = stock - 5
WHERE pcode = 1;

-- 2번 상품이 2024-12-05 날짜로 20개 입고
INSERT INTO prodetail(`status`, amount, pcode, ddate)
VALUES('입고', 20, 2, '2024-12-05');

-- 2번 상품의 재고 수량도 변경해야 한다.
UPDATE product
SET stock = stock + 20
WHERE pcode = 2; 

-- prodetail 테이블에 데이터 삽입 시
-- product 테이블에 재고 수량이 자동으로 업데이트 되도록 트리거 생성
DELIMITER $$
CREATE OR REPLACE TRIGGER trg_product_stock
AFTER INSERT ON prodetail
FOR EACH ROW
BEGIN
	-- 상품이 입고된 경우 (재고 증가)
	IF NEW.status = '입고' THEN
		UPDATE product
		SET stock = stock + NEW.amount
		WHERE pcode = NEW.pcode;
	END IF;
	
	-- 상품이 출고된 경우 (재고 감소)
	IF NEW.status = '출고' THEN
		UPDATE product
		SET stock = stock - NEW.amount
		WHERE pcode = NEW.pcode;
	END IF;
	
END $$
DELIMITER ;

-- 1번 상품이 2024-12-05 날짜로 20개 입고
INSERT INTO prodetail(`status`, amount, pcode, ddate)
VALUES ('입고', 20, 1, '2024-12-05');

-- 1번 상품이 2024-12-06 날짜로 10개 출고
INSERT INTO prodetail(`status`, amount, pcode, ddate)
VALUES ('출고', 10, 1, '2024-12-06');

-- 2번 상품이 2024-12-06 날짜로 10개 출고
INSERT INTO prodetail(`status`, amount, pcode, ddate)
VALUES ('출고', 10, 2, '2024-12-06');

SELECT * FROM product;
SELECT * FROM prodetail;