/*
    *DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
    오라클에서 제공하는 객체(OBJECT)를 만들고(CREATE), 구조를 변경하고(ALTER), 구조를 삭제(DROP)하는 언어
    즉, 실제 데이터값이 아닌 구조 자체를 정의하는 언어
    주로 DB관리자, 설계자가 사용함
    
    오라클 객체(구조): 테이블, 뷰, 시퀀스, 인덱스, 패키지, 트리거, 프로시저, 함수, 동의어, 사용자
*/

--========================================================================================
--                                  CREATE : 객체 생성
--========================================================================================
/*
    1. 테이블 생성
    - 테이블이란 : 행과 열로 구성된 가장 기본적인 데이터베이스 객체
                 모든 데이터들은 테이블을 통해 저장됨
    
    [표현식]
    CREATE TABLE 테이블명 (
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형,
        ...
    )
    
    *자료형
    - 문자(CHAR(바이트크기)|VARCHAR2(바이트크기)) -> 반드시 크기지정 해야됨
      > CHAR : 최대 2000BYTE까지 지정 가능
               고정 길이(지정한 크기보다 적은 값이 들어와도 공백으로 채워서 지정한 크기만큼 고정)
               고정된 길이의 데이터 사용시
      > VARCHAR2 : 최대 4000BYTE까지 지정 가능
                   가변 길이(들어오는 값의 크기에 따라 공간이 맞춰짐)
                   데이터의 길이가 일정하지 않을 때 사용
    - 숫자(NUMBER)
    - 날짜(DATE)
*/
-- 회원에 대한 테이블 (MEMBER 생성)
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

------------------------------------------------------------------------------------------
/*
    2. 컬럼에 주석 달기(컬럼에 대한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성하였을 경우 수정 후 다시 실행하면 됨
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '회원성별';
COMMENT ON COLUMN MEMBER.PHONE IS '회원전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '회원이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원일';

COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com','25/02/07');
INSERT INTO MEMBER VALUES(2,'user02','pwd02','나순이','여','010-1982-2929','na@google.com','25/02/06');

INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO MEMBER VALUES(3, 'user03', 'pwd03', '이고잉', NULL, NULL, NULL, NULL);

-------------------------------------------------------------------------------------------------
/*
    <제약 조건>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적으로 한다.
      : 데이터에 결합이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
      1) 개체 무결성 제약조건 : NOT NULL, UNIQUE, PRIMARY KEY 조건 위배
      2) 참조 무결성 제약조건 : FOREIGN KEY(외래키) 조건 위배
        
    * 종류 : NOT NULL, UNIQUE, CHECK(조건), PRIMARY KEY, FOREIGN KEY
    
    * 제약조건을 부여하는 방식 2가지
      1) 컬럼 레벨 방식 : 컬럼명 자료형 옆에 기술
      2) 테이블 레벨 방식 : 모든 컬럼을 정의한 후 마지막 기술
*/
---------------------------------------------------------------------------------------------------
/*
    * NOT NULL 제약조건
    해당 컬럼에 반드시 값이 존재해야 함(즉, NULL이 들어오면 안됨)
    삽입/수정시 NULL값을 허용하지 않는다
    
    ** 주의사항 : 컬럼 레벨 방식밖에 안됨
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);


INSERT INTO MEM_NOTNULL VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com');
INSERT INTO MEM_NOTNULL VALUES(2,'user02','pwd02','나순이','여','010-1982-2929','na@google.com');
INSERT INTO MEM_NOTNULL VALUES(3,'user03','pwd03','이고잉', NULL, NULL, NULL);

INSERT INTO MEM_NOTNULL VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- NOT NULL 제약조건 위배 오류

INSERT INTO MEM_NOTNULL VALUES(3,'user03','pwd03','이고잉', NULL, NULL, NULL);
-- NO, ID가 중복 되었음에도 잘 추가

---------------------------------------------------------------------------------------------------
/*
    * UNIQUE 제약 조건
      해당 컬럼에 중복된 값이 들어가서는 안됨
      컬럼값에 중복값을 제한하는 제약조건
      삽입/수정시 기존의 데이터와 동일한 중복값이 있을 때 오류 발생
      
      >> 컬럼 레벨 방식
         CREATE TABLE 테이블명(
          컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
          컬럼명 자료형 
          ...
          
         );
         
      >> 테이블 레벨 방식
         CREATE TABLE 테이블명(
          컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
          컬럼명 자료형 
          ...
          [CONSTRAINT 제약조건명] 제약조건(컬럼명),
          [CONSTRAINT 제약조건명] 제약조건(컬럼명),
         );
*/

