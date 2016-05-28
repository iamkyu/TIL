# 05-07 스터디모임: 자바8 Stream API

## 지난 시간 복습
### 자바8 람다 예

```
new Thread(() -> System.out.println("Hello, World!"));
```

### 함수형 인터페이스

- 하나의 추상 메서드를 가진 인터페이스만 람다로 사용 가능 (함수형 인터페이스)
- 인터페이스 내부 유일한 메서드에 람다의 몸체 정의
- `@FunctionalInterface` 어노테이션으로 함수형 인터페이스임을 명시

### 디폴트 메서드
default 키워드를 사용하면 인터페이스에 메소드를 바로 구현(설정) 가능.

```
default void sort(Comparator<? super E>c) {
	//...
}
```

### 메서드 레퍼런스
```
(apple) -> apple.getWeight();

// 위의 표현을 아래와 같이 대체 가능.

Apple::getWeight;
```



## 스트림 API

**요구사항의 예**

- 칼로리가 400 이상인 음식을 선별
- 칼로리를 내림차순으로 정렬
- 상위 칼로리 음식 3개만을 출력

```
	@Test
	public void testStream() {
		Dish.menu.stream()
					.filter(dish -> dish.getCalories() >= 400)
					.sorted(Comparator.comparing(Dish::getCalories))
					.limit(3)
					.forEach(d -> System.out.println(d.getName()));
	}
```

자바 8 이전의 경우 리스트를 새로 생성하고, 옮겨 담고, 정렬하는 과정 등을 거치거나 SQL을 통해 해야 함. 자바 8 이전 대비 코드가 1/4 수준으로 단축.

### 스트림 API 특성: 선언형 프로그래밍
명령형 프로그래밍은 `How` 에 집중, 선언형 프로그래밍은 `What` 에 집중

참고자료: [함수형 프로그래밍과 명령형 프로그래밍 비교 - 마이크로소프트] (https://msdn.microsoft.com/ko-kr/library/bb669144.aspx)

> 선언형 프로그래밍
> 
> - 구체적인 작동 순서에 관심을 가지지 않고 알고리즘 구현에만 집중 가능
> - 이미 구현된 것을 사용. 빠르다.
 
#### 스트림 vs 콜렉션

**컬렉션**

- 자료 구조이므로 데이터의 저장이 주요 관심사
- 데이터에 접근하는 방법을 직접 작성

**콜렉션**

- 계산식을 표현하는 것이 주요 관심
- 데이터에 접근하는 방법이 추상화 되어 있음

## Optional
값이 있거나 없는 경우를 표현하기 위한 클래스

```
public class Computer {
  private Optional<Soundcard> soundcard;  
  public Optional<Soundcard> getSoundcard() { ... }
  ...
}

public class Soundcard {
  private Optional<USB> usb;
  public Optional<USB> getUSB() { ... }

}

public class USB{
  public String getVersion(){ ... }
}
```
참고자료: 
[Tired of Null Pointer Exceptions? Consider Using Java SE 8's Optional!] (http://www.oracle.com/technetwork/articles/java/java8-optional-2175753.html)
