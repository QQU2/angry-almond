/* DELETE FROM 테이블명 WHERE 조건;
 * - 테이블의 행을 삭제
 * - 행의 갯수가 줄어듦
 */
SELECT * FROM EMP_COMMISSION WHERE COMMISSION_PCT = 0.1;
DELETE FROM EMP_COMMISSION WHERE COMMISSION_PCT = 0.1;

 --DISABLE/ENABLE CONSTRAINT 컬럼명: 
 --		FOREIGN KEY 제약 조건으로 컬럼 삭제가 불가능한 경우 제약 조건을 비활성화 할 수 있음
--예시--
DELETE FROM DEPARTMENT WHERE DEPT_ID = ‘D1’;
ALTER TABLE EMPLOYEE
DISABLE CONSTRAINT EMP_DEPTCODE_FK CASCADE;
ENABLE CONSTRAINT EMP_DEPTCODE_FK;

/* TRUNCATE TABLE 테이블명;
 * - 테이블 전체 행 삭제 시 사용
 * - DELETE보다 수행 속도가 빠르고 ROLLBACK을 통해 복구 불가능
 * - FOREIGN KEY 제약조건일 때는 적용 불가능하기 때문에 제약 조건을 비활성화 해야 삭제할 수 있음
 */

