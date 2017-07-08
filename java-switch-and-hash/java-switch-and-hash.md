자바의 switch-case와 해시(Hash)
===

조건 분기를 해야 할 때, 경우에 따라 `if`-`then`-`else` 보다 `switch-case`를 잘 사용하면 훨씬 깔끔한 코드를 작성할 수 있다.

```java
int month = 3;
String monthStr;

switch (month) {
    case 1: monthStr = "Jan";
        break;

    case 2: monthStr = "Fab";
        break;

    case 3: monthStr = "Mar";
        break;

    // .. 중략

    default: monthStr = "Not valid";
        break;
}
```

기존의 자바는 `char`, `byte`, `short`, `int`와 같은 기본형 타입에 대해서만 `switch-case` 사용이 가능했다가 JDK7 이후 버전부터는 `String`형 사용이 가능해졌다.

```java
String day = "NEW";

switch (day) {
    case "NEW":
        System.out.println("Order is in NEW state");
        break;
    case "new":
        System.out.println("Order is in new state");
        break;
    case "WEN":
        System.out.println("Order is in WEN state");
        break;
    default:
        System.out.println("Invalid");
}
```

그냥 그렇게 되었구나 하고 넘어갔었으나, 자료구조 스터디 중 자바의 `switch-case` 동작 방식이 해시테이블 방식으로 되어 있다는 것을 알게 되어 좀 더 호기심을 가지게 되었다.

# 해시 (Hash)

먼저 간단히 해시 테이블에 대해 요약하자면

> 공간아 팔아 속도를 얻는다

이렇게 정리할 수 있다. 데이터가 삽입 되면 > 해시 함수를 거쳐서 키(Key)를 만들고 > 그 키를 인덱스로 하여 배열에 저장한다. 이렇게 삽입을 해두면, 추후 그 값을 탐색할 때도 삽입과 같이 키 값을 만드는 과정만 거치고, 그 키로 해당 위치를 바로 참조 할 수 있다. 리스트였다면 처음부터 순차적으로 탐색해 나가야 했을 것이다. 단,  해시 함수에서 키를 만들때 랜덤하게 만들어지기 때문에, 해시 테이블은 중간 중간 빈 공간이 많고 많은 공간을 차지한다.

해시테이블을 구현하는데 있어 중요한 것은 해시 함수를 거쳐 키를 생성할 때 이 키가 중복되지 않도록 하는 것, 즉 같은 인덱스에 여러 값이 들어가는 충돌을 방지하고 처리하는 것이 과제이다.

# 자바의 switch-case

해시는 이 정도로 요약하고 다시 자바의 `switch-case`를 보자면

```java
// Decompiled .class file, bytecode version: 52.0 (Java 8)

public class SwtichTest {
    public SwtichTest() {
    }

    public void switchTest() {
        String day = "NEW";
        byte var3 = -1;
        switch(day.hashCode()) {
        case 77184:
            if(day.equals("NEW")) {
                var3 = 0;
            }
            break;
        case 85824:
            if(day.equals("WEN")) {
                var3 = 2;
            }
            break;
        case 108960:
            if(day.equals("new")) {
                var3 = 1;
            }
        }

        switch(var3) {
        case 0:
            System.out.println("Order is in NEW state");
            break;
        case 1:
            System.out.println("Order is in new state");
            break;
        case 2:
            System.out.println("Order is in WEN state");
            break;
        default:
            System.out.println("Invalid");
        }

    }
}
```

위의 소스는 `String` 을 이용한 `switch-case`를 디컴파일 한 코드이다. 처음부터 살펴 보자면

1. case 절에 명시했던 조건 문자열들이 이상한 숫자로 바뀌었다. 그리고 switch 문의 인자로 전달했던 문자열(String)으로 `hashCode()` 를 호출 한다.

2. 그리고 각각의 case 절 안에서 다시 한번 `equals()`를 통해 동등성을 비교 한다.

