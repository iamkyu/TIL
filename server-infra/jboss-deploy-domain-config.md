#### JBOSS - 도메인 분리를 통한 애플리케이션 배포
- - -


> [싱글 서버에서 둘 이상의 애플리케이션 서비스-1](http://onoctober.tistory.com/90)

이전 글에서 포트 분리를 통해 싱글 서버에서 여러 개의 애플리케이션을 배포하는 방법을 블로깅 했었다. 이번에는 도메인 네임 분리를 통한 방법이다.

<br>
##### AS 7.2 standalone 모드 에서 도메인 분리를 통한 두개 이상의 애플리케이션 배포

`$JBOSS_HOME/standalone/configuration/standalone.xml` 을 수정. <br>*(+ 표시가 추가한 내용. 실제로 포함하지 않는다.)*

- 웹 서브시스템 아래 버추얼 호스트 부분

```
<subsystem xmlns="urn:jboss:domain:web:1.4" default-virtual-server="default-host" native="false">
(중략)
+ <virtual-server name="appserver1" enable-welcome-root="false" default-web-module="app1.war">
+    <alias name="ts1.server.org"/>
+ </virtual-server>
+ <virtual-server name="appserver2" enable-welcome-root="false" default-web-module="app2.war">
+    <alias name="ts2.server.org"/>
+ </virtual-server>
```

- - -
<br>

- 각 애플리케이션에서의 설정

`/WEB-INF/jboss-web.xml`을 생성하고 각 애플리케이션에 맞게 context-root명을 지정한다.

```
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
   <context-root>/app1</context-root>
   <virtual-host>appserver1</virtual-host>
</jboss-web>
```
그런데 JBoss 서버측 설정에서는  `virtual-server` 라는 용어를 사용하는데 애플리케이션 측 설정에서는 `virtual-host` 라는 용어를 사용하는 것이 조금 이해가 가지 않는다.


- - -
<br>
- 추가로 확인할 것들
 
나는 가상 머신 위 리눅스의 localhost 환경에서 테스트 하기 위해 hosts 파일도 수정 해 주었다.
`[root@localhost]# vim /etc/hosts`

```
+ 10.0.2.15 ts1.server.org ts2.server.org
```
