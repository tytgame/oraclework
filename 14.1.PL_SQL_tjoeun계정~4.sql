/*
    * PL / SQL
      오라클 자체에 내장되어 있는 절차적 언어
      SQL 문장 내에서 변수 정의 , 조건 처리(IF), 반복문(LOOP, FOR, WHILE)등을 지원함
      
    * PL / SQL 구조
    - [선언부 (DECLARE SECTION)] : DECLARE로 시작, 변수나 상수 정의 및 초기화하는 부분
    - 실행부 (EXCUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
    - [예외처리부 (EXCEPTION SECTION)] : 예외처리 부분
*/
-- 화면에 출력문을 보려면
SET SERVEROUTPUT ON;

-- 출력문 : HELLO ORACLE
BEGIN
-- System.out.println("HELLO ORACLE"); > 자바
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/
/*
    1. DECLARE 선언부
    변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능)
    일반타입 변수, 레퍼런스 스타일 변수, ROW타입 변수
    
    1.1) 일반타입변수 선언 및 초기화
         변수명 [CONSTANT] 자료형 [:= 값]
*/
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    -- 자바에서 = 와 오라클의 := 는 동일한 의미 (왼쪽 값을 오른쪽에 넣어라)
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 800;
    ENAME := '배정남';
    
    DBMS_OUTPUT.PUT_LINE('EID:'||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME:'||ENAME);
    DBMS_OUTPUT.PUT_LINE('PI'||PI);
END;
/

-- 1.2) 레퍼런스 스타일 변수 선언 및 초기화 (테이블의 컬럼의 데이터타입을 참조하여 그 타입으로 지정)
--      변수명 테이블명.컬럼명%TYPE;

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE; -- VARCHAR2
    ENAME EMPLOYEE.EMP_NAME%TYPE; -- VARCHAR2
    SAL EMPLOYEE.SALARY%TYPE; -- NUMBER
BEGIN
    EID := '200';
    ENAME := '유재석';
    SAL := 2500000;

    DBMS_OUTPUT.PUT_LINE('EID:'||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME:'||ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL'||SAL);
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE; -- VARCHAR2
    ENAME EMPLOYEE.EMP_NAME%TYPE; -- VARCHAR2
    SAL EMPLOYEE.SALARY%TYPE; -- NUMBER
BEGIN
/* 200번 사원을 조회하여 변수에 담음
  SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL      -- 변수에 SELECT의 결과를 넣어줌
    FROM EMPLOYEE
    WHERE EMP_ID = 200;
*/

-- 사용자로부터 EMP_ID 받기
  SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL      
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    
    DBMS_OUTPUT.PUT_LINE('EID:'||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME:'||ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL'||SAL);
END;
/

-------------------------------------------실습문제----------------------------------------------------------------
/*
    레퍼런스 타입변수로 EID, ENAME, JCODE, SAL, DTITLE을 선언하고
    각 자료형을 테이블을 참조하여 넣기
    
    사용자가 입력한 사번의 사원을 변수에 담겨있는 값 출력
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID:'||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME:'||ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE:'||JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL:'||SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE:'||DTITLE);
    
END;
/

-- 1.3) ROW타입 변수
--      테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
--      변수명 테이블명%ROWTYPE;

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN 
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번; 
    
    DBMS_OUTPUT.PUT_LINE('사원명:'||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여:'||E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스:'||NVL(E.BONUS,0));
END;
/

-- 오류
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN 
    SELECT EMP_ID,EMP_NAME -- 무조건 *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번; 
    
    DBMS_OUTPUT.PUT_LINE('사원명:'||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여:'||E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스:'||NVL(E.BONUS,0));
END;
/

-----------------------------------------------------------------------------------------------------------
/*
    * BEGIN
     < 조건문 >
     1) IF 조건식 THEN 실행내용 END IF; (단일 실행문)
*/

-- 사번 입력받은 후 사번, 사원명, 급여, 보너스율(%) 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력하기 전에 '보너스를 받지 않는 사원입니다' 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
        
    DBMS_OUTPUT.PUT_LINE('사번:'||EID);
    DBMS_OUTPUT.PUT_LINE('사원명:'||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여:'||SAL);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
        END IF;
        
    DBMS_OUTPUT.PUT_LINE('보너스:'||BONUS*100||'%');
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE문)

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
        
    DBMS_OUTPUT.PUT_LINE('사번:'||EID);
    DBMS_OUTPUT.PUT_LINE('사원명:'||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여:'||SAL);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스:'||BONUS*100||'%');
    END IF;
