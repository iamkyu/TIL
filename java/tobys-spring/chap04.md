# 4장. 예외

> [토비의 스프링 3.1](http://book.naver.com/bookdb/book_detail.nhn?bid=7006516) (이일민 저. 에이콘출판. 2010) 을 공부하며 책 내용 중 일부를 요약.

예제 소스를 따라해 본 것은  github에  각 챕터별로 branch를 나눠 커밋하고 있다. (`Java8`, `Spring4.2`)
> [https://github.com/iamkyu/spring-framework-study/tree/chap04](https://github.com/iamkyu/spring-framework-study/tree/chap04) 

## 예외 처리의 핵심 원칙

`try - catch` 문을 통해 예외를 캐치하는 것은 좋은데, 아무것도 하지 않고 넘어가는 일은 정말 위험한 일이다. 이런 식의 자바 코드가 서적의 예제나 강의에도 심심치 않게 등장한다.

> 모든 예외는 적절하게 복구되던지 작업을 멈추고 운영자 또는 개발자에게 통보되어야 한다. - *P.281*

```java
// 초난감 예외처리
public void method1() throw Exception {
	method2();
	//...
}

public void method2() throw Exception {
	method3();
	//...
}

public void method3() throw Exception {
	//...
}
```

## 예외의 종류와 특정

### <U>Error</U>

시스템에 뭔가 비정상적인 상황이 발생했을 때 사용. 주로 VM에서 발생하는 것이기 때문에, 어플리케이션 레벨에서 에러를 잡거나 처리하려고 하면 안된다. 처리할 방법이 없기 때문이다.

- OutOfMemoryError 
- ThreadDeath
- 등등

### <U>Exception</U>

#### [Checked Exception]

`Exception` 클래스의 서브 클래스이면서 `RuntimeException` 를 상속하지 않은 클래스들로 체크 예외가 발생할 수 있는 메소드를 사용할 때 반드시 `try-catch` 문으로 예외를 잡던지 `throw` 를 통해 예외를 던져줘야 한다.

#### [Unchecked Exception]

`java.leng.RuntimeException` 클래스를 상속한 예외들은 예외 처리를 강제하지 않기 때문에 언체크드 예외 라고 불림. 이런 예외들은 피할 수 있지만 개발자가 부주의 해서 발생할 수 있는 예외이기 때문에, Error와 마찬가지로 `catch` 나 `throw` 로 예외를 처리하도록 강제하지 않는다.


## 예외처리 방법

#### [예외복구]

예외를 어떤식으로든 복구할 가능성이 있을 때, 단순히 에러 메세지를 사용자에게 던지는 것이 아니라 다른 작업 흐름으로 자연스럽게 유도한다.

- ex) 네트워크 접속이 원활하지 않을 때 일정 간격으로 재 접속을 시도하도록 처리 등

```java
int maxretry = MAX_RETRY;
while (maxretry) {
	try {

	} catch (someException e) {

	} finally {

	}
}

// 일정 횟수 재시도 후에도 실패 시 예외 발생
throw new RetryFailedException();
```

#### [예외처리 회피]

예외처리를 자신이 담당하지 않고 자신을 호출 한 쪽으로 던져버리는 방법. 긴밀하게 역할을 분담하고 있는 관계에서 다른 오브젝트가 예외처리 방법을 지고 있는 경우가 아니라면 이렇게 예외를 던져버리는 것은 무책임한 책임 회피다.

#### [예외전환]

예외 회피와 비슷하게 예외를 복구해서 정상적인 상태로 만들 수 없을 때 예외를 메소드 밖으로 던져버리는 방법. 단, 예외회피와 달리 예외를 그대로 던지는 것이 아니라 적절한 예외로 전환해서 던진다.


```java
// 예외를 캐치해서 에러코드를 확인 후 적합한 예외로 전환하여 던지는 예제
public void sqlExceptionTranslate() {

	try {
		//...
	} catch(SQLException e) {
		if(e.getErrorCode() == MySqlErrorNumbers.ER_DUP_ETNRY) 
			throw DuplicateUserIdException()
		else
			throw Exception();
	}
}
```