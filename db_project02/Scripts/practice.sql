SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS ;
SELECT * FROM LOCATIONS ;
SELECT * FROM DEPARTMENTS;
SELECT * FROM COUNTRIES;

--GROUP BY
SELECT DEPARTMENT_ID, JOB_ID , COUNT(*)
FROM EMPLOYEES
GROUP BY ROLLUP (DEPARTMENT_ID, JOB_ID)
ORDER BY 1;

SELECT REGION_ID, COUNTRY_NAME, COUNT(*) 
FROM COUNTRIES 
GROUP BY ROLLUP(REGION_ID, COUNTRY_NAME)
ORDER BY 1;

--GROUPING
SELECT GROUPING(REGION_ID), GROUPING(COUNTRY_NAME), COUNT(*) 
FROM COUNTRIES 
GROUP BY ROLLUP(REGION_ID, COUNTRY_NAME)
ORDER BY 1;

SELECT *
  FROM EMPLOYEES E1
  JOIN (SELECT C.COUNTRY_NAME AS 나라구분
             , MAX(E.SALARY) AS 최고급여
             , MIN(E.SALARY) AS 최저급여
          FROM EMPLOYEES E
          JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
          JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
          JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID
         GROUP BY C.COUNTRY_NAME
       ) E2
    ON E2.최고급여 = E1.SALARY OR E2.최저급여 = E1.SALARY;
    
   
    
SELECT HIRE_DATE
	 , TRUNC((SYSDATE- HIRE_DATE)/30) AS 근무개월
  FROM EMPLOYEES;
  
CREATE USER SAMPLE IDENTIFIED BY 1234;
GRANT RESOURCE, CONNECT TO SAMPLE;
GRANT INSERT ANY TABLE, UPDATE ANY TABLE,
	  DELETE ANY TABLE, CREATE VIEW, CREATE SESSION TO SAMPLE;

CREATE TABLE SAMPLE2(
	NAME VARCHAR2(100) PRIMARY KEY
);
SELECT * FROM SAMPLE2;
DROP USER SAMPLE CASCADE;
SELECT * FROM ALL_USERS WHERE USERNAME ='SAMPLE';

SELECT  EMP_NAME, EMP_NO, DEPT_CODE, SALARY
FROM EMP 
WHERE DEPT_CODE = 'D9' OR DEPT_CODE = 'D6'
  AND SALARY >= 300 
  AND BONUS IS NOT NULL 
  AND SUBSTR(EMP_NO, 8,1) = '1'
  AND EMAIL LIKE '___&_%' ESCAPE '&';
 

-- 변수 자료형 원래 테이블에서 가져오기(%TYPE)
-- 조건에 맞는 하나의 값을 출력
DECLARE
	ID EMPLOYEES.EMPLOYEE_ID%TYPE;
	NAME VARCHAR2(100);
BEGIN 
	SELECT E.EMPLOYEE_ID, E.FIRST_NAME ||' '|| E.LAST_NAME 
	INTO ID, NAME
	FROM EMPLOYEES E
	WHERE E.EMPLOYEE_ID = 120;
	--WHERE E.EMPLOYEE_ID BETWEEN 120 AND 125;
	DBMS_OUTPUT.PUT_LINE(ID||'-'||NAME);
END;
SELECT * FROM EMPLOYEES e ;

SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'EMPLOYEES';  

--변수 자료형 원래 테이블에서 행타입(%ROWTYPE)으로 가져오기
-- 조건에 맞는 값을 'DBMS_OUTPUT.PUT_LINE(변수명.컬럼명)' 형태로 적음
DECLARE 
	PHONENUMBER EMPLOYEES%ROWTYPE;
BEGIN
	SELECT * INTO PHONENUMBER
	FROM EMPLOYEES
	WHERE EMPLOYEE_ID = 113;
	DBMS_OUTPUT.PUT_LINE(PHONENUMBER.EMPLOYEE_ID||
						 PHONENUMBER.FIRST_NAME ||
						 PHONENUMBER.PHONE_NUMBER);
END;

DECLARE 
	D EMPLOYEES%ROWTYPE;
	NUM NUMBER := 150;
BEGIN 
	LOOP
		SELECT * INTO D FROM EMPLOYEES 
		WHERE EMPLOYEE_ID = NUM;
		NUM := num + 1;
		DBMS_OUTPUT.PUT_LINE(D.EMPLOYEE_ID ||'|'|| RPAD(D.FIRST_NAME, 11)|| '|');
		IF(NUM = 207) THEN EXIT; 
		END IF;
	END LOOP;
END;

DECLARE 
	D EMPLOYEES%ROWTYPE;
	NUM NUMBER := 150;
