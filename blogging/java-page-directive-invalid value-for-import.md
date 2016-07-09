#### 오류/예외 메세지
```
Page directive: invalid value for import
```

#### 해결방법
```
<%@page import="com.util.DaoFunction;"%>

.jsp 페이지에서 클래스를 임포트 할 때, 맨 마지막의 세미콜론(;)을 제외한다.
```

`JDK 1.6` / `Tomcat 6` 기반에서 개발 된 프로그램을 `Tomcat 7` 에서 테스트하였는데 유효하지 않은 import 라는 예외가 발생했다. JSP 페이지에 클래스를 import 할 때 포함 된 세미콜론(;) 때문이다. `Tomcat 6` 버전대에서는 문제가 없는데, 7버전부터는 `java.lang.IllegalArgumentException` 이 발생하고 있다. 이 문제는 아파치 재단에 2014년에 레포트 되었고 `Tomcat 7.0.57` 이후 버전부터는 수정되었다고 답변되었는데, `Tomcat 7.0.57` 이든 `Tomcat 8` 이든 동일한 증상을 보인다. 세미콜론을 제외하던지 `Tomcat 6` 버전을 사용해야 할 듯 하다.

#### 참고

- [StackOverflow](http://stackoverflow.com/questions/27258336/illegalargumentexception-project-running-on-netbeans-but-not-on-tomcat-as-war)
- [ASF Bugzilla – Bug 57099](https://bz.apache.org/bugzilla/show_bug.cgi?id=57099#c1)