3. 위 두 조건이 모두 만족했을때 var3 라는 `byte`형 변수에 어떤 값을 저장한다.

4. 아래에 switch 문이 하나 더 생겼다. 그리고 이 `switch-case`는 3번 과정에서 값을 대입한 var3 변수를 두번째 switch 문의 인자로 전달한다.

디컴파일 된 코드에서는 `switch-case` 문이 두 개가 되었으니 위를 제1스위치, 아래를 제2스위치로 가정하겠다.

제1스위치는 위에서 간략하게 설명한 해시 테이블 방식을 통해 해당 키 값과 일치하는 case 로 바로 향할 수 있다. 그런데 서로 다른 값이지만 해시함수를 거친 후 동일한 키 값을 가질 수 있는 경우(해시 충돌)가 생길 수 있기 때문에 케이스가 일치하더라도 원래 문자열의 동등성을 비교 하도록 방어적인 코드를 작성한 듯 하다. 어쩌면 방어적이라기 보다는 꼭 필요한 로직이라고 할 수도 있겠다.

또한, `switch-case` 의 case 들을 유심히 보면 일부러 비슷한 문자열로 넣어봤다. NEW 와, 이 문자를 뒤집은 WEN 그리고 소문자. 아스키 코드로 생각해봤을 때, 대문자-소문자는 생성 되는 키 값이 당연히 다를 수 있지만 NEW-WEN 는 똑같은 조합의 문자가 모인 문자열이기 때문에 같은 키를 가질 수 있는 가능성이 있다. 하지만 case 에 대치 된 해시 값을 보면 완전히 다른 값을 가지고 있다. 이와 같이 해시 테이블에서는 키 충돌을 방지 하게 위해 해시를 생성하는 적절한 알고리즘의 구현과(하지만 완벽할 수 없음) 충돌처리가 중요하며 이 방법에는 `분리 된 체인`과 `오픈 주소법 해싱`이라는 방법이 있다.

그렇다면 왜 `String` 형을 `swich-case`의 인수로 전달했을 때, 두 개의 switch 문으로 컴파일 되는 것일까?