-- 컬럼 레벨 방식
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL CONSTRAINT NO_UNI UNIQUE, 
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_UNIQUE VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com');
INSERT INTO MEM_UNIQUE VALUES(2,'user02','pwd02','나순이','여','010-1982-2929','na@google.com');
INSERT INTO MEM_UNIQUE VALUES(3,'user03','pwd03','이고잉', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE VALUES(3,'user03','pwd03','박한빛', NULL, NULL, NULL);

-- 테이블 레벨 방식
CREATE TABLE MEM_UNIQUE2(
    MEM_NO NUMBER NOT NULL, 
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_NO),
    UNIQUE (MEM_ID)
);

INSERT INTO MEM_UNIQUE2 VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com');
INSERT INTO MEM_UNIQUE2 VALUES(2,'user02','pwd02','나순이','여','010-1982-2929','na@google.com');
INSERT INTO MEM_UNIQUE2 VALUES(3,'user03','pwd03','이고잉', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE2 VALUES(3,'user03','pwd03','박한빛', NULL, NULL, NULL);


CREATE TABLE MEM_UNIQUE3(
    MEM_NO NUMBER CONSTRAINT NO_NULL NOT NULL, 
    MEM_ID VARCHAR2(20) CONSTRAINT ID_NULL NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT PWD_NULL NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT NAME_NULL NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    CONSTRAINT NO_UNIQUE UNIQUE (MEM_NO),
    CONSTRAINT ID_UNIQUE UNIQUE (MEM_ID)
);

INSERT INTO MEM_UNIQUE3 VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com');
INSERT INTO MEM_UNIQUE3 VALUES(2,'user02','pwd02','나순이','여','010-1982-2929','na@google.com');
INSERT INTO MEM_UNIQUE3 VALUES(3,'user03','pwd03','이고잉', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE3 VALUES(3,'user03','pwd03','박한빛', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE3 VALUES(4,'user04','pwd04','박아름','ㄴ', NULL, NULL);
--> 성별이 유효한 값이 아니어도 입력됨

---------------------------------------------------------------------------------------------------
/*
    *CHECK(조건식) 제약조건
    해당 컬럼값에 들어올 수 있는 값에 대한 조건 제시
    해당 조건에 맞는 데이터값만 입력하도록 함
*/

-- 
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),-- CHECK (GENDER IN('남','여')), -- 컬럼 레벨 방식
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_NO),
    CHECK (GENDER IN('남','여')) -- 테이블 레벨 방식
    
);

INSERT INTO MEM_CHECK VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com');
INSERT INTO MEM_CHECK VALUES(2,'user02','pwd02','나순이','남','010-1234-5678','hong@naver.com');
--CHECK 제약조건 위배
---------------------------------------------------------------------------------------------------
/*
    *PRIMARY KEY(기본키) 제약조건
    테이블에서 각 행들을 식별하기 위해 사용된 컬럼에 부여하는 제약조건(식별자 역할)
    그 컬럼에 NOT NULL + UNIQUE 제약조건 -> 검색, 삭제, 수정 등에 기본키의 컬럼을 이용함
    EX)회원번호, 학번, 사원번호, 운송장번호, 예약번호, 주문번호...
    
    ** 유의 사항 : 한 테이블당 한개만 설정 가능
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_PRIMARY(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
);

-- 테이블 레벨 방식
CREATE TABLE MEM_PRIMARY2(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    PRIMARY KEY(MEM_NO),
    UNIQUE(MEM_ID),
    CHECK (GENDER IN('남','여'))
);

CREATE TABLE MEM_PRIMARY3(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) PRIMARY KEY -- 오류 : PRIMARY KEY는 한개만 가능
);

INSERT INTO MEM_PRIMARY VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com');
INSERT INTO MEM_PRIMARY VALUES(2,'user02','pwd02','나순이','여','010-1234-5678','na@naver.com');
INSERT INTO MEM_PRIMARY VALUES(NULL,'user02','pwd02','나순이','남','010-1234-5678','hong@naver.com');
INSERT INTO MEM_PRIMARY VALUES(2,'user03','pwd03','나순이','여','010-1234-5678','hong@naver.com');

/*
    *복합키 : 기본키를 2개 이상의 컬럼을 묶어서 사용

    -복합키 사용 예) 찜하기
    회원번호 | 상품
       1    |  A  ->  1A
       1    |  A      부적합(PRIMARY KEY 위배)
       1    |  B  ->  1B
       1    |  C  ->  1C
       2    |  A  ->  2A
       2    |  C  ->  2C
       
*/

