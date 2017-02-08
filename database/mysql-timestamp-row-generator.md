# MYSQL에서 시간대별(Interval) 통계 구하기

1일 동안(00:00:00 ~23:59:59)의 시간을 대상으로, 특정 간격 (1분, 10분, 30분 등)으로 통계 데이터를 뽑으려고 한다. 모든 시간대를 빠짐 없이 나타내고 데이터가 없는 것은 0으로 나타내야 한다.



![](https://lh3.googleusercontent.com/6h5GYT8Bb4BnNk7nVRZLKKUUQXejWUMu3VElrwyz5kmCgCAt7jbLoIidlBGqCJdDjP7ATDKYIrGATYJ-Y-ztIiPXJDkp_LfeN80-ane8M-55wYYH6uSdTwISjJL5N_4wcjP8b6KIlSLx_MHrunZ_movt4CKH9ZlajaPNZXq9QYfkm7u5vv_7o4CqlpVp1YdIpzsuKPrlbV225ivbnC7IE3LZwZXwPsrIQ2fHHdJIzv6QXFWZArlsAhjLUOgyEaQ6yeY4eD3lPnuLFHiDe8RzKmxCi09fMa1VLpEIJ-iQXgRhUQevaEzBfgYmfuoBzCPQ0pna5v-FQ0ZU-qGxKbsswCzGBwheNJykI3etppWR5TUTQAm0S2ANg9SCqWFBoNiEwOqO_URlOsrHtMZJRn-Bi41VyS_f48YZLYynBrAwOctZQth7yU-IPjWtnFZv8YlD6LlrpEBU11FR9rG9zR2qZVCx70Z8wY_XTtNpTw888HB-Wd6KCeOn64vRitADHHG0A6YG5Udd9RyWRJdpuKYQQbhP5-4l9PaRTLzG9ijP0B9tYVWRS6hATKOafY3KjSHl109U7jSXryaZhwjBzhkNS8W_D4UqELW8eZswTlp4Z7bl-zMyDM0D=w1892-h228-no)

> Apache Zeppelin 에서 시간대별 통계 질의를 그래프로 나타낸 모습



PostgreSQL에서는 `generate_series()`라는 함수를 응용하여 아래와 같이 질의를 작성할 수 있다.
```sql
SELECT
  dt::TIME "TIME",
  (SELECT count(*) FROM order WHERE order_date BETWEEN dt AND dt + INTERVAL '10' MINUTE) order_count
FROM generate_series('2017-01-25 00:00'::timestamp, '2017-01-25 23:59', '10 minutes') dt;
```



하지만 MySQL에서는  비슷한 함수가 존재하지 않기 때문에, 다른 방법을 찾아야 했다. 내가 참고한 한가지 방법은 타임스탬프를 위한 테이블을 별도로 정의하고, 그 테이블에 분 단위로 행(Row)에 저장하고 조인 하는 것이다.



```sql
CREATE TABLE ints (
  i TINYINT
);
INSERT INTO ints VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

CREATE TABLE timestamp_table (
  t TIME NOT NULL PRIMARY KEY
);

INSERT INTO timestamp_table (t)
  SELECT DISTINCT
    time('00:00:00') + INTERVAL a.i * 10000 + b.i * 1000 + c.i * 100 + d.i * 10 + e.i MINUTE
  FROM ints a
    JOIN ints b
    JOIN ints c
    JOIN ints d
    JOIN ints e
  WHERE (a.i * 10000 + b.i * 1000 + c.i * 100 + d.i * 10 + e.i) <= 1439
  ORDER BY 1;
```


위 쿼리를 수행하면 timestamp_table 테이블에 00:00:00 부터  23:59:00 까지 총 1439의 행을 가진 타임스탬프 테이블이 정의된다. 이제 이 테이블과 조인하여 아래와 같은 통계 질의를 작성할 수 있다.



```sql
SELECT
  ts time,
  sum(IFNULL(today.order_count, 0)) today_order_count
FROM
  (
    SELECT t ts
    FROM timestamp_table
  ) times
  LEFT OUTER JOIN
  (
    SELECT time(from_unixtime(order_date - order_date % 60)) rd, -- 1분 단위로 카운트
           count(*) order_count
    FROM order
    WHERE order_date BETWEEN unix_timestamp(timestamp(date(now()), '00:00:00')) and unix_timestamp(timestamp(date(now()), '23:59:59'))
    GROUP BY rd
  ) today
  ON (times.ts = today.rd)
GROUP BY unix_timestamp(timestamp(date(now()), time)) DIV 300
```


타임스탬프 테이블은 00:00:00 ~ 23:59:00 까지의 1분 단위의 행이 모두 저장되어 있고, 주문을 조회하는 테이블에서도 1분 단위로 카운트`count(*)`를 한다. 하지만 해당 인터벌(Intervel)에 카운트가 존재하지 없으면 그 시간이 누락 되어 버리기 때문에, 타임스탬프 테이블을 기준으로 LEFT OUTER JOIN을 한다.
GROUP BY 절에서는 `DIV` 를 통해 최종적으로 몇 분 간격의 카운트 합을 보여줄 지 결정 할 수 있다. 60은 1분이므로, DIV 300 으로 GROUP BY를 하면 5분 간격으로 카운트 합을 나타낸다.



## 참고
- http://use-the-index-luke.com/blog/2011-07-30/mysql-row-generator
- http://www.brianshowalter.com/calendar_tables