BEGIN 
	LOOP
		SELECT * INTO D FROM EMPLOYEES 
		WHERE EMPLOYEE_ID = NUM;
		NUM := num + 1;
		IF(D.SALARY >= 9000) THEN 
			DBMS_OUTPUT.PUT_LINE(D.EMPLOYEE_ID ||'|'|| RPAD(D.FIRST_NAME, 11)|| '|');
		END IF;
		IF(NUM = 207) THEN EXIT;
		END IF;
	END LOOP;
END;

DECLARE 
	EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
	EMP_PHONE_NUMBER EMPLOYEES.PHONE_NUMBER%TYPE;
BEGIN 
	FOR ID IN 100..206 LOOP
		SELECT EMPLOYEE_ID, PHONE_NUMBER
		INTO EMP_ID, EMP_PHONE_NUMBER
		FROM EMPLOYEES 
		WHERE EMPLOYEE_ID = ID;
		IF(SUBSTR(EMP_PHONE_NUMBER, 1, 3) = '650') THEN
			DBMS_OUTPUT.PUT_LINE(EMP_ID||' | '|| EMP_PHONE_NUMBER);
		END IF;
	END LOOP;
END;

BEGIN
	FOR N IN 1..6 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;

DECLARE
 	N NUMBER := 10;
BEGIN
	WHILE N < 50 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
		N := N + 1;
	END LOOP;
END;

--사용자 정의 RECORD
DECLARE
	TYPE USER_TYPE_RECORD IS RECORD(
		  ID EMPLOYEES.EMPLOYEE_ID%TYPE
		, NAME EMPLOYEES.FIRST_NAME%TYPE
	);
	USER_TYPE USER_TYPE_RECORD;
BEGIN
	SELECT EMPLOYEE_ID, FIRST_NAME INTO USER_TYPE
	FROM EMPLOYEES WHERE EMPLOYEE_ID = 150;
	DBMS_OUTPUT.PUT_LINE(USER_TYPE.ID || '|' || USER_TYPE.NAME);
END;

--TABLE 타입 RECORD
DECLARE 
	TYPE TABLE_TYPE_RECORD IS TABLE OF EMPLOYEES%ROWTYPE INDEX BY BINARY_INTEGER;
	TABLE_TYPE TABLE_TYPE_RECORD;
	IDX NUMBER := 1;
BEGIN
	FOR D IN (SELECT * FROM EMPLOYEES) LOOP
		TABLE_TYPE(IDX) := D;
		IDX := IDX + 1;
	END LOOP;
	FOR I IN 1..TABLE_TYPE.COUNT LOOP
		DBMS_OUTPUT.PUT_LINE(TABLE_TYPE(I).EMPLOYEE_ID || '| ' ||
							 TABLE_TYPE(I).FIRST_NAME);
	END LOOP;
END;

DECLARE 
	TYPE TABLE_TYPE_RECORD IS TABLE OF EMPLOYEES.LAST_NAME%TYPE INDEX BY BINARY_INTEGER;
	TABLE_TYPE TABLE_TYPE_RECORD;
	IDX NUMBER := 1;
BEGIN
	FOR A IN (SELECT LAST_NAME FROM EMPLOYEES) LOOP
		TABLE_TYPE(IDX) := A.LAST_NAME;
		IDX := IDX + 1;
	END LOOP;
	IDX := TABLE_TYPE.FIRST;
	WHILE(IDX IS NOT NULL) LOOP
		DBMS_OUTPUT.PUT_LINE(TABLE_TYPE(IDX));
		IDX := TABLE_TYPE.NEXT(IDX);
	END LOOP;
END;

CREATE TABLE 재고입고신청(
	  PID		NUMBER 		CONSTRAINT PK_재고입고신청_PID 		PRIMARY KEY
	, PNAME		VARCHAR2(50)CONSTRAINT NN_재고입고신청_PNAME 	NOT NULL
	, PCNT		NUMBER		CONSTRAINT NN_재고입고신청_PCNT 	NOT NULL
	, PROTYPE	CHAR(8) 	CONSTRAINT CK_재고입고신청_PROTYPE 	CHECK PROTYPE IN ('OFFER', 'ONGOING', 'DONE')
	, PDATE		DATE		CONSTRAINT NN_재고입고신청_PDATE 	NOT NULL
	, DDATE		DATE		
);
CREATE SEQUENCE SEQ_재고입고신청 COCACHE;
CREATE OR REPLACE SEQUENCE PROC_재고입고신청(PNAME IN VARCHAR2, PCNT IN NUMBER)
IS 
BEGIN
	--재고입고 신청이 안되어 있다면
	INSERT INTO 재고입고신청 VALUES(SEQ_재고입고신청.NEXTVAL, PNAME, PCNT, 'OFFER', SYSDATE, NULL);
END;




