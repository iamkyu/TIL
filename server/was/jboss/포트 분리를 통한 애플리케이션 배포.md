#### JBOSS - 포트 분리를 통한 애플리케이션 배포
- - -
Virtual-Server를 이용하여 싱글 서버에서 여러 개의 애플리케이션을 운영할 수 있다. 그리고 이 Virtual-Server의 설정 방법도 여러가지가 있다. 아파치에서는 Virtual-Host라고 부르는 이 방법은 일반적으로 `웹서버`와 `WAS서버` 연동시 웹서버의 가상호스트 기능을 사용하여 설정하는 경우가 많다고 한다. 
또한, 가상호스트 방법 중에서도 IP 주소를 다르게 하는 것은 현재 IP 주소들이 거의 포화 상태라 별로 추천하지 않고 포트 번호를 다르게 하는 것도 보안 등의 문제로 별로 선호 하는 방법은 아닌 듯 하다. 구축 환경에 따라 다르겠지만 일반적으로 네임서버를 이용한 가상호스트 설정이 가장 많이 사용된다.

> - Name-based Virtual Host
> - IP-based Virtual Host
>	- IP Address를 다르게 설정
>	- Port를 다르게 설정

근데 어찌됐든 나는 JBoss에서 가상서버에서 Port를 다르게 설정해봤다.
JBoss AS6 이전 버전대와 AS7 이후 버전대의 설정 방식이 크게 달라졌다. 아래 사이트에서 이전, 이후의 방법이 잘 설명되어 있다.

> [How to run different apps on single JBoss AS 6 instance behind different ports?](http://stackoverflow.com/questions/22850228/how-to-run-different-apps-on-single-jboss-as-6-instance-behind-different-ports)

<br>
##### AS 7.2 standalone 모드 에서 포트 분리를 통한 두개 이상의 애플리케이션 배포

`$JBOSS_HOME/standalone/configuration/standalone.xml` 을 수정. <br>*(+ 표시가 추가한 내용. 실제로 포함하지 않는다.)*

- 웹 서브시스템 부분

```
<subsystem xmlns="urn:jboss:domain:web:1.4" default-virtual-server="default-host" native="false">
	<connector name="http" protocol="HTTP/1.1" scheme="http" socket-binding="http"/>
+   <connector name="http1" protocol="HTTP/1.1" scheme="http" socket-binding="http1"/>
+   <connector name="http2" protocol="HTTP/1.1" scheme="http" socket-binding="http2"/>
```

- 웹 서브시스템 아래 버추얼 호스트 부분

```
<virtual-server name="default-host" enable-welcome-root="false">
    <alias name="localhost"/>
    <alias name="example.com"/>
+   <rewrite pattern="^/(.*)$" substitution="/$1" flags="L">
+       <condition test="%{SERVER_PORT}" pattern="=8080" flags=","/>
+   </rewrite>
+   <rewrite pattern="^/(.*)$" substitution="/app1/$1" flags="L">
+       <condition test="%{SERVER_PORT}" pattern="=8081" flags="."/>
+   </rewrite>
+   <rewrite pattern="^/(.*)$" substitution="/app2/$1" flags="L">
+       <condition test="%{SERVER_PORT}" pattern="=8082" flags="."/>
+   </rewrite>
```

- 소켓바인딩 부분

```
<socket-binding-group name="standard-sockets" default-interface="public" port-offset="${jboss.socket.binding.port-offset:0}">
		(중략)
        <socket-binding name="ajp" port="8009"/>
        <socket-binding name="http" port="8080"/>
+       <socket-binding name="http1" port="8081"/>
+       <socket-binding name="http2" port="8082"/>
```
- - -
<br>

- 각 애플리케이션에서의 설정

`/WEB-INF/jboss-web.xml`을 생성하고 각 애플리케이션에 맞게 context-root명을 지정한다.

```
<?xml version="1.0" encoding="UTF-8"?>
<jboss-web>
   <context-root>/app1</context-root>
</jboss-web>
```

- 추가로 확인할 것들
사용할 포트들의 외부 접속 허용 여부 설정, Virtual Machine 위에서 동작 시 포트포워딩 설정

<br>
- - -

위와 같이 설정을 마치고 `app`, `app1`, `app2`를 배포했을 때 다음 URL로 각각 접근이 가능하다.

- localhost:8080/app/
- localhost:8081/app1/
- localhost:8082/app2/


JBoss 의 웹 서브 시스템에서 제공하는 URL Rewriting을 사용하여 특정 URL 패턴으로 들어오는 요청을 서버 레벨에서 리다이렉트 처리 하는데, 일단 구현을 해놓긴 했지만 아직 이해가 부족하다. 공식 도큐먼트를 참고하면 좋겠다.

- [https://docs.jboss.org/jbossweb/7.0.x/rewrite.html](https://docs.jboss.org/jbossweb/7.0.x/rewrite.html)
- [https://docs.jboss.org/jbossweb/7.0.x/config/host.html](https://docs.jboss.org/jbossweb/7.0.x/config/host.html)

