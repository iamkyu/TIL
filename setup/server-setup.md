Server Setting
===

```
폴더 모두 이동: mv [원본폴더] [목적지폴더]
파일을 특정 디렉토리로 복사: cp [파일명] [목적지폴더]
명령어 히스토리 조회: history | grep [검색어]
```


- IBM AIX에 JDK를 설치시에는 아래 URL에서 JDK를 받는다.

[http://www.ibm.com/developerworks/java/jdk/aix/service.html]()

```
$ gunzip Java7r1_64.jre.7.1.0.250.tar.gz
$ tar xvf Java7r1_64.jre.7.1.0.250.tar
$ installp –a –Y –d ‘/경로명’ Java7r1_64.jre
$ cd /usr/java6_64
$ ls
```

- `c` 디렉토리를 포함하여 여러개의 파일들을 묶을 때 사용한다(Create).

- `x` 디렉토리를 포함하여 묶인 파일의 압축을 풀겠다는 것을 tar에게 알린다(eXtract)

- `v` 작업 진행 상황을 화면에 표시한다(Verbose)
- `t` tar 파일안에 있는 파일이나 디렉토리 목록을 볼 때 사용하는 옵션이다(lisT)


[인스톨 옵션]

`-a` :  설치
`-Y` : 라이센스 동의
`-d` :  설치 디렉토리 사용자 지정

- JDK를 필요로 하는 응용 프로그램들을 위한 환경설정

```
$ vi .profile

PATH=/usr/bin:/etc:/usr/sbin:/usr/ucb:$HOME/bin:/usr/bin/X11:/sbin:/usr/java71_6
4/bin:usr/java71_64/jre/bin:.

set -o vi

export JAVA_COMPILER=/usr/java71_64/bin/javac
export JAVA_HOME=/usr/java71_64

export PATH

if [ -s "$MAIL" ]           # This is at Shell startup.  In normal
then echo "$MAILMSG"        # operation, the Shell checks
fi                          # periodically.
```

```
$ vi /etc/profile

JAVA_HOME=/usr/local/java
CLASSPATH=.:$JAVA_HOME/lib/tools.jar
PATH=$PATH:$JAVA_HOME/bin
export JAVA_HOME CLASSPATH PATH

필요에 따라 톰캣도 클래스패스 설정
export TOMCAT_HOME=/tomcat/tomcat5.0.19
export CATALINA_HOME=/tomat/tomcat5.0.19
```

[http://tomcat.apache.org/download-70.cgi]()

```
# tar -zxvf apache-tomcat-7.0.70.tar.gz
# cd tomcat
# ./bin/startup.sh
# ps -ef |grep tomcat

# ./bin/shutdown.sh
```

- Subversion 설치

[http://machunroo.tistory.com/entry/AIX-6-Subversion-%EC%84%A4%EC%B9%98]()

- 톰캣 설정

```xml
<Connector port="9090" protocol="HTTP/1.1"
            connectionTimeout="20000"
            redirectPort="8443" URIEcoding="UTF-8" />

...

<Host name="호스트네임입력" debug="0" appBase="webapps"
    unpackWARs="true" autoDeploy="true"
    xmlValidation="false" xmlNamespaceAware="false">
    <Context path="" docBase="/appeon/eisadmin/eis" reloadable="true" crossContext="true" debug="0"/>
</Host>
```

- 톰캣 버추얼호스트 (도메인 분리)

```xml
<Hostname="localhost" appBase="webapps"
unpackWARs="true" autoDeploy="true"
xmlValidation="false" xmlNamespaceAware="false">
</Host>

<Host name="www.testdomain.com" appBase="new_webapps"
unpackWARs="true" autoDeploy="true"
xmlValidation="false" xmlNamespaceAware="false">
<Alias>testdomain.com</Alias>
</Host>
```