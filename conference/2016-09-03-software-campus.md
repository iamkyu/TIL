# 2016년 상반기 소프트웨어 캠퍼스 강사 스터디 4기 발표회

- [http://onoffmix.com/event/75908]()


- 2016년 9월 3일 (토) 12시 30분 ~ 17시 30분
- 서울특별시 강남구 대치4동 토즈 선릉점




## 군살없이 스프링 세팅 / 신은철님

#### 군살 없이 스프링을 세팅한다는 것?

- 필요한 것만 세팅
- 세팅 된 모든 것을 알고 인지함



#### web.xml

 배포서술자. Web Application 의 시작.

```xml
<context-param>
  <param-name>contextConfigLocation</param-name>
  <param-value>/WEB-INF/applicationContext.xml</param-value>
</context-param>
```

```xml
<listener>
  <listener-class>
    org.springframework.web.context.ContextLoaderListener
  </listener-class>
</listener>
```

```xml
<servlet>
  <servlet-name>dispatcher</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <load-on-startup>1</load-on-startup>
</servlet>
```



#### servlet-context.xml

```xml
<mvc:annotation-driven/>
```

```xml
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
  <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
  <property name="prefix" value="/WEB-INF/jsp/"/>
  <property name="suffix" value=".jsp"/>
</bean>
```



## DBMS 성능 높이기 / 이정해님



### Optimizer

DBMS의 핵심. SQL을 가장 빠르고 효율적으로 수행할 최적의 처리경로를 생성해 주는 DBMS 핵심 엔진. 각 벤더별로 제공하는 옵티마이저를 확인하는 것이 좋음.



#### CBO: Cost Based Optimizer

1. 인덱스 상태
2. 데이터 분포
3. Key 종류
4. 테이블 참조제약
5. 기타..



#### 쿼리 리라이트(Re-Write)

1. 사용자 조인을 조정
2. 사용자 컬럼 캐스팅 조정
3. 조인 순서 변경
4. 조인 값 추가
5. 기타 재조정



- 리라이트 된 SQL을 확인하는 습관!
- 간단한 SQL은 옵티마이저 레벨을 낮추면 실행 시간이 1~2초 정도 단축



#### Driving Table

```sql
-- Good case
where 1=1
and 주민번호 = '1234567'
and 휴대폰번호 = '011123456'

-- Bad case
where 1=1
and 성별 = '남'
and 병역필 = '필'
```

유일한 값이 들어가는 칼럼을 우선 조건으로 하여 추출해 나가는 것이 빠름

- Cardinality(유일성): 컬럼데이터 중 중복 값을 제거한 유일한 데이터 갯수



### Table Space, Table

Page Size(or Block Size): 한 Row의 크기

- OLTP: Page Size가 낮은게 유리
- OLAP: Page Size가 높은게 유리



#### 데이터 입력 성능 높이기

- DBMS마다 데이터 입력하는 명령어가 2가지 이상 존재
  - IMPORT: 테이블의 모든 제약을 점검/인덱스를 모두 체크 하면서 데이터를 입력
  - LOAD: 일단 데이터 입력 공간을 만들어 놓고 밀어 넣음. 후에 제약조건/인덱스를 체크
- 입력 성능을 높이기 위한 방법
  - 정렬(SORT) 메모리 크기를 늘림
  - Bulk Load를 위한 메모리 크기를 늘림
  - TEMP Space 사이즈를 크게 늘림
  - 참조제약을 제거하고 입력 후 다시 제약조건 설정
  - 인덱스 삭제 후 재생성
  - 아카이브 로그 작성 일시 OFF



### SQL

#### 구조화 된 질의어

- DDL: Create, Drop, Alter
- DML: Insert, Update, Delete
- DCL: Commit, Rollback, Transaction



Char VS Varchar

- CHAR형은 데이터 길이에 상관 없이 지정된 공간 만큼 무조건 배정.
- VARCHAR형은 데이터에 맞춰서 공간 배정. 단 해당 컬럼의 데이터가 자주 Update 된다면 비용이 큼.



#### Date VS Varchar 

참고: [Varchar2(8) VS Date 어느 것이 우월한가?](http://scidb.tistory.com/entry/Varchar28-VS-Date-%EC%96%B4%EB%8A%90-%EA%B2%83%EC%9D%B4-%EC%9A%B0%EC%9B%94%ED%95%9C%EA%B0%80)

- Date 칼럼이 데이터 조회가 빠름
- Varchar 칼럼을 쓴 데이트 데이터는 품질 저하



#### 정수형

INT(10) 은 10자리 미만은 0으로 채우라는 의미(크기가 아닌 표현자리수를 의미)

- INT: 4Byte
- BIGINT: 8Byte



#### Groupby vs Distinct

- 공통의 목적: 중복 제거
- 정렬의 목적
  - Distinct: 중복만 제거 정렬 안 됨
  - Group by: 중복 제거 후 정렬된 값 도추
- 속도비교: 오라클은 Grup by가 빠름. 타 벤더는 차이가 있을 수 있음
- 결과의 목적: Group by 는 Having Count 가능



#### 기타 최적화

- DECODE, OR 함수 사용 자제
- 인덱스 사용
  - 부정형보다 긍정형 조건 사용
  - 가능한 PK Index 사용
  - 명확한 Where 조건 사용
- Data Type 을 일치 시켜 사용



### 인덱스

- 테이블에 저장된 데이터를 빠르게 조회하기 위한 데이터베이스 객체
- B-Tree 구조 (B-Tree 인덱스의 경우)
- Index 는 논리적/물리적으로 테이블과 독립적



## 자바 9 특징 훑어보기 / 유현석님

- JCP(Java Community Process): 자바 기술의 표준 기술 명세서를 개발하는 체제
- JSR(Java Specification Requests): 자바 플랫폼에 지안 된 실제 명세서와 최종결정 된 명세
- JEP(JDK Enhancement Proposal): 장기 로드맵



### 자바9에서 변화 된 부분

- 참고: [JEPs targeted to JDK 9, so far](http://openjdk.java.net/projects/jdk9/)



### Jigsaw Project

- [http://www.oracle.com/kr/corporate/magazines/winter-tech2-1429486-ko.pdf]()

- [Introduction to Modular Development](http://openjdk.java.net/projects/jigsaw/talks/intro-modular-dev-j1-2015.pdf)

  ​