Object-relational mapping
===

> [자바 ORM 표준 JPA 프로그래밍](http://book.naver.com/bookdb/book_detail.nhn?bid=9252528) (김영한 저. 에이콘출판. 2015) 을 학습하며 책 내용 중 일부를 요약.

## 용어 정리
- JPA: Java Persistence API 의 약자로 자바의 ORM 기술 표준. JPA를 사용하려면 JPA를 구현한 ORM 프레임워크를 사용해야 함.
- ORM: Object-relational mapping 의 약자로 객체와 테이블을 매핑. 대표적인 ORM 프레임워크에는 하이버네이트, EclipseLink 등이 있음.
- 영속성: 데이터를 생성한 프로그램의 실행이 종료되더라도 사라지지 않는 데이터의 특성을 의미.

## JAVA - SQL의 문제

> 객체생성 - DAO정의 - SQL 작성 - 쿼리결과를 객체에 맵핑

- 위의 과정이 각 객체마다 반복
- C.R.U.D를 위한 모든 쿼리를 작성
- SQL에 의존적

### 패러다임의 불일치

객체를 생성한 후 이 객체 인스턴스의 상태인 속성을 어딘가에 영구적으로 보관할 필요. 이에 따라 데이터베이스에 보관. 하지만 객체와 관계형 데이터베이스는 지향하는 목적이 다르기 때문에 객체 구조를 테이블 구조에 저장하는데 한계가 있어 결국 데이터 중심의 모델로 변해감.

## JPA

- 생산성: JDBC, SQL 등을 생략 가능. 개발에만 집중.
- 유지보수: 필드를 추가하거나 삭제해도 수정해야 할 코드가 줄어듬.
- 패러다임 불일치 해결
- 데이터 접근 추상화와 벤더 독립성: 특정 DBMS 기술에 종속되지 않음.

## 객체맵핑

- `@Entity`: 이 클래스를 테이블과 매핑함을 알림. 이 클래스를 엔티티 클래스라 함.
- `@Table`: 엔티티 클래스에 매핑할 테이블 정보를 알려줌.
- `@Id`: 엔티티 클래스의 필드를 테이블의 기본키에 매핑.
- `@Column`: 필드를 칼럼에 매핑.
- 매핑정보가없는필드: 매핑 어노테이션을 (@Id 또는 @Column) 생략하면 필드명을 사용해서 컬럼명으로 매핑.

## 설정 정보 관리

`persistence.xml` 을 통해 JPA 사용에 필요한 설정 정보를 관리.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence" version="2.1">

    <!-- 일반적으로 연결할 데이터베이스 하나당 영속성 유닛 하나를 등록 -->
    <persistence-unit name="jpabook">

        <properties>

            <!-- 필수 속성 -->
            <!-- JDBC드라이버 -->
            <property name="javax.persistence.jdbc.driver" value="org.h2.Driver"/>
            <!-- DB접속 아이디 -->
            <property name="javax.persistence.jdbc.user" value="sa"/>
            <!-- DB접속 패스워드 -->
            <property name="javax.persistence.jdbc.password" value=""/>
            <!-- DB접속 URL -->
            <property name="javax.persistence.jdbc.url" value="jdbc:h2:tcp://localhost/~/test"/>
            <!-- DB 방언(Dialect) -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.H2Dialect" />

            <!-- 옵션 -->
            <!-- 실행한SQL을출력 -->
            <property name="hibernate.show_sql" value="true" />
            <!-- 실행한SQL을보기쉽게정렬 -->
            <property name="hibernate.format_sql" value="true" />
            <!-- SQL을출력할때주석도함께출력 -->
            <property name="hibernate.use_sql_comments" value="true" />
            <!-- JPA표준에 맞춘 새로운 키 생성 전략 사용 -->
            <property name="hibernate.id.new_generator_mappings" value="true" />
            <property name="hibernate.hbm2ddl.auto" value="create" />
            <property name="hibernate.ejb.naming_strategy" value="org.hibernate.cfg.ImprovedNamingStrategy" />
        </properties>
    </persistence-unit>

</persistence>
```

## JPA 애플리케이션 개발

```java
public static void main(String[] args) {
    // 엔티티 매니저 팩토리 생성
    EntityManagerFactory entityManagerFactory =
            Persistence.createEntityManagerFactory("jpabook");
    // 엔티티 매니저 생성
    EntityManager entityManager = entityManagerFactory.createEntityManager();
    // 트랜잭션 획득
    EntityTransaction entityTransaction = entityManager.getTransaction();

    try {
        entityTransaction.begin(); // 트랜잭션 시작
        logic(entityManager); // 비즈니스 로직 실행
        entityTransaction.commit(); // 트랜잭션 커밋
    } catch (Exception e) {
        entityTransaction.rollback(); // 트랜잭션 롤백
    } finally {
        entityManager.close(); // 엔티티 매니저 종료
    }
    entityManagerFactory.close(); // 엔티티 매니저 팩토리 종료
}

private static void logic(EntityManager entityManager) {
    // 비즈니스 로직 구현
}
```

`persistence.xml` 정보를 바탕으로 엔티티 매니저 팩토리를 생성. 엔티티매니저팩토리는 JPA를 동작시키기 위해 설정 정보를 읽고, 기반 객체를 생성하고, 구현체에 따라서는 커넥션 풀도 생성하기 때문에 생성 비용이 큼. 따라서 엔티티매니저팩토리는 애플리케이션 전체에 딱 한 번 생성하여 공유 사용.

`EntityManager entityManager = entityManagerFactory.createEntityManager();`

팩토리로부터 엔티티매니저를 생성한 후 이 매니저를 통해 엔티티를 데이터베이스에 C.R.U.D. 엔티티 매니저는 내부에 데이터 커넥션을 유지하며 데이터베이스와 통신하기 때문에 개발자는 가상의 데이터베이스로 생각할 수도 있다.

## 비즈니스 로직
```java
private static void logic(EntityManager entityManager) {
    String id = "id1";
    Member member = new Member();
    member.setId(id);
    member.setUsername("Kyu");
    member.setAge(7);

    //등록
    entityManager.persist(member);

    //수정
    member.setAge(3);

    //한건조회
    Member findMember = entityManager.find(Member.class, id);
    System.out.println("findMember= " + findMember.getUsername() + ", age= " + member.getAge());

    //목록조회 (JPQL)
    List<Member> members = entityManager
            .createQuery("select m from Member m", Member.class)
            .getResultList();
    System.out.println("member.size= " + members.size());

    //삭제
    entityManager.remove(member);
}
```

## 영속성 컨텍스트

> 엔티티를 영구 저장하는 환경

`entityManager.persist(member);` 메소드는 엔티티 매니저를 사용해 회원 엔티티를 영속성 컨텍스트에 저장.

#### 엔티티 생명주기

- 비영속: 영속성 컨텍스트와 무관한 상태 `Member member = new Member();`
- 영속: 영속성 컨텍스트에 저장된 상태 `entityManager.persist(member);`
- 준영속: 영속성 컨텍스트에 저장되었다가 분리 된 상태 `entityManager.detach(member);`
- 삭제: 삭제된 상태 `entityManager.remove(member);`
 
#### 영속성 컨텍스트가 엔티티를 관리할 때의 장점

- 1차 캐시: 항상 DB를 직접 조회하지 않고 1차 캐시에서 먼저 조회
- 동일성 보장
- 트랜잭션을 지원하는 쓰기 지연: `transaction.commit()`을 하는 순간 DB에 모아 둔 쿼리를 전송
- 변경 감지: 엔티티의 변경을 자동으로 반영 (영속상태의 엔티티에만 적용)
- 지연 로딩

#### 플러쉬

`flush()`는 영속성 컨텍스트의 변경 내용을 DB에 반영.

- 직접호출
- 트랜잭션 커밋 시 자동 호출
- JPQL 쿼리 실행 시 자동 호출

#### 준영속

1차 캐시부터 쓰기 지연 SQL 저장소까지 해당 엔티티를 관리하기 위한 모든 정보를 제거하는 것.

- `detach()` 특정 엔티를 준영속 상태로 전환
- `clear()` 영속성 컨텍스트 전체를 초기화
- `close()` 해당 영속성 컨텍스트가 관리하던 영속 상태의 엔티티가 모두 준영속 상태로 전환
- `merge()` 준영속 상태의 엔티티를 다시 영속 상태로 변경

## 엔티티 매핑

#### @Entity

JPA를 통해 테이블과 매핑할 클래스는 해당 어노테이션을 필수로 포함. `name`을 따로 설정하지 않으면 클래스 이름을 그대로 사용.

- 기본 생성자 필수 (파라미터가 없는 public or protected)
- final, enum, interface, inner 클래스에는 사용 불가
- 저장할 필드에 final 사용 금지

#### @Table

엔티티와 매핑할 테이블을 지정. 생락하면 매핑한 엔티티 이름을 테이블 이름으로 사용.