END;
/

----------------------------------------------------실습 문제------------------------------------------------------------------------
/*
    레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
    참조 변수 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    일반 변수 : TEAM(소속)
    
    실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
           단) NCODE 값이 KO일 때 => TEAM 변수에 '국내팀'
               NCODE 값이 KO가 아닐때 => TEAM 변수에 '해외팀'
               
    출력 : 사번, 이름, 부서명, 소속
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);
BEGIN
    TEAM := '국내팀';
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
    JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번:'||EID);
    DBMS_OUTPUT.PUT_LINE('이름:'||ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명:'||DTITLE);
    IF NCODE != 'L1' 
        THEN TEAM := '해외팀';
    END IF;
    DBMS_OUTPUT.PUT_LINE('TEAM:'||TEAM);
END;
/

--------------------------------------------------------------실습문제---------------------------------------------------------------------
-- 사용자에게 입력받은 사번인 사원의 급여를 조회하여 SAL 변수에 대입하고
-- 5백만원 이상이면 '고급'
-- 3백만원 이상이면 '중급'
-- 3백만원 미만이면 '초급'
-- 출력문 : 해당 사원의 급여 등급은 ??입니다

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번:'||EID);
    DBMS_OUTPUT.PUT_LINE('이름:'||ENAME);
    IF SAL >= 5000000 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 고급 입니다');
    ELSIF SAL >= 3000000 AND SAL < 5000000 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 중급 입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 초급 입니다');
    END IF;
END;
/

/* CASE 문

-- 4)
        CASE 비교대상자
            WHEN 비교할값1 THEN 실행내용1
            WHEN 비교할값2 THEN 실행내용2
            WHEN 비교할값3 THEN 실행내용3
            ELSE 실행내용4
        END;

        - 자바에서
        SWITCH(변수) {         --> CASE
            CASE 비교할값1:     --> WHEN
                실행내용1;      --> THEN
            DEFAULT :          --> ELSE
                실행내용2
        
        
        }
*/

-- 사용자로부터 입력받은 사번의 사원을 부서코드를 이용하여 부서이름으로 출력하기
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(20);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사팀'
                WHEN 'D2' THEN '회계관리팀'
                WHEN 'D3' THEN '마케팅팀'
                WHEN 'D4' THEN '국내영업팀'
                WHEN 'D8' THEN '기술지원팀'
                WHEN 'D9' THEN '총무팀'
                ELSE '해외영업팀'
            END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME||'는 '||DNAME||'입니다');
END;
/

-- 사용자로부터 입력받은 사번의 사원을 부서코드를 이용하여 근무지역 출력하기
-- D5 : 일본
-- D6 : 중국
-- D7 : 미국
-- D8 : 러시아
-- 나머지 : 한국

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DCODE DEPARTMENT.DEPT_ID;
    LCODE LOCATION.LOCAL_CODE%TYPE;
    NCODE NATIONAL.NATIONAL_CODE%TYPE;
    NNAME NATIONAL.NATIONAL_NAME%TYPE;
    LOCNAME VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_ID, LOCAL_CODE, NATIONAL_CODE, NATIONAL_NAME
    INTO EID, ENAME, DECODE, LCODE, NCODE, NNAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
    JOIN NATIONAL USING(NATIONAL_CODE)
    WHERE EMP_ID = &사번;
    
    LOCNAME := CASE EMP.DEPT_ID
        WHEN 'D5' THEN '일본'
        WHEN 'D6' THEN '중국'
        WHEN 'D7' THEN '미국'
        WHEN 'D8' THEN '러시아'
        ELSE '한국'
        END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME||'의 근무지역은 '||LOCNAME||'입니다');
END;
/

-------------------------------------------------------------------------------------
/*
    <LOOP>
    1. BASIC LOOP문
    
    [표현식]
    LOOP
        반복적으로 실행할 구문;
        * 반복을 빠져나갈수 있는 구문;
    END LOOP;
    
    - 반복문을 빠져나오는 구문
    1) IF 조건식 THEN EXIT; END IF;
    2) EXIT WHEN 조건식;
*/
    
