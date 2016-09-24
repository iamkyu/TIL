# java8-in-action

> [자바 8 인 액션](http://book.naver.com/bookdb/book_detail.nhn?bid=8883567)(라울-게이브리얼 우르마 외 2명 저. 우정은 역. 한빛미디어. 2015) 을 공부하며 책 내용 중 일부를 요약.



> 또한, [가장 빨리 만나는 자바 8](http://book.naver.com/bookdb/book_detail.nhn?bid=7583421)(카이호스트만 저, 신경근 역, 길벗, 2014)도 참고하였는데, 여기서 인용한 구절은 [가장빨리만나는자바8, 페이지번호] 형식으로 표기한다. 페이지번호는 [전자책](https://ridibooks.com/v2/Detail?id=754012382) 기준이다.



# 3장. 람다 표현식

## 3.1 람다란 무엇인가?

람다라는 용어는 람다 미적분학 학계에서 개발한 시스템에서 유래. [(위키피디아)](https://ko.wikipedia.org/wiki/람다_대수)



### 람다표현식이란

- 메서드로 전달할 수 있는 익명 함수를 단순화 한 것.
- 나중에 한 번 이상 실행할 수 있도록 전달할 수 있는 코드 블록. [가장빨리만나는자바8, 22P]



### 특징

- **익명**: 보통의 메서드와 달라 이름이 없다.
- **함수**: 람다는 메서드처럼 특정 클래스에 종속되지 않으므로 함수라고 부른다. 하지만 메서드처럼 파라미터 리스트, 바디, 반환형식, 가능한 예외 리스트를 포함한다.
- **전달**: 람다 표현식을 메서드 인수로 전달하거나 변수로 저장할 수 있다.
- **간결성**: 익명 클래스처럼 많은 자질구레한 코드(행사 코드)를 구현할 필요가 없다.

```java
// 자바8 이전의 코드
Comparator<Apple> byWeight = new Comparator<Apple>() {
  public int compare(Apple a1, Apple a2) {
    	return a1.getWeight().compareTo(a2.getWeight());
  }
}

// 자바8의 람다표현식
Comparator<Apple> byWeight = 
  (Apple a1, Apple a2) -> a1.getWeight().compareTo(a2.getWeigth());
```



### 람다의 구성

```java
(Apple a1, Apple a2) // 파리미터 리스트
-> 					 // 화살표는 람다의 파리미터 리스트와 바디를 구분
a1.getWeight().compareTo(a2.getWeigth()); // 람다의 반환값에 해당하는 표현식
```



### 자바8에서 지원하는 람다표현식 예제

```java
// String 파라미터 하나를 가지고 int를 반환. return 문을 명시적으로 사용하지 않아도 됨.
(String s) -> s.length();

// Apple 형식의 파라미터를 하나 가지고 boolean을 반환.
(Apple a) -> a.getWeight()>150;

// 람다 표현식은 여러 행의 문장을 포함할 수도 있다.
(int x, int y) -> {
  System.out.println("Result: ");
  System.out.println(x+y);
}

// 파라미터가 없으며 int를 반환한다(42).
() -> 42;

// Apple 형식의 파리미터 2개를 가지고 두 사과의 무게 비교 결과를 반환
(Apple a1, Apple a2) -> a1.getWeight().compareTo(a2.getWeigth());
```

- 람다 표현식은 파라미터 타입을 추정할 수 있는 경우에는 타입을 생략할 수 있으며, 결과 타입은 항상 문맥으로부터 추정된다.  [가장빨리만나는자바8, 29P]
- ​

## 3.2 어디에, 어떻게 람다를 사용할까?

### 함수형인터페이스

정확히 하나의 추상 메서드를 지정하는 인터페이스

```java
// java.util.Comparator
public interface Comparator<T> {
  int compate(T o1, T o2);
}

// java.lang.Runnable
@FunctionalInterface
public interface Runnable {
    void run();
}
```

- 함수형 인터페이스를 활용하면 람다 표현식으로 함수형 인터페이스의 추상 메서드 구현을 직접 전달할 수 있다 (전체 표현식을 인터페이스의 인스턴스로 취급).
- `@FunctionalInterface` 어노테이션을 붙이면 컴파일러가 단일 추상메서드를 갖춘 인터페이스를 검사하고, javadoc  페이지에서 해당 인텊에시그 함수형 인터페이스임을 알리는 문장을 포함한다. 단일 추상 메서드를 갖춘 모든 인터페이스가 곧 함수형 인터페이스이기 때문에 어노테이션을 필수가 아니지만 가능한 사용하는 것이 좋다. [가장빨리만나는자바8, 33P]

```java
// 람다 사용
Runnable r1 = () -> System.out.println("Hello World!");

// 익명 클래스 사용
Runnable r2 = new Runnable() {
  @Override
  public void run() {
    System.out.println("Hello World!");
  }
};
```



## 3.4 함수형 인터페이스 사용

### 자바8의 대표적 함수형 인터페이스

| 함수형인터페이스            | 함수디스크립터           |
| ------------------- | ----------------- |
| Predicate<T>        | T -> boolean      |
| Consumer<T>         | T -> void         |
| Function<T, R>      | T -> R            |
| Supplier<T>         | () -> T           |
| UnaryOperator<T>    | T -> T            |
| BinaryOperator<T>   | (T, T) -> T       |
| BiPredicate<L, R>   | (L, R) -> boolean |
| BiConsumer<T, U>    | (T, U) -> void    |
| BiFunction<T, U, R> | (T, U) -> R       |



### java.util.function.Predicate<T>

```java
@FunctionalInterface
public interface Predicate<T> {
  boolean test(T t);
}

public static <T> List<T> filter(List<T> list, Predicate<T> p) {
  List<T> results = new ArrayList<>();
  for (T s : list) {
    if (p.test(s)) {
      results.add(s);
    }
  }
  return results;
}

Predicate<String> nonEmptyStringPredicate = (String s) -> !s.isEmpty();
List<String> nonEmpty = filter(listOfStrings, nonEmptyStringPredicate);
```



### java.util.function.consumer<T>

```java
@FunctionInterface
public interface Consumer<T> {
  	void accept(T t);
}

public static <T> void forEach(List<T> list, Consumer<T> c) {
  for (T i : list) {
    c.accept(i);
  }
}

forEach(
  Arrays.asList(1,2,3,4,5),
  (Integer i) -> System.out.println(i)
);
```



### java.util.function.Function<T, R>

```java
@FunctionInterface
public interface Function<T, R> {
  R apply(T t);
}

pubilc static <T, R> List<R> map(List<T> list, Function<T, R> f) {
  List<R> result = new ArrayList<>();
  for (T s : list) {
    result.add(f.apply(s));
  }
  return result;
}

List<Integer> l = map(
  Arrays.asList("lamdas", "in", "action"), 
  (String s) -> s.length()
);
```

