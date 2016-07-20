# DBMS의 AUTO COMMIT 설정

운영되고 있는 서비스의 데이터에 직접 접근하여 수정하는 일은 가능한 없어야 한다. 데이터의 무결성을 해치기 때문이다. 하지만 가끔 부득이 하게 직접적으로 수정해야 할 때가 있다.
이 때, 당연히 데이터를 다 백업하긴 하지만 이미 물을 엎지른 후에 백업본으로 되돌리는 일도 부담스러운 일이다. 조금 알아보니 DMBS 자체적으로 Auto-Commit 을 설정할 수 있었다. 

`MariaDB-10.1.14`  기준이다.

```sql
SELECT @@AUTOCOMMIT;
```

먼저 위의 질의어로 autocommit 의 상태를 확인할 수 있다. `1` = `true`, `0` = `false` 이다.

```sql
set autocommit = 0;

DELETE FROM BACKUP_LOG;

ROLLBACK;
-- 또는
COMMIT;

set autocommit = 1;
```

`set` 으로 `autocommit` 을 false(0)로 설정한 후, 결과를 확인하여 질의어가 원하는대로 수행되었다면 `COMMIT`을, 아니라면 `ROLLBACK`을 하여 되돌린다. 그리고 본인의 작업 후에는 꼭 잊지 않고 해당 데이터베이스의 `autocommit` 설정은 원래대로 되돌린다.

```sql
SELECT IDX, BACKUP_DATE FROM BACKUP_LOG WHERE IDX = 1;

DELETE FROM BACKUP_LOG WHERE IDX = 1;  
```

또한, 평소에 `DELETE` 질의를 바로 작성 하기 보다는 `SELECT` 문으로 삭제하려는 리스트를 먼저 뽑아보고, 그 질의어를 `DELETE`문으로 변경하는 습관을 들이는 것이 좋다. 
