# 자바에서 문자를 구분자로 분리하기

셀렉트리스트의 하나의 옵션에 여러 값(Value)을 줘야 할 경우 보통 구분자(delimiter)를 넣어두고 그 구분자를 기준으로 하여 하나의 값을 여러 값으로 분리해내는 방식을 사용한다.

```html
<body>
<select id="select_list">
    <option value="APPLE|CARROT|PIZZA">Foods</option>
</select>

<script>
var options = $("#select_list option:selected").val();
var values = options.split("|");

var params  = "?FRUIT=" + values[0]
    params += "&VEGETABLE=" + values[1]
    params += "&INSTANT=" + values[2];

/*
values[0] = "APPLE"
values[1] = "CARROT"
values[2] = "PIZZA"
*/
</script>
</body>
```

주로 클라이언트측에서 특정 조건 값으로 조회(SELECT)를 할 때 위와 같이 view 단에서 자바스크립트를 통해 아예 다 분리를 한 다음 쿼리스트링을 만들어 HTTP GET 요청을 보냈다.

이번에 어쩌다보니 위와 같이 구분자로 구분되는 하나의 문자열을 서버에서 처리하게 되었는데, 자바와 자바스크립트의 split 이 비슷하게 동작하는 것으로 기억하고 구현하였다가 API 문서를 통해 잘못 기억하고 있다는 걸 깨닫고 '내가 자바에서 split 을 이렇게 안써봤나?' 하는 마음에 한번 정리한다.

## java.lang.String.split(String regex)

