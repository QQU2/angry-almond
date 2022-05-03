CREATE TABLE SAMPLE_T(
	  u_id NUMBER 		--PRIMARY KEY
	, JUMIN CHAR(13)	--UNIQUE
	, NAME VARCHAR2(50) NOT NULL
	, AGE NUMBER(3)		DEFAULT(0)
	, GENDER CHAR(1)	CHECK(GENDER IN ('N', 'F'))
	, BIRTHDAY DATE		DEFAULT(SYSDATE)
	, REF_COL NUMBER	--REFERENCES REF_T(R_ID)
	--CONSTRAINT 이름: CONSTRAINT_NAME 컬럼 아래 들어갈 제약 조건의 이름
	, CONSTRAINT PK_SAMPLE_T_U_ID PRIMARY KEY(U_ID)
	, CONSTRAINT OK_SAMPLE_T_JUMIN UNIQUE(JUMIN)
	, CONSTRAINT FK_SAMPLE_T_REF_COL FOREIGN KEY(REF_COL) REFERENCES REF_T(R_ID)
);

--참조 테이블
CREATE TABLE REF_T(
	  R_ID NUMBER			PRIMARY KEY
	, NOTE VARCHAR2(100)
);

--테이블 삭제
DROP TABLE SAMPLE_T;
DROP TABLE REF_T;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SAMPLE_T';
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'REF_T';
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'SAMPLE_T';
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'REF_T';

/* ALTER (수정)
 * - ADD, MODIFY, RENAME, DROP
 */
ALTER TABLE SAMPLE_T ADD NICKNAME VARCHAR2(100);
ALTER TABLE SAMPLE_T MODIFY NICKNAME VARCHAR2(200);
ALTER TABLE SAMPLE_T RENAME COLUMN NICKNAME TO N_NAME;
ALTER TABLE SAMPLE_T RENAME TO SAM_T;
ALTER TABLE SAM_T RENAME TO SAMPLE_T;
ALTER TABLE SAMPLE_T DROP COLUMN N_NAME;
--CASCADE CONSTRAINT: 제약 조건을 지운다. 
--아래의 예시는 REF_T 테이블의 컬럼 R_ID를 지울 때 먼저 제약조건을 지우고(참조관계 끊기) 컬럼을 지운다.
--좋은 예시는 아님(부모 테이블에서 삭제할 컬럼을 접근하고 제약조건을 삭제)
ALTER TABLE REF_T DROP COLUMN R_ID CASCADE CONSTRAINT;

--좋은 예(자식 테이블에서 참조받는 컬럼의 제약조건을 삭제 후 부모테이블의 컬럼을 삭제)
ALTER TABLE SAMPLE_T DROP CONSTRAINT PK_SAMPLE_T_U_ID;
ALTER TABLE REF_T DROP COLUMN R_ID;

/**** 제약조건 추가 삭제 과정 ****/

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'REF_T';

--ALTER TABLE REF_T ADD UNIQUE(NOTE);
--1. 원래 제약 조건 없던 컬럼 NOTE에 제약 조건 UNIQUE부여 + 제약 조건 이름 생성
ALTER TABLE REF_T ADD CONSTRAINT UK_REF_T UNIQUE(NOTE);

--2. NOTE의 제약 조건 이름 변경해보기
ALTER TABLE REF_T RENAME CONSTRAINT UK_REF_T TO UK_REF_T_NOTE;

--3. NOTE의 제약 조건 추가/제거해보기
ALTER TABLE REF_T MODIFY NOTE NOT NULL;	-- 원래 제약 조건 없었는데 MODIFY로 제약조건 추가
ALTER TABLE REF_T MODIFY NOTE NULL;		-- NULL 수정으로 제약조건 제거
ALTER TABLE REF_T MODIFY NOTE CONSTRAINT CK_NOTE CHECK(NOTE IN ('h', 'k'));
ALTER TABLE REF_T DROP CONSTRAINT SYS_C007401;

--4. 테이블 레벨로 제약조건을 수정하기 위해 기존 제약 조건을 삭제 후 추가
ALTER TABLE REF_T DROP CONSTRAINT UK_REF_T_NOTE DROP CONSTRAINT SYS_C007398;
ALTER TABLE REF_T ADD PRIMARY KEY(R_ID, NOTE); 


/*** PRIMARY KEY 제약 조건이 있는 테이블 제거 ***/
DROP TABLE REF_T CASCADE CONSTRAINT; -- 이 방법은 지양/ 4번의 첫째줄 쿼리 방법을 사용