/* PROCEDURE(자바의 필드 함수 같은 너낌)
 * - PL/SQL을 사용하여 DBMS 시스템에서실행할 프로그램을 만들기 위해 사용하는 객체
 * - 반복 작업 및 복잡한 SQL 구문을 프로시져로 저장하여 재사용하는 용도로 사용
 * - DBMS에 컴파일된 상태로 저장되고 동작하기 때문에 기존SQL 스크립트보단 빠른 동작 기대가능
 * 
 * - 만들기: CREATE OR REPLACE/DROP PROCEDURE 프로시듀어 이름 (IN, IN, ...OUT명)
 * 		   IS.../ BEGIN.../ EXCEPTION.../END;/
 * - NODE: IN(매개변수)/ OUT(return 값)/ INOUT
 * 		   MODE가 생략되면 DEFAULT 값으로 IN이 들어감
 * 		   (사용할 컬럼 IN 자료형/  OUT명 OUT 자료형)
 * - 실행: EXECUTE 프로시듀어 이름 (IN, IN, ...OUT명);
 * 	 	  PRINT OUT명;
 */
--1. 생성
CREATE OR REPLACE PROCEDURE PROC_TEST
IS 
BEGIN 
	DBMS_OUTPUT.PUT_LINE('Hello Procedure');
END;
--2. 삭제
DROP PROCEDURE PROC_TEST;
--3. 실행
--EXEC PROC_TEST;-> DBeaver에서는 안됨
BEGIN 
	PROC_TEST;
END;


--예제1>								  매개변수(IN: 입력용     OUT: 반환용    )
CREATE OR REPLACE PROCEDURE PROC_INOUT_TEST(N1 IN NUMBER, N2 OUT NUMBER)
IS 
BEGIN 
	DBMS_OUTPUT.PUT_LINE('N1 -> '|| N1);
	--밑 NUM과 바인딩 됨
	N2 := 10;
END;

DECLARE
	NUM NUMBER;
BEGIN 
	--				(N1, N2)
	PROC_INOUT_TEST(20, NUM);
	DBMS_OUTPUT.PUT_LINE('NUM -> '|| NUM);
END;

--예제 2>
--1. 반복숫자 만드는 시퀀스 만들기
CREATE SEQUENCE TEST_SEQ NOCACHE;
--2. PROCEDURE를 통해 대입할 TABLE 만들기
CREATE TABLE TEST_TABLE(
	  ID NUMBER
	, I_DATE DATE
);
--3. PROCEDURE 만들기
CREATE OR REPLACE PROCEDURE PROC_INSERT_TEST(MAX_NUM IN NUMBER, RES_CNT OUT NUMBER)
IS
BEGIN 
	RES_CNT := 0;
	FOR I IN 1..MAX_NUM LOOP 
		INSERT INTO TEST_TABLE VALUES(TEST_SEQ.NEXTVAL, SYSDATE);
		RES_CNT := RES_CNT + 1;
	END LOOP;
COMMIT;
END;
--4. PROCEDURE 실행
DECLARE 
	RES_CNT NUMBER;
BEGIN
	PROC_INSERT_TEST(10, RES_CNT);
	DBMS_OUTPUT.PUT_LINE(RES_CNT||'개 행이 반영되었습니다.');
END;
--5. TABLE 조회
SELECT * FROM TEST_TABLE;


--PROCEDURE 에러확인
SELECT  * FROM ALL_ERRORS WHERE NAME = 'PROC_INSERT_TEST';


--<실전 예제 1>--
/* 상품 재고 관리를 위한 테이블 
 * - 재고 입출고 테이블 : 상품에 대한 입고/출고 내역을 저장하는 테이블
 * - 재고 관리 테이블 : 상품에 대한 전체  재고 수량을 관리하는 테이블
 * - 요구사항
 * 		1. 재고 입고가 발생하는 경우, 재고관리 테이블에 동일한 이름의 상품이 없는 경우 재고 관리에 새로운 상품으로 추가한다.
 * 		2. 동일한 이름의 상품이 있는 경우, 기존 수량을 증가시킨다.
 * 		3. 재고 출고가 발생하는 경우 재고관리 테이블에 동일한 이름의 상품이 없는 경우 -> 에러
 * 		4. 동일한 이름의 상품이 있는 경우 기존 수량을 감소시킨다. 만약 차감된 수량이 마이너스가 된 경우 롤백한다.
 * 
 */