- [http://docs.oracle.com/javase/8/docs/api/java/lang/String.html#split-java.lang.String-]()

먼저, `java.lang.String` 클래스에 포함되어 있는 split 매소드는 구분자로 받는 매개변수가 `정규식` 이다. (`limit` 도 매개변수로 받도록 오버로딩 된 메소드도 있지만, 이 글의 주 관심사는 아니므로 제외)

```java
@Test
public void splitTest() {
    String text = "APPLE|CARROT|PIZZA";
    String [] array = text.split("|");
    
    assertEquals(3, array.length);
}
/*
Test Failed

java.lang.AssertionError: 
Expected :3
Actual   :18
*/
``` 

위는 자바에서 자바스크립트와 같은 방식으로 split 을 사용하였다가 실패한 테스트이다.
자바스크립트와 같이 동작했다면 배열의 길이는 3이 되어야 했으나, 배열의 길이가 18이다(욕 아님). 지금 `array` 배열에는 `text`를 한글자씩 쪼개서 들어가 있다.

```regex
(fa|mo|(br|b)?o)ther
```

정규식에서 `|` (Vertical Bar)는 OR 로 인식한다고 한다. 위와 같은 정규식 조건이 있다고 할때, father, mother, bother, brother, other 단어 모두 위 조건을 통과할 수 있다.

그런데 그럼 정규식은 정규식이고 왜 한글자씩 쪼개져서 배열에 들어가느냐? 솔직히 이리저리 찾아 봤는데 세로 바(|)가 예약어라는 답변들 밖에는 찾지 못했다. 직접 디버깅 모드로 추적 해봤지만, split 을 수행하기 위해 `Pattern` 클래스 뿐만 아니라 많은 클래스들을 타고 들어가서 명확한 동작 방식을 이해하기가 힘들었다. 여튼 자바에서 `split` 메소드에 매개변수로 넘어가는 문자는 단순 문자가 아니라 정규식 이라는 것과 `split` 하는 것이 굉장히 복잡한 과정을 거친다는 것을 기억해야겠다.

## java.util.StringTokenizer

- [http://docs.oracle.com/javase/8/docs/api/java/util/StringTokenizer.html]()

자바에는 문자를 분리하기 위해 `split` 말고 `StringTokenizer` 라는 클래스도 있다. 스플릿 은 `JDK 1.4` 부터 지원됐고, 토크나이저는 `JDK 1.0` 부터 지원했는데, API 문서를 읽어보면 토크나이저 대신 스플릿을 사용할 것을 권장한다. 하지만 `@deprecated` 된 클래스는 아니다. 

```java
@Test
public void toknizerTest() {
    String text = "APPLE|CARROT|PIZZA";
    StringTokenizer st = new StringTokenizer(text, "|");
    String [] array = new String[3];
    int i = 0;

    while (st.hasMoreTokens()) {
        array[i] = st.nextToken();
        i++;
    }

    assertEquals(3, array.length);
}
```
스플릿과 달리 토크나이저는 문자 그대로를 구분자로 사용하기 때문에 위 코드는 성공하는 테스트이다. 하지만 토크나이저는 클래스이기 때문에 분리하고 하나씩 읽어 들이는 번거로운 과정과 그 코드들이 모두 사용하는 쪽에 드러난다.

## Benchmark

최근에 JMH ([http://openjdk.java.net/projects/code-tools/jmh/]()) 라는 자바 성능측정 툴을 알게 되어 스플릿과 토크나이저 성능비교를 한번 해봤다. 굉장히 약식으로 하였고, 전제조건 등도 제대로 설정하고 돌린 벤치마크가 아니기 때문에 그냥 가볍게 보면 좋겠다.

```java
@Benchmark
public void splitTest() {
    String text = "APPLE|CARROT|PIZZA";
    String [] array = text.split("|");
}

@Benchmark
public void toknizerTest() {
    String text = "APPLE|CARROT|PIZZA";
    StringTokenizer st = new StringTokenizer(text, "|");
    String [] array = new String[3];
    int i = 0;

    while (st.hasMoreTokens()) {
        array[i] = st.nextToken();
        i++;
    }
}

# JMH 1.12 (released 105 days ago, please consider updating!)
# VM version: JDK 1.8.0_73, VM 25.73-b02
# VM invoker: /Library/Java/JavaVirtualMachines/jdk1.8.0_73.jdk/Contents/Home/jre/bin/java
# VM options: -Dfile.encoding=UTF-8
# Warmup: 20 iterations, 1 s each
# Measurement: 20 iterations, 1 s each
# Timeout: 10 min per iteration
# Threads: 1 thread, will synchronize iterations
# Benchmark mode: Throughput, ops/time
# Benchmark: com.test.StringBenchmark.splitTest

Benchmark     Mode  Cnt         Score        Error  Units
splitTest     thrpt  200   1227784.106 ±  10013.248  ops/s
toknizerTest  thrpt  200  12667246.536 ± 171699.957  ops/s
```

## 결론

어찌됐든 자바에서도 토크나이저 클래스 보다는 스플릿 메소드를 사용할 것을 권장하고 있다. 스플릿 메소드는 정규표현식을 통해 정규식 뿐만 아니라 문자를 구분자로도 사용할 수 있지만 토크나이저는 정규표현식을 사용할 수는 없다. 그리고 위에도 적었지만 문자를 구분자로 분리하고 이터레이트(iterate) 하는 과정이 모두 사용하는 쪽에서 코드가 드러나기 때문에 별로인 것 같다.

```java
String [] array = text.split("\\|");

String [] array = text.split((Pattern.quote("|")));
```

스플릿 메소드에서 세로 바(|)로 문자를 분리하기 위해서는 위와 같이 역슬래쉬를 두개 포함하거나, `Pattern` 클래스를 활용하면 되겠다.


## 참고자료
- [http://stackoverflow.com/questions/5675704/java-string-split-not-returning-the-right-values]()
- [http://stackoverflow.com/questions/6983856/why-is-stringtokenizer-deprecated]()
- [http://library1008.tistory.com/16]()
- [자바의 신 Vol 2 주요 API 응용편, 이상민 저](http://book.naver.com/bookdb/book_detail.nhn?bid=7188745)
- 진짜 잘 만든 정규식 슬라이드 강추! [초보자를 위한 정규 표현식 가이드](http://www.slideshare.net/ibare/ss-39274621)