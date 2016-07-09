## 2장. 테스트

> [토비의 스프링 3.1](http://book.naver.com/bookdb/book_detail.nhn?bid=7006516) (이일민 저. 에이콘출판. 2010) 을 공부하며 책 내용 중 일부를 요약.

예제 소스를 따라해 본 것은  github에  각 챕터별로 branch를 나눠 커밋하고 있다. (`Java8`, `Spring4.2`)
> [https://github.com/iamkyu/spring-study/tree/chap02] (https://github.com/iamkyu/spring-study/tree/chap02)

<br>
일반적인 웹 애플리케이션 개발에서 DAO를 테스트하기 위해서는 서비스, 컨트롤, 뷰 까지 모든 레이어가 완성
되어야 하는 문제가 있음. 테스트 하고자 하는 대상에만 집중하여 방법에는 단위 테스트를 활용할 수 있음.

### 단위 테스트(Unit Test)
- 단위의 범위는 정형화 되어 있지 않지만 작을 수록 좋다.
- 테스트 검증의 자동화를 구현하여 빠르게 테스트 한다.

### 테스트 주도 개발: TDD (또는 테스트 우선 개발: TFD)
> 실패한 테스트를 성공시키기 위한 목적이 아닌 코드는 만들지 않는다.

`테스트코드` > `테스트실패` > `구현` > `테스트통과` > `개선` 의 사이클을 따르며 자연스럽게 모든 코드는 빠짐 없이 테스트로 검증. 사이클의 주기는 가능한 빠르게 한다.

#### JUnit을 통한 단위 테스트
```
import org.junit.Test;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

public class UserDaoTest {    
    @Test
    public void addAndGet() throws SQLException {
    	// 테스트코드
        // (중략)
        assertThat(user2.getName(), is(user.getName()));
        assertThat(user2.getPassword(), is(user.getPassword()));
	}
}   
```

예외상황에 대한 테스트는 아래 코드와 같이 어노테이션 부분에 예상 되는 예외를 명시한다. 해당 메소드를 테스트할 때 명시 된 예외가 발생해야 성공하는 테스트가 된다.

```
@Test(expected = EmptyResultDataAccessException.class)
```

@Before 어노테이션이 붙은 메소드는  @Test 어노테이션이 붙은 메소드 이전에 실행 된다. 하나의 클래스 안에 여러 개의 테스트 메소드가 있을 때, 공통 세팅을 준비할 때 유용. <br>@After 어노테이션의 경우 @Test 어노테이션이 붙은 메소드 이후에 실행 된다.

```
@Before
public void setUp() {
	// code
}
```
#### 테스트의 또 다른 활용
- 특정 프레임워크, 기술 등을 공부하기 위한 학습 테스트
- 코드에 오류가 있을 때 그 오류를 재현 하는 버그 테스트