CREATE TABLE 재고입출고(
	  PID	NUMBER				CONSTRAINT PK_재고입출고_PID 	PRIMARY KEY
	, PNAME VARCHAR2(100) 		CONSTRAINT NN_재고입출고_PNAME 	NOT NULL
	, PTYPE CHAR(1)				CONSTRAINT CK_재고입출고_PTYPE 	CHECK(PTYPE IN ('I','O'))
	, PCNT  NUMBER DEFAULT(1)	CONSTRAINT NN_재고입출고_PCNT 	NOT NULL
	, PDATE DATE				CONSTRAINT NN_재고입출고_PDATE 	NOT NULL
);
CREATE TABLE 재고관리(
       PID     NUMBER         CONSTRAINT PK_재고관리_PID     PRIMARY KEY
     , PNAME   VARCHAR2(100)  CONSTRAINT NN_재고관리_PNAME   NOT NULL
     , PTOTAL  NUMBER         CONSTRAINT NN_재고관리_PTOTAL  NOT NULL
);
CREATE TABLE 재고입고신청(
	  PID		NUMBER 		CONSTRAINT PK_재고입고신청_PID 		PRIMARY KEY
	, PNAME		VARCHAR2(50)CONSTRAINT NN_재고입고신청_PNAME 	NOT NULL
	, PCNT		NUMBER		CONSTRAINT NN_재고입고신청_PCNT 	NOT NULL
	, PROTYPE	CHAR(8) 	CONSTRAINT NN_재고입고신청_PROTYPE 	NOT NULL
	, PDATE		DATE		CONSTRAINT NN_재고입고신청_PDATE 	NOT NULL
	, DDATE		DATE	
	, DID		NUMBER		CONSTRAINT FK_재고입고신청_DID		REFERENCES 재고입출고(PID)
);
--시퀀스 
CREATE SEQUENCE SEQ_재고입출고 NOCACHE;
CREATE SEQUENCE SEQ_재고관리 NOCACHE;
CREATE SEQUENCE SEQ_재고입고신청 NOCACHE;

--<PROC_재고입고신청> 프로시져 생성
CREATE OR REPLACE PROCEDURE PROC_재고입고신청(IN_NAME IN VARCHAR2, IN_COUNT IN NUMBER)
IS 
BEGIN
	--재고입고 신청이 안되어 있다면
	INSERT INTO 재고입고신청 VALUES(SEQ_재고입고신청.NEXTVAL, IN_NAME, IN_COUNT, 'OFFER', SYSDATE, NULL, NULL);
END;   

BEGIN 
	PROC_재고입고신청('사탕', 5);
END;
SELECT * FROM 재고입고신청;


--<PROC_재고입고신청처리> 프로시져 생성
CREATE OR REPLACE PROCEDURE PROC_재고입고신청처리(IN_PID IN NUMBER, 
	/*	 재고입고신청된 데이터를 처리하는 프로시져
     *     - 재고입고신청 테이블의 PID로 어떤 신청항목을 처리할 것인지 외부로 부터 값을 입력받는다.
     *     - 외부로부터 입력받은 PID를 이용하여 재고입출고 테이블에 데이터 등록 처리를 하고
     *     - OFFER 상태를 DONE 상태로 변경 후 DDATE 는 현재날짜로 등록 처리 한다.
     *     - DID 컬럼은 재고입출고 테이블에 등록할 때 생성된 PID가 저장되도록 한다.
     */
);


--<PROC_재고입출등록> 프로시져 생성
CREATE OR REPLACE PROCEDURE PROC_재고입출등록 
	( INOUT_NAME IN VARCHAR2 --재고명
	, INOUT_TYPE IN VARCHAR2 --입고/출고
	, INOUT_CNT  IN NUMBER	 --입출고되는 재고 개수
	, INOUT_DATE IN DATE	 -- 입출고 날짜
	, RES_COUNT OUT NUMBER)	 --
IS 
	--INOUT_TYPE을 함수 속 변수처럼 함부로 정의할 수 없으므로  프로시져 내에서 쓸 수 있는 변수에다가 대입시켜준다.
	VAR_TYPE VARCHAR2(1) := INOUT_TYPE;
	VAR_CNT NUMBER;
BEGIN 
	--INOUT_TYPE을 대/소문자 상관없이 받고 대문자로만 출력하고 싶을 때
	VAR_TYPE := UPPER(INOUT_TYPE);
--입고 시 
	IF(VAR_TYPE = 'I') THEN
		INSERT INTO 재고입출고 VALUES (SEQ_재고입출고.NEXTVAL, INOUT_NAME, VAR_TYPE, INOUT_CNT, INOUT_DATE);
		--재고 있는지 확인
		SELECT COUNT(*) INTO VAR_CNT FROM 재고관리 WHERE PNAME = INOUT_NAME;
	
		--없다면 재고 추가
		IF(VAR_CNT = 0) THEN
			INSERT INTO 재고관리 VALUES (SEQ_재고관리.NEXTVAL, INOUT_NAME, INOUT_CNT);
		--있다면 총개수 누적
		ELSE 
			UPDATE 재고관리 SET PTOTAL = PTOTAL + INOUT_CNT WHERE PNAME = INOUT_NAME;
		END IF;
