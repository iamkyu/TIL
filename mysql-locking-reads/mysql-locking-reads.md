# MySQL Locking Reads

다음과 같은 테이블이 있다고 가정한다.

```mysql
CREATE TABLE t (
	id int AUTO_INCREMENT PRIMARY KEY,
	data int
);

INSERT INTO t (data) 
VALUES (1), (2), (3), (4);
```

그리고 두 세션에서 아래 표의 위에서 아래 순서로 쿼리가 실행된다고 해보자.

| Session A                                                    | Session B                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| SELECT * FROM t <br />WHERE id = 1;<br />——— 1. row ———<br />id: 1<br />data: 1 |                                                              |
|                                                              | SELECT * FROM t <br />WHERE id = 1;<br />——— 1. row ———<br />id: 1<br />data: 1 |
| UPDATE t <br />set data = (data + 1)<br /> WHERE id = 1;     |                                                              |
|                                                              | UPDATE t <br />set data = (data + 1)<br /> WHERE id = 1;     |

Session B의 SELECT 시점에 data는 1이다. 따라서 data+1 UPDATE를 실행한 후 2가 되길 한다. 하지만 Session A 에서 먼저 Update가 수행됐기 때문에 결과가 3이 된다.

또 다른 예, 애플리케이션에서 스레드A와 스레드B가 SELECT를 하고 그 결과를 변수에 담는다고 치자. 변수의 값을 참조해서 +1을 하는 UPDATE 쿼리를 실행한다면 두 쿼리가 모두 실행 되어 3 이 되길 기대하지만 2 가 될 것이다.

------

이 문제를 해결하기 위해 고려했던 방법은

1. 선점 잠금<sup>pessimistic locking</sup>
2. 비선점 잠금<sup>optimistic locking</sup>

