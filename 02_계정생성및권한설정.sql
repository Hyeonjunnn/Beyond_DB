-- 사용자 생성
CREATE USER `beyond`@`%` IDENTIFIED BY 'beyond';

-- 사용자 확인
SELECT `HOST`, `user`, `PASSWORD` FROM mysql.user;

-- beyond 사용자에 employees_db 데이터베이스에 대해 모든 권한을 부여
GRANT ALL PRIVILEGES ON employees_db.* TO `beyond`@`%`;

-- beyond 사용자에 test_db 데이터베이스에 대해 모든 권한을 부여
GRANT ALL PRIVILEGES ON test_db.* TO `beyond`@`%`;

-- 권한 확인
SHOW GRANTS FOR `beyond`@`%`;

-- 권한 적용
FLUSH PRIVILEGES;