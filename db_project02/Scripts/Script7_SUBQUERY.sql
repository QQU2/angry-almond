/* SUBQUERY
 * 1. 단일행 서브쿼리: 서브쿼리의 조회결과 값의 개수가 1개
 * 		SELECT EMP_NAME, JOB_CODE, DEPT_XODE, SALARY
 * 		  FROM EMPLOYEES
 * 		 WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE);
 * 2. 다중행 서브쿼리: 서브쿼리의 조회 결과 값의 행이 여러개
 * 		SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
		  FROM EMPLOYEE
		 WHERE SALARY IN (SELECT MAX(SALARY)
		       				FROM EMPLOYEE
							GROUP BY DEPT_CODE)
 * 3. 다중열 서브쿼리: 서브 쿼리 조회 결과 컬럼 개수가 여러개
*  		SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
		  FROM EMPLOYEE
		 WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE
										  FROM EMPLOYEE
										 WHERE SUBSTR(EMP_NO, 8, 1)=2 AND ENT_YN=‘Y’);
 * 4. 다중행 다중열 서브쿼리: 서브쿼리의 조회 결과 컬럼의 개수와 행의 개수가 여러개
 * 		SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
		  FROM EMPLOYEE
		 WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
									FROM EMPLOYEE
									GROUP BY JOB_CODE)
		 ORDER BY 3;
 */ 

--인라인 뷰(INLINE-VIEW): from절에서 서브쿼리 사용한 것
SELECT * FROM EMPLOYEES;

SELECT ROWNUM, FIRST_NAME, LAST_NAME, SALARY, COMMISSION_PCT
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT NULL
 		AND ROWNUM <= 15
 ORDER BY SALARY DESC;

SELECT *
  FROM (SELECT FIRST_NAME, LAST_NAME, SALARY, COMMISSION_PCT
 		  FROM EMPLOYEES
		 WHERE COMMISSION_PCT IS NOT NULL
		 ORDER BY SALARY DESC)
WHERE ROWNUM <= 15;

/* WITH
 * - 서브쿼리에 이름을 붙여줌
 * - 인라인 뷰로 사용시 서브쿼리의 ##이름## 으로 FROM절에 기술 가능
 */ 
WITH EMP_COM 
AS (SELECT FIRST_NAME, LAST_NAME, SALARY, COMMISSION_PCT
	  FROM EMPLOYEES
	 WHERE COMMISSION_PCT IS NOT NULL
	 ORDER BY SALARY DESC)
SELECT * FROM EMP_COM;

/* RANK() OVER/ DENSE_RANK() OVER: 순위부여 기능
 * 동률 인정 X	  / 동률 인정 O
 */
 SELECT FIRST_NAME
	  , LAST_NAME
	  , SALARY 
	  , RANK() OVER (ORDER BY SALARY DESC)AS 순위
  FROM EMPLOYEES;

 SELECT FIRST_NAME
	  , LAST_NAME
	  , SALARY 
	  , DENSE_RANK() OVER (ORDER BY SALARY DESC)AS 순위
  FROM EMPLOYEES;
  
 --만약 일정 순위까지의 결과물을 조회하고 싶을 때
SELECT * 
FROM (SELECT FIRST_NAME, LAST_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS 순위
		FROM EMPLOYEES)
WHERE 순위 <= 5;