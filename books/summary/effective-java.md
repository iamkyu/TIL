# Effective Java

- [3판](https://www.amazon.com/Effective-Java-3rd-Joshua-Bloch/dp/0134685997/ref=sr_1_1?ie=UTF8&qid=1532427641&sr=8-1&keywords=effective+java)의 새로 추가 된 내용 위주로 학습. 아직 번역서 안나옴.

- 번역 된 2판도 참고함. [이펙티브 자바. 조슈아 블로크 저. 이병준 역. 인사이트. 2014](https://book.naver.com/bookdb/book_detail.nhn?bid=8064518)

3판에서 추가 된 내용

> The third edition covers language and library features added in Java 7, 8, and 9, including the functional programming constructs that were added to its object-oriented roots. Many new items have been added, including a chapter devoted to lambdas and streams. 
>
> New coverage includes
>
> - Functional interfaces, lambda expressions, method references, and streams
> - Default and static methods in interfaces
> - Type inference, including the diamond operator for generic types
> - The @SafeVarargs annotation
> - The try-with-resources statement
> - New library features such as the Optional interface, java.time, and the convenience factory methods for collections



## Item 42. 익명 클래스 대신 람다를 사용하라

```java
Collections.sort(words, new Comparator<String>() {
    @Override
    public int compare(String o1, String o2) {
        return Integer.compare(o1.length(), o2.length());
    }
});
```

자바 8 이전에서는 하나의 추상 메서드를 가진 인터페이스 (또는 추상 클래스)가 익명 클래스를 통해 함수로 쓰였음. 하지만 익명클래스의 장황함은 자바에서의 함수형 프로그래밍 매력을 떨어뜨림.

```java
Collections.sort(words, (o1, o2) -> 
                 Integer.compare(o1.length(), o2.length()));

// construction method를 사용하여 더 간결해짐
Collections.sort(words, Comparator.comparingInt(String::length));

// List 인터페이스의 sort 메서드를 사용하여 더욱 더 간결해짐
words.sort(Comparator.comparingInt(String::length));
```

자바 8에서는 하나의 추상 메서드를 가진 인터페이스에 **함수형 인터페이스** 라는 개념이 도입되고 람다식을 통해 인터페이스의 인스턴스를 만들 수 있게 됨.

타입 추론을 통해 인자 값과 반환 값을 생략할 수 있고 익명 클래스보다 코드가 훨씬 간결해짐.

- 메서드나 클래스와 달리 람다에는 이름과 주석이 없음. 함수가 스스로를 설명하지 못하거나 3줄을 넘어가는 경우 람다에 넣지 말 것. 1줄이 제일 적당함.
- 함수형 인터페이스가 아닌 추상 클래스를나 여러 추상 메서드를 가진 인터페이스의 인스턴스는 여전히 익명 클래스를 사용해야 함.
- (TODO 정리) 람다는 스스로를 참조할 수 없음? this 키워드 관련