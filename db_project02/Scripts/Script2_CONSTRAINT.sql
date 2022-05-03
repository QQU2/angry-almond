/* 제약조건
 * - 테이블에 데이터를 저장할 때 저장 조건 제한하기 위함, 데이터 무결성 보장을 위함
 * - 테이블 레벨/ 컬럼 레벨
 * - 종류
 * 	 NOT NULL: NULL  데이터를 허용하지 않음/ 컬럼 레벨로만 정의가능
 * 	 UNIQUE: 중복 데이터를 불허
 * 	 PRIMARY KEY: NOT NULL + UNIQUE 결합/ 기본키(PK)/ 데이터 식별 값으로 사용
 * 	 FOREIGN KEY: 외래키(FK)/ 다른 테이블의 데이터를 참조하는 참조값이 저장된 컬럼 명시
 * 				/ 테이블 간의 관계를 형성하기 위해 사용
 * 				/ 참조 대상이 되는 테이블의 데이터는 임의로 삭제 불가능
 * 				/ 참조값을 받는 컬럼과 참조 대상 컬럼은 같은 데이터가 있어야 함
 * 				/ 참조 당하는 테이블(부모)이 참조하고 있는 테이블(자식)보다 먼저 만들어져야 함
 * 				/ 참조 당하는 테이블(부모)보다 참조하고 있는 테이블(자식)이 먼저 지워질 수 없다.
 * 				/ -> 기본 삭제 옵션: ON DELETE RESTRICTED
 * 				/ -> 기본 삭제 옵션 변경 가능: **참조테이블(참조컬럼) ON DELETE (SET NULL | CASCADE);**
 *				/ 참조하는 컬럼은 PRIMARY KEY여야 함 
 * 	 CHECK:  미리 설정한 값만 저장가능하도록 검사 수행
 */

CREATE TABLE SAMPLE_T(
	  u_id NUMBER 		--PRIMARY KEY
	, JUMIN CHAR(13)	--UNIQUE
	, NAME VARCHAR2(50) NOT NULL
	, AGE NUMBER(3)		DEFAULT(0)
	, GENDER CHAR(1)	CHECK(GENDER IN ('N', 'F'))
	, BIRTHDAY DATE		DEFAULT(SYSDATE)
	, REF_COL NUMBER	--REFERENCES REF_T(R_ID)
	--CONSTRAINT 설명: CONSTRAINT_NAME 컬럼 아래 들어갈 제약 조건의 보충 설명
	, CONSTRAINT PK_SAMPLE_T_U_ID PRIMARY KEY(U_ID)
	, CONSTRAINT OK_SAMPLE_T_JUMIN UNIQUE(JUMIN)
	, CONSTRAINT FK_SAMPLE_T_REF_COL FOREIGN KEY(REF_COL) REFERENCES REF_T(R_ID)
	
);

--참조 테이블
CREATE TABLE REF_T(
	  R_ID NUMBER			PRIMARY KEY
	, NOTE  VARCHAR2(100)
);

--테이블 삭제
DROP TABLE SAMPLE_T;
DROP TABLE REF_T;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SAMPLE_T';