SELECT FIRST_NAME
     , LENGTH(FIRST_NAME)
  FROM EMPLOYEES;


SELECT LENGTH('Hello') AS Col1
     , LENGTH('안녕') AS Col2
     , LENGTHB('Hello') Col3
     , LENGTHB('안녕') Col4
  FROM DUAL;


SELECT INSTR('sample@example.com', '@') AS Col1
     , INSTR('sample@example.com', '@', -1) AS Col2
     , INSTR('sample@example.com', 'e') AS Col3
     , INSTR('sample@example.com', 'e', -1) AS Col4
     , INSTR('sample@example.com', 'e', 1, 2) AS Col5
     , INSTR('sample@example.com', 'e', -1, 2) AS Col6
  FROM DUAL;


SELECT LTRIM('    sample@example.com    ', ' ') AS Col1
     , RTRIM('    sample@example.com    ', ' ') AS Col2
     , TRIM('    sample@example.com    ') AS Col3
     , TRIM(LEADING '-' FROM '-----sample@example.com-----') AS Col4
     , TRIM(TRAILING '-' FROM '-----sample@example.com-----') AS Col5
     , TRIM(BOTH '-' FROM '-----sample@example.com-----') AS Col6
  FROM DUAL;


SELECT '!' || LPAD('A', 4) AS Col1
     , '!' || LPAD('AB', 4) AS Col2
     , '!' || LPAD('ABC', 4) AS Col3
     , RPAD('A', 4) || '!' AS Col4
     , RPAD('AB', 4) || '!' AS Col5
     , RPAD('ABC', 4) || '!' AS Col6
     , RPAD('A', 4, '0') || '!' AS Col7
     , RPAD('ABCDE', 4) || '!' AS Col8
  FROM DUAL;


SELECT SUBSTR('sample@example.com', 1, 6) AS Col1
     , SUBSTR('sample@example.com', 8, 7) AS Col2
     , SUBSTR('sample@example.com', -18, 6) AS Col3
     , SUBSTR('sample@example.com', -11, 7) AS Col4
     , SUBSTR('sample@example.com', -11) AS Col5
  FROM DUAL;


SELECT LOWER('sample@example.com') AS Col1
     , UPPER('sample@example.com') AS Col2
     , INITCAP('sample@example.com') AS Col3
  FROM DUAL;


SELECT CONCAT('sample', '@example.com') AS Col1
  FROM DUAL;

--             원본문자열            찾을문자열     변경할문자열
SELECT REPLACE('sample@example.com', 'example.com', 'example.co.kr') AS Col1
  FROM DUAL;


SELECT ABS(10) AS Col1
     , ABS(-10) AS Col2
  FROM DUAL;


SELECT MOD(10, 3) AS Col1
     , MOD(-10, 3) AS Col2
     , MOD(10.5, 3) AS Col3
     , MOD(-10.5, 3) AS Col4
  FROM DUAL;


SELECT ROUND(10.4) AS Col1
     , ROUND(10.5) AS Col2
     , ROUND(10.45) AS Col3
     , ROUND(10.45, 1) AS Col4
     , ROUND(10.456, 2) AS Col5
     , ROUND(18.5, -1) AS Col6
  FROM DUAL;


SELECT FLOOR(10.34) AS Col1
     , CEIL(10.34) AS Col2
     , FLOOR(-10.34) AS Col3
     , CEIL(-10.34) AS Col4
  FROM DUAL;
 
 
SELECT TRUNC(10.34) AS Col1
     , TRUNC(10.34, 1) AS Col2
     , TRUNC(10.3456, 2) AS Col3
     , TRUNC(1234, -1) AS Col4
  FROM DUAL;



SELECT SYSDATE AS Col1
     , ADD_MONTHS(SYSDATE, 2) AS Col2
     , ADD_MONTHS(SYSDATE, -2) AS Col3
     , LAST_DAY(SYSDATE) AS Col4
     , NEXT_DAY(SYSDATE, 6) AS Col5 -- 1:일요일, 2:월요일, ... 6:금요일, 7:토요일
     , NEXT_DAY(SYSDATE, '금') AS Col6
  FROM DUAL;


SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE, 2)) AS Col1
     , MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 2), SYSDATE) AS Col2
  FROM DUAL;


SELECT EXTRACT(YEAR FROM SYSDATE) AS Col1
     , EXTRACT(MONTH FROM SYSDATE) AS Col2
     , EXTRACT(DAY FROM SYSDATE) AS Col3
     , EXTRACT(HOUR FROM SYSTIMESTAMP) AS Col4
     , EXTRACT(MINUTE FROM SYSTIMESTAMP) AS Col5
     , EXTRACT(SECOND FROM SYSTIMESTAMP) AS Col6
  FROM DUAL;


SELECT SYSDATE + 1 AS Col1
     , SYSDATE + 2 AS Col2
     , SYSDATE - 2 AS Col3
     , SYSDATE - 1 AS Col4
     , SYSDATE + INTERVAL '1' DAY AS Col5
     , SYSDATE + INTERVAL '2' DAY AS Col6
     , SYSDATE - INTERVAL '1' DAY AS Col7
     , SYSDATE - INTERVAL '2' DAY AS Col8
     , SYSDATE + INTERVAL '1' MONTH AS Col9
     , SYSDATE + INTERVAL '1' YEAR AS Col10
     , SYSDATE + INTERVAL '1' HOUR AS Col11
     , SYSDATE + INTERVAL '1' MINUTE AS Col12
     , SYSDATE + INTERVAL '1' SECOND AS Col13
  FROM DUAL;


SELECT 1234 AS Col1
     , TO_CHAR(1234) AS Col2
     , TO_CHAR(1000000, 'L999,999,999')
     , TO_CHAR(1000000, '000,000,000')
     , TO_CHAR(SYSDATE) AS Col3
     , TO_CHAR(SYSDATE, 'YYYYMMDD') AS Col4
     , TO_CHAR(SYSDATE, 'YYYY/MM/DD') AS Col5
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS Col6
     , TO_CHAR(SYSDATE, 'YYYY.MM.DD') AS Col7
     , TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') AS Col8
  FROM DUAL;


SELECT TO_DATE(20220425) AS Col1
     , TO_DATE('20220425') AS Col2
     , TO_DATE('2022/04/25') AS Col3
     , TO_DATE('2022-04-25') AS Col4
     , TO_DATE('2022.04.25') AS Col5
     , TO_DATE('2022년 04월 25일', 'YYYY"년" MM"월" DD"일"') AS Col6
  FROM DUAL;


SELECT TO_NUMBER('12345')
     , TO_NUMBER('123.45')
     , TO_NUMBER('123,456', '999,999')
     , TO_NUMBER('FF', 'XX')
  FROM DUAL;


SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD'))
  FROM DUAL;