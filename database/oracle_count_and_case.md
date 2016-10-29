# ORACLE 특정 조건의 칼럼 개수 카운트

그래프 작업을 위해 집계 데이터를 만들 필요가 있었다. 원래는 좀 더 복잡한 쿼리이지만 핵심만 추리자면 아래와 같이 특정 계약 년도(CONTRACT_YEARS) 범주에 속하는 가게(Shop)의 수를 집계하는 쿼리이다.

```sql
select sum(case when CONTRACT_YEARS < 3 then 1 else 0 end) as UNDER_3_YEAR
	, sum(case when CONTRACT_YEARS >= 3 and CONTRACT_YEARS < 5 then 1 else 0 end) as UNDER_5_YEAR
    , sum(case when CONTRACT_YEARS >= 5 and CONTRACT_YEARS < 7 then 1 else 0 end) as UNDER_7_YEAR
    , sum(case when CONTRACT_YEARS >= 10 then 1 else 0 end) as OVER_10_YEAR
from SHOP
```

위 예제 쿼리를 보면 `sum` 함수와 함께 `case` 절을 사용했다. 하지만 곰곰히 생각해보니 가게의 수를 세는 것인데 `sum` 보다는 `count` 함수를 사용하는 것이 더 직관적이라 판단되었다.

```sql
select count(case when CONTRACT_YEARS < 3 then 1 else 0 end) as UNDER_3_YEAR
	, count(case when CONTRACT_YEARS >= 3 and CONTRACT_YEARS < 5 then 1 else 0 end) as UNDER_5_YEAR
    , count(case when CONTRACT_YEARS >= 5 and CONTRACT_YEARS < 7 then 1 else 0 end) as UNDER_7_YEAR
    , count(case when CONTRACT_YEARS >= 10 then 1 else 0 end) as OVER_10_YEAR
from SHOP
```

처음 작성한 쿼리에서 그룹함수만 변경한 쿼리이다. 그런데 같은 결과가 나올 것이라 생각했는데 완전히 다른 결과가 나왔다. 이유는 `case` 절에서 `else` 절 때문이다. `case` 절을 보면 조건을 만족할 때 1을 반환하고, 그렇지 않을 때는 0을 반환하도록 하였다. `sum` 함수를 사용할 때는 0을 더해도 무관하지만 `counut` 함수를 사용할 때는, 1이든 0이든 어쨋든 하나의 값이기 때문에 카운트를 해버리는 것이다. 따라서 `count` 와 함께 `case` 절을 사용한다면 아래와 같이 변경되어야 한다.

```sql
select count(case when CONTRACT_YEARS < 3 then 1 end) as UNDER_3_YEAR
	, count(case when CONTRACT_YEARS >= 3 and CONTRACT_YEARS < 5 then 1 end) as UNDER_5_YEAR
    , count(case when CONTRACT_YEARS >= 5 and CONTRACT_YEARS < 7 then 1 end) as UNDER_7_YEAR
    , count(case when CONTRACT_YEARS >= 10 then 1 end) as OVER_10_YEAR
from SHOP
```