[OpenJDK/jdk7u](http://hg.openjdk.java.net/jdk7u/jdk7u/langtools/file/41b81b3e37cd/src/share/classes/com/sun/tools/javac/comp/Lower.java#l3397) 의소스 코드의 주석에 관련 내용이 적혀 있었는데, 내용이 너무 이해하기 어려워 발 번역을 해봤다.


> The general approach used is to translate a single string switch statement into a series of two chained switch statements:
>
> 일반적으로 사용되는 방법은 단일 string switch 문을 두번의 연쇄 switch문으로 번역(컴파일)하는 것 입니다.

> the first a synthesized statement switching on the argument string's hash value and computing a string's position in the list of original case labels, if any, followed by a second switch on the computed integer value.  The second switch has the same code structure as the original string switch statement except that the string case labels are replaced with positional integer constants starting at 0.
>
> 먼저 인수 문자열의 해시 값을 계산하고 원래의 case 라벨들의 문자열 위치를 계산합니다. 만약 적중하는 case가 있다면, 계산 된 정수 값으로 두번째 switch가 시작 됩니다. 두번째 switch 는 string으로 작성 된 case 라벨들이 0부터 시작되는 정수들로 대체 되는 것을 제외하고는 원래의(컴파일 전의) switch문과 같은 코드 구조를  가지고 있습니다.

> The first switch statement can be thought of as an inlined map from strings to their position in the case label list.  An alternate implementation would use an actual Map for this purpose, as done for enum switches.
>
> 첫번째 switch 문은 원래의 swich문의 case 라벨 목록에서의 string 위치를 가르키는 맵으로 생각될 수 있습니다. enum(자바의 열겨거형 상수) switch 를 사용하기 위해 대체 구현하는 것입니다.

> With some additional effort, it would be possible to use a single switch statement on the hash code of the argument, but care would need to be taken to preserve the proper control flow in the presence of hash collisions  and other complications, such as fallthroughs.
>
> 몇 가지 추가적인 노력으로 해시코드 인수를 받는 단일 switch 문으로 사용할 수도 있습니다. 그러나 해시충돌이나 다른 문제들로 인해 완료되지 못하는 것을 방지하기 위해 적절한 제어 흐름이 필요 합니다.

> Switch statements with one or two alternatives could also be specially translated into if-then statements to omit the computation of the hash code.
>
> switch문을 대체할 수 있는 몇 가지가 있습니다.  해시코드 계산을 생략하고 if-then문으로 대체할 수도 있습니다.

발번역한 내용을 바탕으로 보자면 enum switch 로 사용하기 위해 연쇄적인 두번의 switch-case를 사용하는 것인데, 그렇다면 왜 enum switch를 사용해야 할까?


- [JVM Specification - 3.10. Compiling Switches](http://docs.oracle.com/javase/specs/jvms/se7/html/jvms-3.html#jvms-3.10)

JVM 스펙 문서를 보면 JVM에서 switch-case 컴파일에 관련 된 내용이 있는데, 이를 바탕으로 생각해 보면 기존에 구현 된 JVM 의 switch 처리 방식과의 호환을 위해 새롭게 추가 된 String 형의 `switch-case` 도 기존에 기본형만 처리 했던 `switch-case` 방식으로 처리하기 위함 인 듯 하다.

JVM의 `switch-case` 처리 방식에 관한 내용은 이 링크를 참조하면 좋을 듯 하다.
- [Difference between JVM's LookupSwitch and TableSwitch](http://stackoverflow.com/questions/10287700/difference-between-jvms-lookupswitch-and-tableswitch)


## `if-then-else` VS `switch-case`

이건 전적으로 Case By Case 인 것 같다.

```java
if(조건1) {
    // 로직
} else if(조건2) {
    // 로직
} else if(조건3) {
    // 로직
} else if(조건4) {
    // 로직
} else if(조건5) {
    // 로직
} else if(조건6) {
    // 로직
} else if(조건7) {
    // 로직
} else if(조건8) {
    // 로직
} else {
    // 로직
}
```
위와 같은 조건분기가 있고 이 조건분기를 거칠 때 마다 조건8에 해당할 확률이 높다면 매번 거의 마지막 조건부까지 비교 과정을 거쳐야 한다. 반대로 대체로 조건1이나 조건2를 만족할 확률이 높다면 해당 조건 이후의 조건절들은 모두 무시 된다.

`switch-case`의 경우 위에서 설명했듯 해시테이블의 특성상 공간을 많이 낭비하고 대신 속도를 얻는다.

그런데 사실 일반적인 조건 비교에서 두 구문의 성능차가 시스템에 크리티컬하게 영향을 줄 정도로 차이 나지는 않는 듯 하다. 그렇다면 컴퓨터가 좀 더 빨리 이해할 수 있는 코드 보다는 사람이 읽기 좋은 코드로 상황에 맞게 작성하는 것이 좋지 않을까.

두 구문의 정확한 성능차는 아래 글들을 참고하면 좋다.

- [if~else와 switch~case 문의 차이점(성능, 메모리 관점)](http://blog.naver.com/kki2406/80041410085)
- [switch vs if 어떤 때 어느게 효율적인가요?](https://kldp.org/node/62262)

## 참고자료

- [Oracle Java Documentation: The switch Statement](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/switch.html)

- [Why switch on String compiles into two switches](http://stackoverflow.com/questions/25568639/why-switch-on-string-compiles-into-two-switches)

- [OpenJDK/jdk7u](http://hg.openjdk.java.net/jdk7u/jdk7u/langtools/file/41b81b3e37cd/src/share/classes/com/sun/tools/javac/comp/Lower.java#l3397)

- [JVM Specification - 3.10. Compiling Switches](http://docs.oracle.com/javase/specs/jvms/se7/html/jvms-3.html#jvms-3.10)