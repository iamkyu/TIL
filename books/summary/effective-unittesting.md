# Effective Unit Testing

> 라쎄 코스켈라. 이복연 역. 한빛미디어. 2013 [[상세정보](https://book.naver.com/bookdb/book_detail.nhn?bid=7350902)]

## 목차

<!-- TOC -->

- [Effective Unit Testing](#effective-unit-testing)
    - [목차](#목차)
    - [1. 좋은 테스트의 약속](#1-좋은-테스트의-약속)
        - [테스트의 가치](#테스트의-가치)
    - [2. 좋은 테스트란](#2-좋은-테스트란)
    - [3. 테스트 더블](#3-테스트-더블)
        - [테스트 대상 코드의 격리](#테스트-대상-코드의-격리)
        - [테스트 더블의 종류](#테스트-더블의-종류)
            - [1. 스텁](#1-스텁)
            - [2. 가짜 객체](#2-가짜-객체)
            - [3. 테스트 스파이](#3-테스트-스파이)
            - [4. Mock 객체](#4-mock-객체)
        - [테스트 더블 활용 지침](#테스트-더블-활용-지침)
            - [단위 테스트의 구조](#단위-테스트의-구조)

<!-- /TOC -->

## 1. 좋은 테스트의 약속

### 테스트의 가치

1. 테스트는 실수를 바로 잡아줌.
2. 테스트는 실사용에 적합한 설계를 끌어냄.
3. 테스트는 원하는 동작을 명확히 알려주어 군더더기를 없앰.
4. 테스트를 작성해서 얻게 되는 가장 큰 수확은 테스트 자체가 아닌 작성 과정에서 얻는 깨달음.

![테스트의 직간접적인 영향](https://user-images.githubusercontent.com/13076271/44656951-fc703200-aa35-11e8-9d06-ba437d8d67b1.png)

반면 엉터리로 작성한 테스트 코드는 가독성뿐 아니라 안정성, 신뢰성, 실행속도에도 악영향을 끼침. 테스트의 잠재 가치를 전부 끌어내고 **품질 고지**와 **설계 고지**에 도달하려면

1. 테스트 코드도 제품 코드를 다루듯 하라. 믿고 의지할 수 있을 만큼 철저하게 리팩토링하고 높은 품질을 유지하라
2. 테스트를 제품 코드가 목적과 쓰임새에 적합한 구조가 되게끔 이끌어주는 설계 수단으로 활용하라

이 책은 1번에 관한 내용으로 구성 됨. 2번에 관해서는 저자가 저술한 [[Test Driven](https://www.amazon.com/gp/product/1932394850/ref=dbs_a_def_rwt_bibl_vppi_i1)] 또는 [[테스트 주도 개발로 배우는 객체 지향 설계와 실천](https://book.naver.com/bookdb/book_detail.nhn?bid=7231228)]을 추천하고 있음.



## 2. 좋은 테스트란

1. 읽기 좋은 코드
   - 가독성과 결함 밀도는 반비례
   - 테스트의 의도를 파악할 수 있는 코드
2. 구조화 된 코드
   - 끝나지 않는 통짜 소스, 비대해진 코드는 누구도 손대고 싶어하지 않음
   - 사람의 두뇌와 사고 모델이 지지고 볶을 수 있을 정도로 정리 된 구조
   - 도메인 모델과 맞게 명확한 경계를 가진 구조
3. 올바르게 감시하는 코드
   - 어떻게 구현했느냐가 아닌 의도한 대로 구현했느냐를 검사하는 코드
4. 독립적인 테스트
   - 다음 요소와 관련이 있을 때는 각별한 주의 필요: 시간, 임의성, 동시성, 인프라, 기존데이터, 영속성, 네트워킹
   - '우리가 제어할 수 없는 특징'을 가진 종속성들은 테스트 더블로 교체하거나 원하는 대로 동작하는 환경에 코드를 고립시켜야 함



## 3. 테스트 더블

테스트 하려는 코드를 주변에서 분리하는 것이 테스트 더블을 활용하는 기본적인 이유

- 코드는 덩어리다. 서로 참조하는 코드들이 그물처럼 얽혀 있음
- 테스트 대상 코드의 동작을 검증하려 할 때 주변 코드를 모두 교체하여 테스트 환경 전반을 통제할 수 있으면 테스트 하기가 좋다

![](https://user-images.githubusercontent.com/13076271/44698631-b5c51b00-aabb-11e8-956a-d342ec567ded.png)

### 테스트 대상 코드의 격리

테스트 코드를 두 가지 분류

- 테스트 대상 코드
- 테스트 대상 코드와 상호작용하는 코드

그 결과로 테스트는 초점이 분명해지고, 이해하기 쉬워지고, 설정하기도 편해짐. 상호작용하는 코드를 테스트 더블로 대체함으로써

- 테스트 속도를 개선
- 예측 불가능한 실행 요소를 제거
- 특수항 상황을 시뮬레이션
- 감춰진 정보를 얻어냄

```java
public class CarTest {
    @Test
    public void engineIsStartedWhenCarStarts() {
        TestEngine engine = new TestEngine();
        new Car(engine).start();
        
        // 원래 Engine 객체에는 running 여부를 알 수 있는 메서드가 없지만
        // 테스트 더블로 대체함으로써 감춰진 정보를 얻는 메서드를 추가함으로써 행위를 검증
        assertTrue(engine.isRunning());
    }
}

public class TestEngine extends Engine {
    private boolean isRunning;
   
    public void start() { isRunning = true; } 
    public boolean isRunning() { return isRunning; }
}
```



### 테스트 더블의 종류

![테스트 더블의 종류](https://user-images.githubusercontent.com/13076271/44698633-b78ede80-aabb-11e8-9d69-8770487e7eaa.png)

#### 1. 스텁

> 원래의 구현을 최대한 단순한 것 (또는 아무것도 하지 않는 것)으로 대체하는 것.

```java
public class LoggerStub implements Logger {
    @Override public void log(LogLevel level, String msg) { 
        // do nothing 
    }
    
    @Override public LogLevel getLogLevel() {
        return LogLevel.WARN; // 하드 코딩 값을 반환
    }
}
```

위 예시에서 스텁을 사용하는 이유

- 테스트는 대상 코드가 로깅하는 내용에 전혀 관심 없다
- 가동 중인 로그 서버가 없으니 로깅은 어차피 실패했을 것
- 테스트 스위트가 콘솔로 로그를 찍어봤자 의미 없다



#### 2. 가짜 객체

> 진짜 객체의 행동을 흉내 내지만, 진짜 객체를 사용할 때 생기는 부수 효과나 연쇄 동작이 일어나지 않도록 경량화 하고 최적화 한 것.

```java
public class FakeUserRepository implements UserRepository {
    private Collection<User> users = new ArrayList<>();
    
    public void save(User user) { // 리스트에 저장 }
    public User findById(long id) { // 리스트에서 검색 }
    public User findByUsername(String username) { //리스트에서 검색 }
}
```

- 테스트간 직접 데이터베이스를 연결하는 것보다 빠름



#### 3. 테스트 스파이

> 발생한 이벤트를 기록해두었다가 나중에 테스트가 확인이 가능하도록 한 것.

```java
public void filter(List<?> list, Predicate<?> predicate) {...}
```

위 시그니쳐와 같이 리턴 타입이 없는 메서드에 값 변화를 검증하고 싶을 때 이벤트 또는 값을 내부적으로 저장하는 테스트 스파이로 진짜 객체를 대체하고 테스트간 사용.



#### 4. Mock 객체

> 특정 조건이 발생하면 미리 약속된 행동을 취하는 것.

```java
@Test
public void mock_test() {
    final Internet internet = mock(Internet.class);
    
    // 테스트 중 발생할 일과 그 일이 발생했을 때 행동지침을 기술
    when(internet.get(contains("langpair=en%7Cfi")))
        .thenReturn("{\"translatedText\":\"kukka\"}");
    
    Translator t = new Translator(internet);
    String translation = t.translate("flower", ENGLISH, FINISH);
    
    // get 메서드가 딱 한번만 호출되고, 인자가 약속 된 문자열을 포함하고 있다는 것을 단언
    verify(internet, times(1)).get(contains("langpair=en%7Cfi"));
    
    assertEquals("kukka", translation);
}
```

- 스텁보다 훨씬 정교한 테스트가 가능
- 예기치 않은 일이 발생하자마자 실패하게 됨



### 테스트 더블 활용 지침

- 두 객체 간 상호작용의 결과로 특정 메서드의 호출 여부를 확인하고 있다면 Mock 객체를 써야 할 가능성이 높음.
- Mock 객체를 사용했는데 테스트 코드가 생각만큼 깔끔하지 않다면 테스트 스파이를 사용할 수 있는지 생각해봄.
- 협력 객체는 자리만 지키면 되고 협력 객체가 대상 객체에 넘겨줄 응답도 테스트에서 통제 가능하다면 스텁이 정답.
- 필요한 서비스나 컴포넌트를 미처 준비하지 못해 스텁을 사용하고 있는데, 시나리오가 너무 복잡해서 벽에 부딪혔거나 테스트 코드가 관리하기 어려울 만큼 복잡해졌다면 가짜 객체의 구현을 고려.



#### 단위 테스트의 구조

- 준비-시작-단언 (AAA, arrange - act - assert)
- '행위 주도 관점' 에서는 GIVEN, WHEN, THEN 구조를 사용하는 것도 가능

세 영역 중 하나가 비대하다고 느껴진다면, 너무 많은 것을 한꺼번에 검사하려는 테스트일 가능성이 높음.