CREATE TABLE TB_MULTI (
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

-- 오류 : PRIMARY KEY는 하나만 가능
CREATE TABLE TB_MULTI2 (
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO),
    PRIMARY KEY(PRODUCT_NAME)
);



INSERT INTO TB_MULTI VALUES(1, 'A', SYSDATE);
INSERT INTO TB_MULTI VALUES(1, 'B', SYSDATE);
INSERT INTO TB_MULTI VALUES(2, 'B', SYSDATE);
INSERT INTO TB_MULTI VALUES(1, 'B', SYSDATE);  --> 오류

------------------------------------------------------------------------------------------------
-- 회원등급에 대한 테이블 생성
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
-- 일반회원(10) , 우수회원 (20) , 특별회원 (30)
INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

-- 회원 정보 테이블 생성
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER --> 회원 등급 보관 컬럼
);

INSERT INTO MEM VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com', NULL);
INSERT INTO MEM VALUES(2,'user02','pwd02','나순이','여','010-1234-5678','na@naver.com', 10);
INSERT INTO MEM VALUES(3,'user03','pwd03','김순이','여','010-1234-5678','na@naver.com', 50);
-- 유효한 회원 등급이 아님에도 입력됨

------------------------------------------------------------------------------------------------
/*
    *FOREIGN KEY(외래키) 제약조건
     다른 테이블에 존재하는 값만 들어와야 되는 컬럼에 부여하는 제약조건
     -- > 다른 테이블을 참조한다라고 표현
     -- > 주로 FOREIGN KEY 제약조건에 의해 테이블 간의 관계가 형성됨
     
     >> 컬럼 레벨 방식
        - 컬럼명 자료형 REFERENCES 참조할 테이블명(참조할 컬럼명)
          컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할 테이블명(참조할 컬럼명)
          
     >> 테이블 레벨 방식
        - FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블(참조할 컬럼명)
          [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블(참조할 컬럼명)
*/  
CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) NOT NULL
);

INSERT INTO MEM2 VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com', NULL);
INSERT INTO MEM2 VALUES(2,'user02','pwd02','나순이','여','010-1234-5678','na@naver.com', 10);
INSERT INTO MEM2 VALUES(3,'user03','pwd03','김순이','여','010-1234-5678','na@naver.com', 50);

-- MEM_GRADE(부모 테이블) MEM2(자식 테이블)
--> 이때 부모테이블에서 테이터값을 삭제할경우 문제 발생
--  데이터 삭제시 : DELETE FROM 테이블명 WHERE 조건;

--> MEM_GRADE테이블에서 10번 등급 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
-- 자식 테이블에 10이라는 값을 사용하고 있기 때문에 삭제 안됨

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 30;
-- 자식 테이블에 30이라는 값을 사용하고 있지 않기 때문에 삭제됨

--> 자식 테이블이 값을 사용하고 있을 경우 부모테이블로 부터 무조건 삭제가 안되는 삭제 제한 옵션이 걸려있음
INSERT INTO MEM_GRADE VALUES (30, '특별회원');

-- * 삭제 옵션 * ---------------------------------------------------------------
/*
    자식테이블 생성시 외래키 제약조건 기술시 삭제옵션 지정가능
    - ON DELETE RESTRICTED(기본값) : 삭제 불가. 자식이 값을 사용하면 부모테이블의 값 삭제 불가
    - ON DELETE SET NULL : 부모 데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터의 값을 NULL로 변경
    - ON DELETE CASCADE : 부모 데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터도 같이 삭제(행 전체삭제)
*/
DROP TABLE MEM;
DROP TABLE MEM2;
DROP TABLE MEM3;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE SET NULL
    -- 부모테이블의 PRIMARY KEY와 외래키 제약조건을 걸때는 컬럼명 생략가능.
    -- (자동으로 부모테이블의 PRIMARY KEY와 외래키를 맺음)
);

INSERT INTO MEM VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com', NULL);
INSERT INTO MEM VALUES(2,'user02','pwd02','나순이','여','010-1234-5678','na@naver.com', 10);
INSERT INTO MEM VALUES(3,'user03','pwd03','김순이','여','010-1234-5678','na@naver.com', 20);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
-- 삭제됨. 자식테이블의 값은 NULL

INSERT INTO MEM_GRADE VALUES (10, '일반회원');

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE CASCADE
);

