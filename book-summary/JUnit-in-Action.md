# JUnit in Action

테스트 클래스의 조건

- 접근제어자는 public이어야 한다.
- 파라미터를 받지 않는 생성자를 제공 해야 한다.

테스트 메소드의 조건

- @Test 어노테이션이 부여되어야 한다.
- 접근제어자는 public이어야 한다.
- 파라미터를 받지 않아야 한다.
- 반환형은 void여야 한다.

| assertXxx() method | 기능 |
|--------|--------|
|assertArrayEquals("message", A, B)|배열 A와 B의 일치 여부 확인|
|assertEquals("message", A, B)|객체 A와 B의 일치 확인. B를 파라미터로 A의 equals()호출|
|assertSame("message", A, B)|객체 A와 B가 같은 객체임을 확인. Eqauls는 동등성(equals), Same은 동일성(==) 체크.|
|assertTrue("message", A)|조건 A가 True임을 확인|
|assertNotNull("message", A)|객체 A가 null이 아님을 확인|

assert 메소드를 호출할 때 에러 메세지도 함께 전달하면 테스트가 많아졌을 때 실패한 원인을 파악하기가 더 쉬워진다.

```
@Ignore(value="message")
```

@Ignore 어노테이션을 활용하여 아직 충분히 검증 된 테스트케이스가 작성되지 않았을 때, @Test 어노테이션을 지우거나 메소드명을 바꾸지 않고도 테스트를 건너뛰도록 할 수 있다. 테스트를 건너뛸 때는 반드시 그 이유를 명시하는 것이 좋다.

## Hamcrest Matcher

--

## 소프트웨어 테스트
- 통합테스트
- 기능테스트
- 스트레스 테스트와 부하테스트
- 인수테스트

## 스텁(Stub)
