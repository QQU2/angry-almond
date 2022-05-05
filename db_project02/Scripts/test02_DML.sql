/* 지출내역서 테이블과 지출내역구분 테이블에 데이터를 추가/수정/삭제 하는 작업을 진행 한다.
 *     - "지출내역구분" 에는 본인의 한 달치 분량의 생활비 내역을 참고하여
 *       교통비, 식대, 수도세, 전기세 등의 구분명을 추가 한다.
 *     - "지출내역서" 에는 본인의 한 달치 분량의 실제 입출고 내역을 참고하여
 *       가계부를 작성하듯 데이터를 추가한다.
 *     - 테이블에 추가하는 데이터는 최소 5 ~ 10개 정도는 추가하도록 한다.
 */
DROP TABLE 가계부;
ALTER TABLE 가계부 DROP CONSTRAINT SYS_C007412;
ALTER TABLE 지출내역구분 DROP CONSTRAINT SYS_C007410;
DROP TABLE 지출내역구분;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '지출내역구분';
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '가계부';

SELECT * FROM 가계부;
SELECT * FROM 지출내역구분;
--지출 내역 구분 TABLE 내용 추가
INSERT INTO 지출내역구분 VALUES(1,'식비');
INSERT INTO 지출내역구분 VALUES(2,'교통비');
INSERT INTO 지출내역구분 VALUES(3,'관리비');
INSERT INTO 지출내역구분 VALUES(4,'교육비');
INSERT INTO 지출내역구분 VALUES(5,'여가비');

--가계부 TABLE 내용 추가
INSERT INTO 가계부(ACCOUNT_ID, 날짜, 입금액, 출금액, 비고, ACCOUNT_TYPE)
			VALUES(1, TO_DATE(20220310), 0, 15000, '저녁', 1);
INSERT INTO 가계부 VALUES(2, TO_DATE(20220315), 0, 10500, '해리포터', 5);
INSERT INTO 가계부 VALUES(3, TO_DATE(20220318), 0, 3500, '광역버스', 2);
INSERT INTO 가계부 VALUES(4, TO_DATE(20220323), 116000, 0, '국가취업지원금', 4);
INSERT INTO 가계부 VALUES(5, TO_DATE(20220329), 0, 14500, '가스비', 3);

INSERT INTO 가계부 VALUES(6, TO_DATE(20220405), 300000, 0, '국취비', 4);
INSERT INTO 가계부 VALUES(7, TO_DATE(20220412), 0, 39000, '옷', 5);
INSERT INTO 가계부 VALUES(8, TO_DATE(20220419), 0, 23500, '저녁', 1);
INSERT INTO 가계부 VALUES(9, TO_DATE(20220420), 0, 14500, '디저트', 1);
INSERT INTO 가계부 VALUES(10, TO_DATE(20220423), 0, 1400, '지하철', 2);
INSERT INTO 가계부 VALUES(11, TO_DATE(20220430), 0, 22000, '책', 4);

INSERT INTO 가계부 VALUES(12, TO_DATE(20220501), 254000, 0, '국취비', 4);
INSERT INTO 가계부 VALUES(13, TO_DATE(20220507), 0, 25000, '모자', 5);
INSERT INTO 가계부 VALUES(14, TO_DATE(20220513), 0, 21000, '저녁', 1);
INSERT INTO 가계부 VALUES(15, TO_DATE(20220516), 0, 10900, '디저트', 1);
INSERT INTO 가계부 VALUES(16, TO_DATE(20220522), 0, 1250, '지하철', 2);
INSERT INTO 가계부 VALUES(17, TO_DATE(20220524), 0, 24000, '책', 4);  
/*
 * 위 작업을 모두 마친 후에는 다음의 작업을 추가로 진행 한다.
 *     - 입금액만을 따로 조회하여 얼마나 입금이 되었는지 통계 조회를 한다.
 *     - 출금액만을 따로 조회하여 얼마나 출금이 되었는지 통계 조회를 한다.
 *     - 위에서 조회한 데이터를 "월별지출내역" 테이블을 새로 만들어 월별로 저장될 수 있게 한다.
 *     - "월별지출내역" 테이블에는 년, 월, 지출구분, 금액 컬럼을 가지게 만들고 지출구분은 '입', '출' 만 저장되도록 한다.
 */
SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 , EXTRACT(MONTH FROM 날짜) AS 월
	 , SUM(입금액) AS 입금액
	 , SUM(출금액) AS 출금액
  FROM 가계부 
 GROUP BY ROLLUP(EXTRACT(YEAR FROM 날짜), EXTRACT(MONTH FROM 날짜));

CREATE TABLE 월별지출내역(
	  년		NUMBER(4)
	, 월		NUMBER(2)
	, 지출구분	CHAR(3) 
	, 금액	NUMBER
);
CREATE TABLE 월별지출내역
	AS SELECT EXTRACT(YEAR FROM 날짜) AS 년, EXTRACT(MONTH FROM 날짜) AS 월
			, '입' AS 지출구분
			, 입금액 AS 금액
		 FROM 가계부
		WHERE 1 = 0;
	
SELECT * FROM 월별지출내역;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '월별지출내역';
ALTER TABLE 월별지출내역 DROP CONSTRAINT SYS_C007431;
DROP TABLE 월별지출내역;

INSERT ALL INTO 월별지출내역 VALUES(년, 월, 지출구분, 금액)
SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 , EXTRACT(MONTH FROM 날짜) AS 월
	 , CASE WHEN 입금액 > 0 THEN '입'
		    WHEN 출금액 > 0 THEN '출'
	   END 지출구분
	 , SUM(입금액 + 출금액) AS 금액
  FROM 가계부
 GROUP BY EXTRACT(YEAR FROM 날짜) AS 년, EXTRACT(MONTH FROM 날짜) AS 월
	 	, CASE WHEN 입금액 > 0 THEN '입'
		   	   WHEN 출금액 > 0 THEN '출'
	  	 END; 
	  
CREATE TABLE 월별지출내역
	AS SELECT  EXTRACT(YEAR FROM 날짜) AS 년, EXTRACT(MONTH FROM 날짜) AS 월
		  , CASE WHEN 입금액 > 0 AND 출금액 = 0 THEN '입'
		    	 WHEN 출금액 > 0 AND 입금액 = 0 THEN '출'
		  END AS 지출구분
		  , CASE WHEN 지출구분 = '입' THEN SUM(입금액) 
		    	 WHEN 지출구분 = '출' THEN SUM(출금액)
		  END AS 금액
	  FROM 가계부;

SELECT EXTRACT(YEAR FROM 날짜) AS 년
	 , EXTRACT(MONTH FROM 날짜) AS 월
	 , SUM(입금액 + 출금액) AS 금액
  FROM 가계부
 GROUP BY EXTRACT(YEAR FROM 날짜) AS 년, EXTRACT(MONTH FROM 날짜) AS 월;  
	
SELECT * FROM 가계부;
/*
 * 지출내역서에 작성된 모든 지출을 기존 금액보다 10% 인상 시키고 이를
 * 월별지출내역에도 반영하도록 한다.
 */
UPDATE 지출내역서
   SET 출금액 = 출금액 * 1.1
 WHERE 출금액  > 0;