-- 1~5까지 1씩 증가하면서 출력
-- 1) IF 조건식 이용으로 빠져나오기
DECLARE 
    X NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(X);
        X := X+1;
        
        
        
        IF X=6 THEN EXIT;
        END IF;
        
    END LOOP;
END;
/
    
-- 2) EXIT WHEN 조건식
DECLARE 
    X NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(X);
        X := X+1;
        EXIT WHEN X=6;
    END LOOP;
END;
/    

-------------------------------------------------------------------------------------------------------
/*
    2. FOR LOOP문
    
    [표현식]
    FOR 변수 IN [REVERSE] 초기값..최종값
    LOOP
        반복적으로 실행할 구문
    END LOOP;
*/
    
BEGIN
    FOR X IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(X);
    END LOOP;
END;
/

-- 테이블과 시퀀스를 생성하여
-- INSERT하는 구문

CREATE TABLE PLSQL(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);
    
CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2
NOCACHE;

-- 100행 INSERT
BEGIN
    FOR X IN 1..100
    LOOP
        INSERT INTO PLSQL VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
END;
/

-------------------------------------------------------------------------------------------------
/*
    3. WHILE LOOP문
    
        [표현식]
        WHILE 조건식
        LOOP
            반복적으로 실행할 구문;
        END LOOP;
*/

DECLARE 
    X NUMBER := 1;
BEGIN
    WHILE X < 6
    LOOP
        DBMS_OUTPUT.PUT_LINE(X);
        X := X +1;
    END LOOP;
END;
/

----------------------------------------------------------------------------------------------
/*
    <예외처리부>
    
    [표현식]
    EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1
        WHEN 예외명2 THEN 예외처리구문2
        .
        .
        .
        WHEN OTHERS THEN 예외처리구문

        * 시스템 예외(오라클에서 미리 정의해둔 예외)
        - NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우
        - TOO_MANY_ROWS : SELECT한 결과가 여러행일 경우
        - ZERO_DIVIDE : 0으로 나눌 경우
        - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 경우
        ...
*/
-- 0으로 나눌때
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10/&숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : '||RESULT);
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다');
    -- WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('예외가 발생했습니다');
END;
/

-- UNIQUE 제약조건 위배
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = &변경할사번
    WHERE EMP_NAME = '이정하';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다');
END;
/

-- 사수번호 200번은 여러명, 201번은 1명, 204번도 여러명
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사수사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('사번 : '||ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('한 행만 조회가능');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다');
END;
/
-----------------------------------------------실습 문제-------------------------------------------------------
/*
    1. 사원의 연봉을 구하는 PL/SQL 블럭 작성. 보너스가 있는 사원은 보너스도 포함(IF문으로)
    2. 구구단 짝수단만 출력
        2.1) FOR LOOP
        2.2) WHILE LOOP
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY*12 연봉, BONUS
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 :'||EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||ENAME);
 
    IF BONUS IS NOT NULL THEN 
        DBMS_OUTPUT.PUT_LINE('보너스 포함 연봉 : '||SAL*(1+BONUS));
    ELSE
         DBMS_OUTPUT.PUT_LINE('연봉 : '||SAL);
    END IF;
END;
/

-- 구구단 짝수단만 출력
--2.1) FOR LOOP
DECLARE
    DAN NUMBER := 0;
BEGIN
    FOR X IN 1..4
    LOOP
        DAN := DAN + 2;
            FOR Y IN 1..9
            LOOP
                DBMS_OUTPUT.PUT_LINE(DAN||'*'||Y||' = '||DAN * Y);
            END LOOP;
    END LOOP;
END;
/

--2.2) WHILE LOOP
DECLARE 
    DAN NUMBER := 0;
    X NUMBER :=0;
BEGIN
    WHILE DAN < 8
    LOOP
    X := 0;
    DAN := DAN+2;
            WHILE X < 9
            LOOP
                X := X+1;
                DBMS_OUTPUT.PUT_LINE(DAN||'*'||X||' = '||DAN * X);
            END LOOP;
    END LOOP;
END;
/

---------------------------------------------------------------------------------------------------------------------------









    