# 실존 코드로 배우는 실용주의 디자인 패턴

> [실전 코드로 배우는 실용주의 디자인 패턴. 앨런 홀럽. 송치형 역. 사이텍미디어. 2006](https://book.naver.com/bookdb/book_detail.nhn?bid=2500990)

## CH2. 인터페이스로 프로그래밍 하기 그리고 몇 개의 생성패턴
### 왜 `extends` 가 나쁜가?
- 일반적으로 결합도(coupling) 는 낮을수록 좋음.
- 상속은 파생클래스가 기반클래스에 강하게 결합. 기반 클래스를 조금만 수정했는데 전체 프로그램이 오작동 할 수 있음. 즉, 기반 클래스가 수정되었을 때 모든 파생클래스가 테스트 대상이 됨.
- 원치 않는 메서드까지 전부 상속을 받아야 하고 불필요한 메서드에서 임의로 예외를 던지게 하거나 동작하지 않도록 하면 LSP 를 위반하게 됨. LSP를 지키지 않으면 다형성을 이용한 코딩을 어렵게 만듬.

```java
public class Stack extends ArrayList {
    private int topOfStack = 0;

    public void push(Object article) {
        add(topOfStack++, article);
    }

    public Object pop() {
        return remove(topOfStack);
    }

    public void pushMany(Object... articles) {
        Arrays.stream(articles)
                .forEach(article -> pushMany(articles));
    }
}

```

```java
Stack stack = new Stack();
stack.push(1);
stack.push(2);
stack.clear();
```

책의 예제는 `java.util.ArrayList` 를 상속하는 `Stack` 을 만듬. 여기서 몇가지 문제가 발생함.

- `Stack` 을 사용할 때 상속 받은 `ArrayList`의 모든 기능까지도 사용할 수 있음.
- `ArrayList` 에는 `clear()` 라는 시그니처가 있는데 이 메서드는 하위 클래스 즉, `Stack`에 있는 `topOfStack` 이라는 변수를 모름. 따라서 해당 메서드를 호출해도 `topOfStack` 이 초기화 되지 않음. `clear`를 호출한 후, `Stack`에서 구현한 3개의 시그니처는 기대한대로 동작하지 않음.
- 대안으로 합성과 위임을 사용하면 `Stack` 안의 `ArrayList`를 캡슐화 할 수 있음.
- 반면, 위임을 사용하면 깨지기 쉬운 클래스 문제를 해결하는 대신 구현의 용이함을 어느 정도 포기해야 함. 즉, 좀 더 구현이 고됨.

```java
class Stack {
	private ArrayList theData = new ArrayList();
	// 중략
}
```
