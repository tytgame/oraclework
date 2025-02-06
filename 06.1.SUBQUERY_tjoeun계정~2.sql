/*
    * 서브쿼리
      하나의 SQL문 안에 포함된 또다른 SELECT문
      메인 SQL문의 보조 역할을 하는 쿼리문
*/
-- 간단한 서브쿼링 예1
-- 박정보 사원과 같은 부서에 속한 사원들 조회
-- 1. 박정보 사원의 부서
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '박정보';

-- 2. 부서코드가 D9인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 2개의 쿼리문을 합치면
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '박정보');
                    
-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 직급코드, 급여 조회
-- 1. 평균급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;

--2. 평균급여보다 급여를 많이 받는 사원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047662;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);
-------------------------------------------------------------------------------------------
/*
    *서브쿼리의 구분
    서브쿼리르 수행한 결과값이 몇행 몇열이냐에 따라 분류
    - 단일행 서브쿼리 : 서브쿼리를 실행한 결과 오로지 1개일 때(한행 한열)
    - 다중행 서브쿼리 : 서브쿼리를 실행한 결과 여러행일 때(여러행 한열)
    - 다중열 서브쿼리 : 서브쿼리를 실행한 결과 여러열일 떄(한행 여러열)
    - 다중행 다중열 서브쿼리 : 서브쿼리를 실행한 결과 여러행 여러열일 때(여러행 여러열)
    
    >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/
/*
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
      - 비교연산자 사용가능
        =, !=, >, < ...
*/
--1. 전 직원의 평균급여보다 급여를 더 적게 받게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < ( SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY;

-- 최저 급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
               FROM EMPLOYEE);
-- 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');

-- 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서이름, 급여 조회
-->>오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
        AND SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
-->> ANSI 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');

-- 서브쿼리에 나온 결과는 제외하여 조회하고 싶을때
-- 지정보사원과 같은 부서원들의 사번, 사원명, 부서명을 조회. 지정보는 제외
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
      AND DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME ='지정보')
      AND EMP_NAME != '지정보';

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME ='지정보')
      AND EMP_NAME != '지정보';

--GROUP BY
--부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
-- 1.부서별 급여합 중에서 가장 큰 값 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);
------------------------------------------------------------------------------------
/*
    * 다중행 서브쿼리
      -   IN 서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있다면
      
      - > ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 큰 경우
                        즉, 결과값 중 가장 작은값 보다 클 경우
      - < ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 작은 경우
                        즉, 결과값 중 가장 큰 값 보다 작을 경우
      -   ALL : 서브쿼리의 값들 중 가장 큰값보다 더 큰값을 얻어올 때
*/

-- 조정연 또는 지정보 사원과 같은 직급을 가진 사원들의 사번, 사원명, 직급코드, 급여 조회
-- 1. 조정연 또는 지정보 사원의 직급
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('조정연','지정보');
--WHERE EMP_NAME = '조정연' OR EMP_NAME = '지정보';

-- 2. J3, J7인 직원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('조정연','지정보'));

-- 대리 직급임에도 과장의 급여의 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급명, 급여조회
-- 1. 과장들의 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='과장';

-- 2. 대리 중에 과장 급여의 최소값(2,220,000)보다 큰 직원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
      AND SALARY > 2200000;
      
-- 3. ANY 구문으로 하면
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
      AND SALARY > ANY(2200000, 2500000, 3760000);
      
-- 4. 위의 쿼리문을 하나로 하면
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
      AND SALARY > ANY(SELECT SALARY
                       FROM EMPLOYEE
                       JOIN JOB USING(JOB_CODE)
                       WHERE JOB_NAME ='과장');
                       
-- 단일행 서브쿼리
SELECT MIN(SALARY)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='과장';

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
      AND SALARY > ( SELECT MIN(SALARY)
                     FROM EMPLOYEE
                     JOIN JOB USING(JOB_CODE)
                     WHERE JOB_NAME ='과장');

-- 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급명, 급여 조회
-- 과장의 가장 큰 금액보다 적게 받는 차장
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='차장';

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장'
      AND SALARY < ANY(SELECT SALARY
                       FROM EMPLOYEE
                       JOIN JOB USING(JOB_CODE)
                       WHERE JOB_NAME ='과장');

-- ALL : 서브쿼리의 값들 중 가장 큰값보다 더 큰값을 얻어올 때
-- 차장의 가장 큰 급여보다 더 많이 받는 과장 사번, 사원명, 직급명, 급여 조회
-- 차장의 가장 큰 급여
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';
      
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
      AND SALARY > ALL(SELECT SALARY
                       FROM EMPLOYEE
                       JOIN JOB USING(JOB_CODE)
                       WHERE JOB_NAME = '차장');

------------------------------------------------------------------------------------
/*
    * 다중열 서브쿼리
       : 서브쿼리의 결과값이 행은 하나 열은 여러개
*/
-- 구정하 사원과 같은 부서코드, 직급코드에 해당하는 사원들의 사번, 사원명, 부서코드, 직급코드를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE = 구정하 부서코드
--      AND JOB_CODE = 구정하 직급코드
      ;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (
                  SELECT DEPT_CODE
                  FROM EMPLOYEE
                  WHERE EMP_NAME = '구정하'
                  )
      AND JOB_CODE = (
                  SELECT JOB_CODE
                  FROM EMPLOYEE
                  WHERE EMP_NAME = '구정하'
                  );
-- >> 다중행 서브쿼리
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
                                SELECT DEPT_CODE,JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '구정하'
                                );

-- 하정연 사원의 직급코드와 사수가 같은 사원의 사번, 사원명, 직급코드, 사수ID 조회
-- 하정연 사원의 직급코드
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하정연';

-- 하정연 사원의 사수
SELECT MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '하정연';

-- 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '하정연');

-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID
      AND (E.JOB_CODE = J.JOB_CODE)
      AND SUBSTR(EMP_NO,1,2) BETWEEN 70 AND 79
      AND SUBSTR(EMP_NO,8,1) IN ('2','4')
      AND SUBSTR(EMP_NAME,1,1) = '전';
-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RRRR')) 나이, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID
      AND (E.JOB_CODE = J.JOB_CODE);
--      AND (
--            SELECT MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RRRR')))
--            FROM EMPLOYEE
--            );
            --TODO 막내 조건 찾기
-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
      AND EMP_NAME LIKE '%하%';
-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID
      AND (E.JOB_CODE = J.JOB_CODE)
      AND DEPT_CODE IN ('D5','D6');
-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE DEPT_CODE = DEPT_ID
      AND LOCATION_ID = LOCAL_CODE
      AND BONUS IS NOT NULL;
-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, JOB J
WHERE DEPT_CODE = DEPT_ID
      AND LOCATION_ID = LOCAL_CODE
      AND J.JOB_CODE = E.JOB_CODE;
      -- TODO : NULL 처리된 사람은? 
-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_CODE
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE DEPT_CODE = DEPT_ID
      AND LOCATION_ID = LOCAL_CODE
      AND NATIONAL_CODE IN ('KO','JP');
-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하정연');
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
      AND E.JOB_CODE IN ('J4','J7')
      AND BONUS IS NULL;
      -- TODO: NVL은 어디서?
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT COUNT(*)
FROM EMPLOYEE
WHERE END_DATE IS NULL;
-- 안함 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용                
--	안함 12-2. 인라인 뷰 사용      
--	안함 12-3. WITH 사용
-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
-- 안함 14. WITH를 이용하여 급여합과 급여평균 조회