--출고 시
	ELSE
		--재고 있는지 확인
		SELECT COUNT(*) INTO VAR_CNT FROM 재고관리 WHERE PNAME = INOUT_NAME;
		--없으면 에러 출력
		IF(VAR_CNT = 0) THEN
			DBMS_OUTPUT.PUT_LINE('해당 재고가 존재하지 않습니다.');
		ELSE
			INSERT INTO 재고입출고 VALUES (SEQ_재고입출고.NEXTVAL, INOUT_NAME, VAR_TYPE, INOUT_CNT, INOUT_DATE);
			UPDATE 재고관리 SET PTOTAL = PTOTAL - INOUT_CNT WHERE PNAME = INOUT_NAME;
			
			--출고량이 재고량보다 많을 경우
			SELECT PTOTAL INTO VAR_CNT FROM 재고관리 WHERE PNAME = INOUT_NAME;
			IF(VAR_CNT < 0) THEN 
				/* PROC_재고입고신청 프로시져 만들기
				 * - PROC_재고입고신청(IN 상품명, IN 오버되는 출고량)
				 * - TABLE 재고입고신청(PID, PNAME, PCNT, PROTYPE, PDATE, DDATE) 추가로 작성
				 * - PROTYPE 컬럼: 진행도(OFFER/ ONGOING/ DONE)와 관련된 컬럼
				 * - PDATE 컬럼: 신청날짜
				 * - DDATE 컬럼: 입고완료된 날짜
				 */
				ROLLBACK;
				PROC_재고입고신청(INOUT_NAME, ABS(VAR_CNT));
			END IF;
		END IF;
	END IF;
	RES_COUNT := 1;
	COMMIT;
END;
--프로시져 에러확인
SELECT * FROM USER_ERRORS;

DECLARE
	RES_CNT NUMBER;
BEGIN 
	PROC_재고입출등록('사탕', 'I', 17, TO_DATE(20220510), RES_CNT);
	DBMS_OUTPUT.PUT_LINE('실행결과: ' || RES_CNT||'행이 반영되었습니다.');
END;
DECLARE
	RES_CNT NUMBER;
BEGIN 
	PROC_재고입출등록('사탕', 'O', 20, TO_DATE(20220510), RES_CNT);
	DBMS_OUTPUT.PUT_LINE('실행결과: ' || RES_CNT||'행이 반영되었습니다.');
END;




--table 만들어졌는지 확인
SELECT * FROM 재고입출고 ORDER BY PID;
SELECT * FROM 재고관리;
SELECT * FROM 재고입고신청;

DROP TABLE 재고관리;
DROP TABLE 재고입출고;
DROP TABLE 재고입고신청;
DROP SEQUENCE SEQ_재고입출고;
DROP SEQUENCE SEQ_재고관리;
DROP SEQUENCE SEQ_재고입고신청;

DELETE FROM 재고입출고;
DELETE FROM 재고관리;
DELETE FROM 재고입고신청;
SELECT LAST_NUMBER FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEQ_재고입출고';
ALTER SEQUENCE SEQ_재고입출고 RESTART WITH 1;

SELECT SEQ_재고입출고.CURRVAL FROM DUAL;
COMMIT;



/* USER DEFINED FUNCTION(사용자 정의 함수)
 * - 만들기: CREATE OR REPLACE/DROP FUNCTION 함수명(컬럼명 IN 자료형) RETURN 자료형
 *   	   IS.../ BEGIN.../ RETURN.../END;/
 * - 실행: SELECT 함수명(IN) FROM 테이블;
 */

/* TRIGGER
 * - DML 수행시, 이와 연결된 동작을 자동으로 수행하도록 작성된 프로그램(EX> 구매자의 누적 구매액에 따른 등급향상 등)
 * - 사용자가 명시적으로 호출 X, 조건이 맞으면 자동적으로 실행
 * - 주로 데이터 무결성 보장을 위해 FK처럼 동작
 * - 실시간 집계성 테이블 생성에 사용
 * - 보안/ 유효하지 않은 트랙잭션 예방, 업무 규칙 적용, 감사 제공 등에 사용
 * - OLTP(ONLINE TRANSESSION PROCESSING)에서 부하로 인해 성능 저하 가능성 O
 * - ROLLBACK시, 원 트랜잭션 뿐 아니라 TRIGGER에 의해 실행된 연산도 모두 취소됨 
 * 	 -> TRIGGER는 INSERT, DELETE, UPDATE문과 연결된 하나의 트랜잭션 내에서 수행되는 작업으로 이해해야함
 * 	 -> PROCEDURE는 BEGIN ~ END 사이에 COMMIT, ROLLBACK 사용가능 
 * 	 -> TRIGGER는 BEGIN ~ END 사이에 COMMIT, ROLLBACK 사용 불가
 * - ROW TRIGGER/ STATEMENT TRIGGER
 */