선점과 비선점 잠금에서는 최범균님의 DDD-START를 읽으면서 한번 [정리](https://github.com/iamkyu/TIL/blob/master/books/summary/ddd-start.md#8-%EC%95%A0%EA%B7%B8%EB%A6%AC%EA%B1%B0%ED%8A%B8-%ED%8A%B8%EB%9E%9C%EC%9E%AD%EC%85%98-%EA%B4%80%EB%A6%AC)했었는데, [마틴 파울러의 PoEAA](http://book.naver.com/bookdb/book_detail.nhn?bid=9699564) 16장에서 비선점 잠금을 위해 Version 필드를 추가하는 방법 말고 UPDATE 문의 WHERE 절에 모든 필드를 포함하는 방법을 소개한다.

또 한가지 고려한 방법은 아예 SELECT를 하지 않는 것이다. 바로 UPDATE 문을 실행한다면 애초에 Session B에서 질의 수행 결과를 2로 기대하지 않았을 것이다.



> 올바른 잠금 유형을 선택할 때 고려할 사항은 시스템의 동시성 극대화, 비즈니스 요건 충족, 그리고 코드의 복잡성 최소화다. 또한 도메인 모델러와 분석가가 잠금 전략을 이해할 수 있어야 한다는 점도 염두에 둬야 한다. 잠금은 단순히 기술적인 문제가 아니다. 
>
> -마틴파울러 저, PoEAA, 최민석 역, 위키북스, 2015



내가 겪은 문제는 위 예시 중 후자 쪽인데, 조금 성격이 달랐다. 같은 테이블의 특정 필드에 대해 애플리케이션의 A로직과 B로직이 각각의 스레드에서 거의 동시에 실행 되는데 모든 필드를 Bulk 업데이트 하면서 먼저 수행 된 UPDATE 결과는 전부 무시되고 나중에 수행 된 UPDATE 결과만 반영되는 상황이었다. 하지만 곰곰히 생각해보니 애초에 각각의 로직에서 한 필드에 대해 값을 갱신하는 행위가 불 필요하다는 결론이 내려졌고, 관심사를 분리하고 한 필드에 대해 양쪽에서 UPDATE를 하지 않아도 되었다. 하지만 내가 맨 처음 해결책으로 고려했던 것은 잠금 읽기를 통한 선점 잠금 방법이다. PoEAA에서 인용한 글을 바탕으로 생각해보면

- 시스템의 동시성 제한
- 코드의 복잡성 증가

이 두가지를 유발할 수 있는 방법이었다. 어쨌든 이런 결론과 별개로 잠금 읽기에 대한 이해가 부족해서 몇 가지 사소한 테스트 결과를 기록한다.



## 테스트 환경

```mysql
mysql> show variables like 'tx_isolation'\G;

*************************** 1. row ***************************
Variable_name: tx_isolation
        Value: REPEATABLE-READ
```

```mysql
mysql> show version()\G;

*************************** 1. row ***************************
version(): 5.7.19
```

```mysql
mysql> SET AUTOCOMMIT = FALSE;
```

트랜잭션의 격리 수준은 MySQL의 기본인 REPEATABLE-READ 이고 버전은 5.7.19, 트랜잭션 격리 수준에 대해서는 [여기](https://github.com/iamkyu/TIL/blob/master/transaction-isolation-level/transaction-isolation-level.md)에 간략히 정리했었다.

잠금에 대한 대기 시간 설정은 다음 질의로 확인할 수 있다.
```mysql
mysql> SELECT @@innodb_lock_wait_timeout;
```

## Locking Reads

> If you query data and then insert or update related data within the same transaction, the regular `SELECT` statement does not give enough protection. Other transactions can update or delete the same rows you just queried. `InnoDB` supports two types of [locking reads](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_locking_read) that offer extra safety. 

MySQL 메뉴얼의 [14.5.2.4 Locking Reads](https://dev.mysql.com/doc/refman/5.7/en/innodb-locking-reads.html) 절의 도입부를 보면 SELECT를 한 후 컬럼의 값을 가공해 다시 업데이트 하고자 하는 사이 다른 트랜잭션에서 SELECT 한 행에 변경을 가할 수 있기 때문에 안전하지 않다고 한다. 따라서 InnoDB는 두 가지의 유형의 특별한 [잠금 읽기](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_locking_read)<sup>locking read</sup>를 지원하는데 바로  `SELECT ... LOCK IN SHARE MODE` 와 `SELECT ... FOR UPDATE` 이다.



### SELECT ... LOCK IN SHARE MODE

| Session A                                                    | Session B                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| BEGIN;                                                       |                                                              |
| SELECT * FROM t <br />WHERE id = 1 <br />LOCK IN SHARE MODE;<br />——— Query OK ——— | BEGIN;                                                       |
|                                                              | SELECT * FROM t <br />WHERE id = 1 <br />LOCK IN SHARE MODE;<br />——— Query OK ——— |
|                                                              | UPDATE t set data = (data + 1) WHERE id = 1;<br />——— Waiting ——— |
|                                                              | ERROR 1205 (HY000): <br />Lock wait timeout exceeded; <br />try restarting transaction |

> 두 세션에서 같은 행에 대해 `LOCK IN SHARE MODE` 로 읽기는 성공하지만 나중에 실행 된 트랜잭션에서 쓰기 잠금.



| Session A                                                    | Session B                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| BEGIN;                                                       |                                                              |
| SELECT * FROM t <br />WHERE id = 1 <br />LOCK IN SHARE MODE;<br />——— Query OK ——— | BEGIN;                                                       |
|                                                              | SELECT * FROM t <br />WHERE id = 1 <br />LOCK IN SHARE MODE;<br />——— Query OK ——— |
| UPDATE t set data = (data + 1) WHERE id = 1;<br />——— Waiting ——— |                                                              |
| ERROR 1205 (HY000): <br />Lock wait timeout exceeded; <br />try restarting transaction |                                                              |

> 두 세션에서 같은 행에 대해 `LOCK IN SHARE MODE` 로 읽기는 성공하지만 먼저 실행 된 트랜잭션임에도 불구하고 쓰기 잠금.



| Session A                                                    | Session B                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| BEGIN;                                                       |                                                              |
| SELECT * FROM t <br />WHERE id = 1 <br />LOCK IN SHARE MODE; | BEGIN;                                                       |
|                                                              | SELECT * FROM t <br />WHERE id = 1 <br />FOR UPDATE;<br />——— Waiting ——— |
|                                                              | ERROR 1205 (HY000): <br />Lock wait timeout exceeded; <br />try restarting transaction |

> 한 세션에서 `LOCK IN SHARE MODE` 읽기 중인 행에 대해 `FOR UPDATE` 로 읽기 잠금.





### SELECT ... FOR UPDATE

| Session A                                            | Session B                                                    |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| BEGIN;                                               |                                                              |
| SELECT * FROM t <br />WHERE id = 1 <br />FOR UPDATE; | BEGIN;                                                       |
|                                                      | SELECT * FROM t <br />WHERE id = 1 <br />FOR UPDATE;<br />——— Waiting ——— |
|                                                      | ERROR 1205 (HY000): <br />Lock wait timeout exceeded; <br />try restarting transaction |

> 한 세션에서 `FOR UPDATE ` 읽기 중인 행에 대해 `FOR UPDATE` 로 읽기 잠금.



| Session A                                            | Session B                                                 |
| ---------------------------------------------------- | --------------------------------------------------------- |
| BEGIN;                                               |                                                           |
| SELECT * FROM t <br />WHERE id = 1 <br />FOR UPDATE; | BEGIN;                                                    |
|                                                      | SELECT * FROM t <br />WHERE id = 1 <br />——— Query OK ——— |

> 한 세션에서 `FOR UPDATE ` 읽기 중인 행에 대해 `SELECT` 로 읽기 성공함.



| Session A                                            | Session B                                                    |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| BEGIN;                                               |                                                              |
| SELECT * FROM t <br />WHERE id = 1 <br />FOR UPDATE; |                                                              |
|                                                      | SELECT * FROM t <br />WHERE id = 1 <br />LOCK IN SHARE MODE;<br />——— Waiting ——— |
|                                                      | ERROR 1205 (HY000): <br />Lock wait timeout exceeded; <br />try restarting transaction |

> 한 세션에서 `FOR UPDATE ` 읽기 중인 행에 대해 `LOCK IN SHARE MODE` 로 읽기 잠금.



## 정리

`SELECT ... LOCK IN SHARE MODE` 와 `SELECT ... FOR UPDATE` 의 같은 점은 읽고 있는 행에 대해서 쓰기를 잠금다는 것이다. 다만 읽기에 대한 잠금 방식이 조금 다른데

- `LOCK IN SHARE MODE` 는 같은 잠금 읽기 허용함. (`FOR UPDATE` 는 안됨)
- `FOR UPDATE` 는 어떠한 잠금 읽기도 허용하지 않음.

둘 다 순수한 읽기(`SELECT`) 작업은 잠금 여부와 무관하게 바로 실행 된다. 관련해서는 Consistent Nonlocking Reads 에 대해 읽어보면 좋을 듯.

`FOR UPDATE` 는 사용할 경우가 종종 있기도 할 것 같은데 `LOCK IN SHARE MODE` 사용하게 될 사례에 대해서는 떠오르지가 않는다.



## 참고

- [MySQL 5.7 Reference Manual: 14.5.2.3 Consistent Nonlocking Reads](https://dev.mysql.com/doc/refman/5.7/en/innodb-consistent-read.html)
- [MySQL 5.7 Reference Manual: 14.5.2.4 Locking Reads](https://dev.mysql.com/doc/refman/5.7/en/innodb-locking-reads.html)
- [Real MySQL, 이성욱, 위키북스, 2012](http://book.naver.com/bookdb/book_detail.nhn?bid=6886962)
  - 3.2.7 잠금 없는 일관된 읽기 (Non-locking consistent read)
  - 7.4.11 LOCK IN SHARE MODE와 FOR UPDATE
  - 12.2.1 SELECT 쿼리의 잠금
- [엔터프라이즈 애플리케이션 아키텍처 패턴, 마틴 파울러, 최민석 역, 위키북스, 2015 - 16장: 오프라인 동시성 패턴 ](http://book.naver.com/bookdb/book_detail.nhn?bid=9699564) 