INSERT INTO MEM VALUES(1,'user01','pwd01','홍길동','남','010-1234-5678','hong@naver.com', NULL);
INSERT INTO MEM VALUES(2,'user02','pwd02','나순이','여','010-1234-5678','na@naver.com', 10);
INSERT INTO MEM VALUES(3,'user03','pwd03','김순이','여','010-1234-5678','na@naver.com', 20);
INSERT INTO MEM VALUES(4,'user04','pwd04','김갑순','여','010-1334-5678','na11@naver.com', 10);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
-- 삭제됨. 자식도 같이 삭제(행전체 삭제)

------------------------------------------------------------------------------------------------
/*
    <DEFAULT 기본값>
    : 제약조건은 아님
    컬럼에 값을 넣지 않았을 때 기본값이 들어가도록 해줄 수 있음
    
    컬럼명 자료형 DEFAULT 기본값 [제약조건]
*/

CREATE TABLE MEMBER2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_NAME VARCHAR2(30) NOT NULL,
    HOBBY VARCHAR2(50) DEFAULT '없음',
    MEM_DATE DATE DEFAULT SYSDATE,
    AGE NUMBER
);

INSERT INTO MEMBER2 VALUES(1,'user01','홍길동','운동','25/02/09', 25);
INSERT INTO MEMBER2 VALUES(2,'user02','김한글',null,null,NULL);
INSERT INTO MEMBER2 VALUES(3,'user03','이고잉',default,default,null);

INSERT INTO MEMBER2(MEM_NO,MEM_ID,MEM_NAME) VALUES(4,'user04','빛나리');

--=============================================================================================
--                                  <tjoeun 계정으로 실행>
/*
    <SUBQUERY를 이용한 테이블 생성>
    : 테이블을 복사하는 개념
    - 테이블의 구조만 복사
    - 테이블의 구조및 데이터 모두 복사
    
    [표현식]
    CREATE TABLE 테이블명
    AS 서브쿼리;
*/

-- EMPLOYEE테이블의 구조만 복사
CREATE TABLE EMPLOYEE_COPY
AS SELECT *
   FROM EMPLOYEE;
   
   -- 컬럼, 데이터 복사
   -- 제약조건의 경우 NOT NULL만 복사됨

-- EMPLOYEE테이블을 구조만 복사
CREATE TABLE EMPLOYEE_COPY2
AS SELECT *
   FROM EMPLOYEE
   WHERE 1=0;
   
-- EMPLOYEE테이블의 몇개의 컬럼과 연봉의 컬럼이 있는 테이블 생성
CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, EMP_NO, SALARY, SALARY*12 연봉
   FROM EMPLOYEE;
   -- 오류 : 산술, 함수식이 들어간 컬럼은 반드시 별칭 부여
   
------------------------------------------------------------------------------------------------
/*
    *테이블을 다 생성한 후에 제약조건 추가
    ALTER TABLE 테이블명 변경할 ADD(MODIFY) 내용;
    - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
    - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)]
    - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
    - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에대한 조건식)
    - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL
*/
-- EMPLOYEE_COPY 테이블에 PRIMARY KEY 추가
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLOYEE_COPY 테이블에 DEPARTMENT FOREIGN KEY 추가
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

-- COMMENT 넣기
COMMENT ON COLUMN EMPLOYEE_COPY.EMP_ID IS '회원번호';
COMMENT ON COLUMN EMPLOYEE_COPY.EMP_NAME IS '회원번호';

-- DEFAULT MODIFY
ALTER TABLE EMPLOYEE_COPY MODIFY EMT_YN NOT NULL;
-- 
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;
--=============================================================================================
--                                  <ddl 계정으로 실행>
-- 출판사 테이블

CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
    PUB_NAME VARCHAR2(50) CONSTRAINT PUBLISHER_NN NOT NULL,
    PHONE VARCHAR2(13)
);

INSERT INTO TB_PUBLISHER VALUES(1,'김갑생','02-123-4567');
INSERT INTO TB_PUBLISHER VALUES(2,'이갑생','02-133-4567');
INSERT INTO TB_PUBLISHER VALUES(3,'박갑생','02-163-4567');

COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사전화번호';

-- 도서 테이블

CREATE TABLE TB_BOOK(
    BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(50) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(20) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER REFERENCES TB_PUBLISHER(PUB_NO) ON DELETE CASCADE
);


INSERT INTO TB_BOOK VALUES(1,'책이름1','작가이름1',5000,1);
INSERT INTO TB_BOOK VALUES(2,'책이름2','작가이름2',6000,1);
INSERT INTO TB_BOOK VALUES(3,'책이름3','작가이름3',5000,2);
INSERT INTO TB_BOOK VALUES(4,'책이름4','작가이름4',8000,2);
INSERT INTO TB_BOOK VALUES(5,'책이름5','작가이름5',5000,2);

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';

