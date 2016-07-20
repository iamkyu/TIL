사내 테스트 서버에 `MS-SQL` DBMS가 구축 되어 있었는데, 요 며칠 서버에 장애가 생겨 테스트를 위해 로컬에 별도 구축이 필요했다. `Oracle`, `My-SQL` 그리고 `MariaDB` 정도는 사용해봤지만, `MS-SQL`과 마이크로 소프트에서 제공하는 클라이언트 툴인 `SQL Server management Studio`는 처음이라 조금 헤맸다.


#### 외부 접근을 위한 기본 설정
- [새 로그인 사용자 추가](http://rorolena.tistory.com/entry/MSSQL-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%B6%94%EA%B0%80)
- [TCP/IP 설정변경](http://sinun.tistory.com/41)


#### 오류/예외 메세지
위 두가지 설정을 했음에도 불구하고
```
사용자 'sa'이(가) 로그인하지 못했습니다.
```
라는 메세지가 나타나며 JDBC 연결이나 외부 DBMS 클라이언트 툴에서 접근이 거부되었다.

#### 해결방법
```
서버 인증 모드가 'SQL Server 및 Windows 인증 모드'로 설정되어 있는지 확인한다.
```
최초 DBMS 설치시 윈도우 인증 모드만 사용하도록 설정하여 새 사용자를 추가했음에도 불구하고 그 사용자로는 인증 받지 못하고, 윈도우 인증만으로 DBMS에서 접근할 수 있었다.


#### MS-SQL 수동으로 끄고/켜기
전에 [데이터베이스 수동으로 끄고/켜기](http://onoctober.tistory.com/52) 글을 쓴 적 있는데, 지금은 사양 좋은 컴퓨터를 사용하긴 하지만 그래도 사용하지 않을 때는 꺼놓는게 마음이 편하다. 이전에 올린 글을 참고하여 아래와 같이 배치 파일을 만들면 된다.
```
net start mssqlserver
```

```
net stop mssqlserver
```

#### 덧+

- [네이버D2: 주요 DBMS의 특징적인 SQL 기능 비교](http://d2.naver.com/helloworld/907716)

약 2년 전에 작성 된 글이라 각각의 DBMS가 버전업되며 차이가 있을 수 있지만 여러 종류의 DMBS 차이를 한눈에 개괄하기 괜찮은 글인 것 같아 링크한다.