# Java Generics

> Oracle의 [Java Tutorials](https://docs.oracle.com/javase/tutorial/extra/generics/index.html)의 Generics 정리

JDK 5.0 부터 도입된 제네릭스<sup>generics</sup>를 사용하면 타입을 추상화 할 수 있음.

## 제네릭스 기본
```java
List list = new ArrayList();
list.add(new Integer(3));
Object x = list.iterator().next();
Integer y = (Integer) x;

assertThat(y.intValue()).isEqualTo(3);
```

위 코드에는 다음과 같은 문제가 있음.
1. 리스트에 모든 타입의 값을 넣을 수 있음. 자바에서 모든 클래스는 Object를 상속받기 때문.
2. 리스트에 어떤 타입의 값이 들어있는지 프로그래머가 이미 알고있더라도 꺼내서 캐스팅 하는 과정이 필요함.
3. 프로그래머의 실수로 캐스팅을 잘못하면 런타임 오류가 발생할 수 있음. 컴파일러는 Object 타입의 값을 반환한다는 것만 보장해줌. 따라서 컴파일 시점에는 오류를 발견하지 못함.

대안으로, Integer 타입을 담는 리스트를 사용하기 위해 다음과 같은 인터페이스를 만들 수 있음.

```java
public interface IntegerList {
    void add(Integer x);
    Iterator<Integer> iterator();
}
```

하지만 이렇게 사용하는 경우 다루게 될 타입에 특화 된 List 인터페이스를 모두 만들어야 함. DoubleList, StringList...
제네릭스를 통한 List 인터페이스를 살펴보면 다음과 같음.

```java
public interface List<E> extends Collection<E> {
    boolean add(E e);
    Iterator<E> iterator();
    // ...중략
}
```

오라클에서 권장하는 제네릭스 관련 네이밍 컨벤션은
- formal(뭐라고 번역해야 할까) 타입 파라미터는 한글자로 표기한다
- 소문자를 사용하지 않는다

에를 들어, `List<E>` 인터페이스에서 E 는 Element를 나타냄.



제네릭스를 사용하면 프로그래머가 자신의 의도를 표현하고 특정한 타입만 포함 가능하도록 제한하는 것이 가능.

```java
List<Integer> list = new ArrayList();
list.add(new Integer(3));
Integer x = list.iterator().next();

assertThat(x.intValue()).isEqualTo(3);
```

이제 List는 Integer 타입 파라미터를 취하는 제네릭 인터페이스를 가짐. 그럼으로써 리스트에 다른 타입의 값이 들어가거나 다른 타입의 값으로 꺼내는 것을 컴파일러가 런타임 타임에 확인해줄 수 있게됨.
- Parameter와 Argument의 차이 [http://ohgyun.com/410](http://ohgyun.com/410)

```java
List<String> ls = new ArrayList<String>();
List<Object> lo = ls; // 컴파일 에러!
```
자바의 모든 클래스는 Object를 서브타입임. 하지만 `List<String>`은 `List<Object>`의 서브타입이 아님.

```
In general, if Foo is a subtype (subclass or subinterface) of Bar, and G is some generic type declaration, it is not the case that G<Foo> is a subtype of G<Bar>. This is probably the hardest thing you need to learn about generics, because it goes against our deeply held intuitions.
```

## 제네릭 메서드
// TODO

## 와일드카드
// TODO

## 더 읽어보기
- [Oracle Java Doc: Generics and Subtyping](https://docs.oracle.com/javase/tutorial/extra/generics/subtype.html)
- [Oracle Java Doc: Wildcards](https://docs.oracle.com/javase/tutorial/extra/generics/wildcards.html)
- [토비의 봄 TV 4회 (1) 자바 Generics](https://youtu.be/ipT2XG1SHtQ)
