# Transaction Isolation Level

## 트랜잭션의 성질
- A: Atomicity 한 트랜잭션 내 작업들은 하나로 간주한다. 모두 성공 or 모두 실패.
- C: Consistency 일관성 있는 데이터베이스 상태를 유지한다.
- I: Isolation 동시에 실행되는 트랜잭션들이 서로 영향을 미치지 않는다.
- D: Durability 트랜잭션을 성공적으로 마치면 그 결과가 항상 저장되어야 한다.

# Lost Update Problem
트랜잭션이 동시에 실행되는 환경에서 다음과 같은 문제가 발생할 수 있음.

1. Dirty Read Problem
    - 한 트랜잭션에서 변경한 값을 다른 트랜잭션에서 읽을 때 발생.

| Transaction | Action1  | Action2 | Action3  |
| ----------- | -------- | ------- | -------- |
| T1          | Wrtie(a) | -       | Rollback |
| T2          | -        | Read(a) | -        |

2. Non-repeatable Read Problem
    - 한 트랜잭션에서 같은 값을 두 번 읽었을 때 각각 다른 값이 읽히는 경우.

| Transaction | Action1 | Action2         | Action3 | Action4 |
| ----------- | ------- | --------------- | ------- | ------- |
| T1          | Read(a) | -               | -       | Read(a) |
| T2          | -       | Write/Delete(a) | Commit  | -       |

3. Phantom Read Problem
    - 주로 통계나 분석, aggregation funtion 등을 수행하는 쿼리에서 잘 못 된 값이 들어오는 경우.

| Transaction | Action1          | Action2                          | Action3 | Action4          |
| ----------- | ---------------- | -------------------------------- | ------- | ---------------- |
| T1          | Select(criteria) | -                                | -       | Select(criteria) |
| T2          | -                | Update/Create(match to criteria) | Commit  | -                |


# 트랜잭션 격리 수준
| 격리수준         | Problem1 | Problem2 | Problem3 |
| ---------------- | -------- | -------- | -------- |
| Read Uncommitted | Y        | Y        | Y        |
| Read Committed   | N        | Y        | Y        |
| Repeatable Read  | N        | N        | Y        |
| Serializable     | N        | N        | N        |

- 데이터베이스마다 지원하는 수준이 다름.
- MySQL과 MS-SQL은 4가지 모두 지원.
- MySQL의 기본 설정은 `REPEATABLE-READ`

```shell
mysql> show variables like 'tx_isolation';
```

직접 테스트 해보기 위해서는 다음과 같이 설정.
```shell
mysql> set autocommit = false;
mysql> set tx_isolation = ''; -- REPEATABLE-READ / READ-UNCOMMITTED / READ-COMMITTED / SERIALIZABLE
```

## Repeatable Read
- 첫번째 읽기에 스냅샷 생성.
- 이후 동일 트랜잭션에서는 스냅샷에서부터 값을 읽음.
- 잠금 대상은 unique index, secoendary index 유무에 따라 다름.

## Read Committed
- 커밋 된 아이템을 읽음. 커밋되지 않은 값을 읽을 수 없음.
- 같은 트랜잭션에서도 가장 최근의 스냅샷을 읽음.

## Read Uncommitted
- 다른 트랜잭션에서 바꾼 값이 트랜잭션 중간에도 반영됨.
- Read Committed와는 다른 값이 읽힐 수 있다.
- 굉장히 위험함.

## Serializable
- MySQL에서는 모든 SELECT문에 Shared-Lock이 걸린다.
- Repeatable Read에서 Phantom 문제가 발생하지 않으므로 많이 사용하지 않음.
- 역시 굉장히 위험.


# 참고
- [코드스쿼드](http://codesquad.kr) 정호영님의 사내 강의
