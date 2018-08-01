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
- (TODO 정리) 람다와 익명클래스 직렬화 관련



## Item 43. 람다 대신 메서드 레퍼런스를 사용하라

```java
// 람다 표현식
map.merge(key, 1, (count, incr) -> count + incr);

// 메서드 레퍼런스
map.merge(key, 1, Integer::sum);
```

[자바 8 인 액션](https://book.naver.com/bookdb/book_detail.nhn?bid=8883567) 에서는 메서드 레퍼런스를 "특정 메서드만을 호출하는 람다의 축약형"이라고 설명. 람다가 너무 길거나 복잡해지면 람다 코드를 새 메서드로 추출하여 의도를 드러내는 이름을 지정하고 그 메서드에 대한 참조로 바꿀 수 있음. 

하지만 때로는 람다가 메서드 레퍼런스보다 간결할 때도 있으며 이럴 때는 람다를 사용하는 것이 나음.

```java
// 메서드가 같은 클래스에 있을 때 오히려 코드가 더 장황해짐.
service.execute(GoshThisClassNameIsHumongous::action);

// 이럴때는 람다가 더 간결함.
service.execute(() -> action());
```

대부분의 메서드 레퍼런스는 정적 메서드를 참조 하지만 다른 타입도 몇 가지 있음.

| Method Ref Type   | Example                | Lambda Equivalent                                  | etc                                            |
| ----------------- | ---------------------- | -------------------------------------------------- | ---------------------------------------------- |
| Static            | Integer::parseInt      | str -> Integer.parseInt(str)                       | 정적 메서드를 참조                             |
| Bound             | Instant.now()::isAfter | Instant then = Instant.now(); t -> then.isAfter(t) | 람다 외부에 이미 존재하는 객체의 메서드를 참조 |
| Unbound           | String::toLowerCase    | str -> str.toLowerCase()                           | 람다의 매개변수로 전달 될 객체의 메서드 참조   |
| Class Constructor | TreeMap<K,V>::new      | () -> new TreeMap<K,V>                             | 생성자 레퍼런스                                |
| Array Constructor | int[]::new             | len -> new int[len]                                | 생성자 레퍼런스                                |



## Item 45. 스트림을 적절하게 사용하라

```java
public class Anagrams {
    // 자바 8 이전에 작성 된 코드
    public static void beforeJava8(String[] args) throws IOException {
        File dictionary = new File(args[0]);
        int minGroupSize = Integer.parseInt(args[1]);
        Map<String, Set<String>> groups = new HashMap<>();
        try (Scanner s = new Scanner(dictionary)) {
            while (s.hasNext()) {
                String word = s.next();
                groups.computeIfAbsent(alphabetize(word),
                        (unused) -> new TreeSet<>()).add(word);
            }
        }

        for (Set<String> group : groups.values()) {
            if (group.size() >= minGroupSize) {
                System.out.println(group.size() + ": " + group);
            }
        }
    }
    
    // 자바 8 이후에 위 코드가 모두 스트림 코드로 대치 됨. 더욱 읽기 어려워짐.
    public static void onlyStreamUsed(String[] args) throws IOException {
        Path dictionary = Paths.get(args[0]);
        int minGroupSize = Integer.parseInt(args[1]);

        try (Stream<String> words = Files.lines(dictionary)) {
            words.collect(groupingBy(word -> word.chars().sorted()
                    .collect(StringBuilder::new, 
                            (sb, c) -> sb.append((char) c), 
                            StringBuilder::append).toString()))
                    .values().stream()
                    .filter(group -> group.size() >= minGroupSize)
                    .map(group -> group.size() + ": " + group)
                    .forEach(System.out::println);
        }
    }
    
    // 위 두 코드의 중간 타협점
    public static void happyMedium(String[] args) throws IOException {
        Path dictionary = Paths.get(args[0]);
        int minGroupSize = Integer.parseInt(args[1]);

        try (Stream<String> words = Files.lines(dictionary)) {
            words.collect(groupingBy(word -> alphabetize(word)))
                    .values().stream()
                    .filter(group -> group.size() >= minGroupSize)
                    .forEach(group -> System.out.println(group.size() + ": " + group));
        }
    }

    private static String alphabetize(String s) {
        char[] a = s.toCharArray();
        Arrays.sort(a);
        return new String(a);
    }
}
```

남용 된 스트림은 코드를 읽고 유지보수 하기 어렵게 만듬.

- 람다에서는 파라미터의 타입이 생략되기 때문에 파라미터의 이름을 명확하게 지을 것.
- 헬퍼 메서드에 명시적인 이름을 붙여 사용할 것.



스트림을 사용하기 적절한 상황.

- 연속 된 요소를 모두 동일하게 변환
- 연속 된 요소에서 필터링 수행
- 단일 연산을 통한 연속 된 요소의 결합 (예: 추가, 연결, 최소값 계산 등)
- 컬렉션의 연속 된 요소를 특정 기준으로 그룹핑
- 특정 기준을 만족하는 요소 검색



스트림 파이프 라인에서는 함수 객체가 사용되는데 함수 객체에서 다음과 같은 일은 할 수 없음.

- 지역 변수의 변경
- return, break, continue or throw any checked exception


## Item 46. 스트림에서 부수 효과로부터 자유로운 함수를 사용하라
> 부수 효과로부터 자유로운 함수<sup>side-effect-free function</sup>: 순수한 함수<sup>pure function</sup>, 즉 함수의 실행이 외부에 영향을 끼치지 않는 함수를 의미. 스레드에 안전하고 병렬적인 계산이 가능 - [위키피디아: 함수형 프로그래밍](https://ko.wikipedia.org/wiki/%ED%95%A8%EC%88%98%ED%98%95_%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D#%EC%88%9C%EC%88%98%ED%95%9C_%ED%95%A8%EC%88%98)

스트림은 단순한 API가 아니라 함수형 프로그래밍을 기반한 패러다임임. 스트림을 올바르게 사용하기 위해서는 패러다임을 이해해야 함. 스트림 패러다임의 가장 중요한 부분은 각 단계에서는 직전 단계의 결과의 순수 함수의 연속으로 계산을 구성한다는 것.
- 순수함수의 결과는 입력에만 의존 함
- 순수함수는 변할 수 있는 상태에 의존하지 않음
- 순수함수는 상태를 변경하지 않음

```java
Map<String, Long> freq = new HashMap<>();
try (Stream<String> words = new Scanner(file).tokens()) {
    // 어설픈 stream 사용
    words.forEach(word -> 
            freq.merge(word.toLowerCase(), 1L, Long::sum));

    // 위 코드를 for 문으로 표현
    for (String word : words) {
        freq.merge(word.toLowerCase(), 1L, Long::sum);
    }
}
```

> `.tokens()` 는 자바 9에 추가 된 API - 참고 [JDK9 API Doc](https://docs.oracle.com/javase/9/docs/api/java/util/Scanner.html#tokens--)

위 코드의 문제
- freq 라는 외부의 값을 변경 시킴
- 스트림 API로 부터 아무 이점도 얻지 못함
- 단순 for 문 코드 보다 더 길고 읽기 어려워짐

```java
// 개선 된 코드
Map<String, Long> freq;
try (Stream<String> words = new Scanner(file).tokens()) {
    freq = words.collect(groupingBy(String::toLowerCase, counting()));
}
```

`forEach` 는 자바 프로그래머에게 가장 익숙한 형태. 하지만!
- 덜 효과적이고 스트림 친화적이지 않은 것 중 하나임. 
- `forEach` 는 명시적으로 반복적이기 때문에 병렬화가 가능하지 않음.

`forEach` 는 스트림 연산의 결과를 정리<sup>report</sup>하는데에만 사용하거나 스트림 연산의 결과를 기존 컬렉션에 추가할 때와 같은 상황에서 사용하는 것이 좋음.

스트림을 올바르게 사용하려면 Collectors API에 대해 알아야 함.
(TODO)


