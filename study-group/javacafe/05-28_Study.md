# 16-05-28 스터디_Java Stream API

## Collector 를 통한 데이터 수집

> `java.util.stream.collect()`
> `java.util.stream.Collectors`

### 스트림 요소를 하나의 값으로 리듀스 또는 요약

```
// 최대값
static <T> BinaryOperator<T> maxBy(Comparator<? super T> comparator)
```

```
// 최소값
static <T> BinaryOperator<T> minBy(Comparator<? super T> comparator)
```

```
// 카운트, 합, 최대, 최소, 평균 값을 모두 가져옴
public static <T> Collector<T,?,IntSummaryStatistics> summarizingInt(ToIntFunction<? super T> mapper)
```

```
// 문자열 연결
public static Collector<CharSequence,?,String> joining(CharSequence delimiter)
```


### 스트림 요소 그룹화

```
// 조건에 따라 묶은 결과값 생성
public static <T,K> Collector<T,?,Map<K,List<T>>> groupingBy(Function<? super T,? extends K> classifier)
```

```
// 결과값을 재가공
public static <T,A,R,RR> Collector<T,A,RR> collectingAndThen(Collector<T,A,R> downstream, Function<R,RR> finisher)
```

### 스트림 요소 분할

```
public static <T> Collector<T,?,Map<Boolean,List<T>>> partitioningBy(Predicate<? super T> predicate)
```	