-- 회원 테이블
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(30) CONSTRAINT MEMBER_UQ UNIQUE,
    MEMBER_PWD VARCHAR2(30) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER CHAR(1) CONSTRAINT MEMBER_CK_GEN CHECK (GENDER IN('M','F')),
    ADDRESS VARCHAR2(70),
    PHONE VARCHAR2(13),
    STATUS CHAR(1) DEFAULT 'N' CONSTRAINT MEMBER_CK_STA CHECK (STATUS IN('Y','N')),
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL
);

INSERT INTO TB_MEMBER VALUES(1,'USER01','PWD01','김갑생','M','서울시 어딘가','010-1234-5678','Y',SYSDATE);
INSERT INTO TB_MEMBER VALUES(2,'USER02','PWD02','박갑생','F','서울시 어딘가','010-1234-5678','N',SYSDATE);
INSERT INTO TB_MEMBER VALUES(3,'USER03','PWD03','이갑생','M','서울시 어딘가','010-1234-5678','Y',SYSDATE);
INSERT INTO TB_MEMBER VALUES(4,'USER04','PWD04','최갑생','F','서울시 어딘가','010-1234-5678','N',SYSDATE);
INSERT INTO TB_MEMBER VALUES(5,'USER05','PWD05','장갑생','M','서울시 어딘가','010-1234-5678','Y',SYSDATE);

COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';

-- 대여목록 테이블
CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER(MEMBER_NO) ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK(BK_NO) ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);

INSERT INTO TB_RENT VALUES(1,2,3,SYSDATE);
INSERT INTO TB_RENT VALUES(2,1,2,SYSDATE);
INSERT INTO TB_RENT VALUES(3,3,3,SYSDATE);

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';

----------------------------------------------------------------------------------------------------
-- 1.
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

-- 2.
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10) 
);

-- 3.
ALTER TABLE TB_CATEGORY ADD PRIMARY KEY(NAME);

-- 4.
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

-- 5.
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10);
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);

-- 6.
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

-- 7.
ALTER TABLE TB_CLASS_TYPE DROP PRIMARY KEY;
ALTER TABLE TB_CATEGORY DROP PRIMARY KEY;

ALTER TABLE TB_CLASS_TYPE ADD CONSTRAINT PK_CLASS_TYPE_NO PRIMARY KEY(CLASS_TYPE_NO);
ALTER TABLE TB_CATEGORY ADD CONSTRAINT PK_CATEGORY_NAME PRIMARY KEY(CATEGORY_NAME);

-- 8.
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT;

-- 9. 
ALTER TABLE TB_DEPARTMENT ADD FOREIGN KEY(CATEGORY) REFERENCES TB_CATEGORY;

-- 10.
CREATE OR REPLACE VIEW VW_학생일반정보
AS SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름, STUDENT_ADDRESS 주소
    FROM TB_STUDENT;

-- 11.
CREATE VIEW VW_지도면담
AS SELECT STUDENT_NAME 학생이름, DEPARTMENT_NAME 학과이름, PROFESSOR_NAME 지도교수이름
    FROM TB_STUDENT S
    JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
    JOIN TB_PROFESSOR P ON (PROFESSOR_NO = COACH_PROFESSOR_NO)
    ORDER BY D.DEPARTMENT_NO;
    
-- 12. 학과별로 그룹 묶고 카운트
CREATE VIEW VW_학과별학생수
AS SELECT DEPARTMENT_NAME, COUNT(*) 합계
    FROM TB_DEPARTMENT D
    JOIN TB_STUDENT S ON (D.DEPARTMENT_NO = S.DEPARTMENT_NO)
    GROUP BY D.DEPARTMENT_NO, DEPARTMENT_NAME;

-- 13.
UPDATE TB_STUDENT
SET STUDENT_NAME = '유예성'
WHERE STUDENT_NO = 'A213046';

-- 14.
-- 테이블 속성을 NOT NULL로 변경하면 VIEW를 통한 데이터 변경 예방이 가능하다

-- 15.
SELECT *
FROM(
        SELECT CLASS_NO 과목번호, CLASS_NAME 과목이름, COUNT(*) "누적수강생수(명)"
        FROM TB_GRADE
        JOIN TB_CLASS USING (CLASS_NO)
        WHERE TERM_NO LIKE '2009%' OR
              TERM_NO LIKE '2008%' OR
              TERM_NO LIKE '2007%' OR
              TERM_NO LIKE '2006%' OR
              TERM_NO LIKE '2005%'
        GROUP BY CLASS_NO, CLASS_NAME
        ORDER BY 3 DESC
    )
WHERE ROWNUM <= 3;
