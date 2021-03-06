--동의어(SYNONYM) 권한 부여(시스템 계정으로 부여)
GRANT CREATE SYNONYM TO 계정명;
GRANT CREATE SYNONYM TO DEVADMIN;
GRANT CREATE SYNONYM TO PUSER1;

--조회하기 위한 권한 부여(공유할 테이블을 갖고 있는 계정으로 쿼리 실행)
GRANT SELECT ON 테이블명 TO 계정명;
GRANT SELECT ON EMPLOYEES TO DEVADMIN;

--1. 관리자 권한이 아닌 계정은 다른 계정의 테이블에 접근할 수 없다.
SELECT * FROM PUSER1.EMPLOYEES ORDER BY EMPLOYEE_ID; 
--GRANT: 권한 부여(PUSER1 -> DEVADMIN)
GRANT SELECT ON EMPLOYEES TO DEVADMIN;
REVOKE SELECT ON EMPLOYEES FROM DEVADMIN;

--2. **SYNONYM 동의어 만들기**
-- CREATE SYNONYM 바꿀 테이블명 FOR 원래 테이블명
--권한 부여: SYSTEM(관리자 계정) -> DEVADMIN
GRANT CREATE SYNONYM TO DEVADMIN;
CREATE SYNONYM P_EMP FOR PUSER1.EMPLOYEES;
SELECT * FROM P_EMP;

DROP SYNONYM EMP;

--3. DEVADMIN에서 PUSER1의 EMP(EMPLOYEES의 별칭)에 접근
GRANT CREATE SYNONYM TO PUSER1;
CREATE SYNONYM EMP FOR EMPLOYEES;
SELECT * FROM PUSER1.EMP;

/* - 공개 동의어/ 비공개 동의어
 * - TABLE명이 길 경우 사용
 * - 혹은 스키마에 대한, 테이블명에 대한 보안을 요할 때 사용
 */
 --비공개 동의어
CREATE SYNONYM EMP FOR EMPLOYEES;
 --공개 동의어: 관리자 계정으로만 만들 수 있음
CREATE PUBLIC SYNONYM EMP FOR EMPLOYEES;
SELECT  * FROM ALL_SYNONYMS WHERE SYNONYM_NAME= 'EMP';

SELECT * FROM EMPLOYEES;


