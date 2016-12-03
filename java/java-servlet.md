# java-servlet

### j2EE

자바는 최초에 가전 제품 내에 탑재해 동작하는 프로그램 개발을 위해 등장했지만(Java SE), 자바를 이용한 서버측 개발을 위한 플랫폼을 제공하기 위해 Java EE(Enterprise Edition)가 등장했다. 최초에는 J2EE라는 명칭으로 발표 했고 2006년 J2EE에서 Java EE로 개칭하였다. 하지만 아직까지 두 명칭이 혼용되고 있다. Java EE에는 엔터프라이즈 환경의 웹 애플리케이션을 구현하기 위해 다양한 기술이 포함되어 있는 그 기술 중 일부가 Servlet과 JSP이다. 즉 자바로 웹 애플리케이션을 개발하기 위해서는 Java EE의 기술을 사용해야 하는 것이다.

- [위키피디아 - 자바](https://www.wikiwand.com/ko/자바_(프로그래밍_언어))
- [위키피디아 - 자바 엔터프라이즈 에디션](https://www.wikiwand.com/ko/%EC%9E%90%EB%B0%94_%ED%94%8C%EB%9E%AB%ED%8F%BC,_%EC%97%94%ED%84%B0%ED%94%84%EB%9D%BC%EC%9D%B4%EC%A6%88_%EC%97%90%EB%94%94%EC%85%98)



### servlet

- [Oracle:JavaEE7 Tutoral - What is a Servlet](https://docs.oracle.com/javaee/7/tutorial/servlets001.htm)

자바의 서블릿 기술은 응답과 요청(Request-Response) 형태의 프로그래밍 모델을 가지는 애플리케이션을 호스팅 하는 서버의 기능을 확장하는 자바의 클래스들을 뜻한다.

- `javax.servlet`

위 팩키지에서 서블릿 구현을 위한 인터페이스를 제공하고, 모든 서블릿들은 반드시 Servlet 인터페이스를 구현(Impleement)해야 한다. 서블릿을 구현 하기 위해서는 `javax.servlet.GenericServlet` 또는 `javax.servlet.http.HttpServlet`  를 상속하면 된다.

- GenericServlet: 서블릿 인터페이스를 구현한 추상 클래스로 service 외에는 모두 구현 된 일종의 서블릿을 위한 어댑터 역할을 한다. 특정 프로토콜에 종속되지 않는다.
- HttpServlet: GenericServlet을 상속하여 HTTP 프로토콜에 맞게 재구현한 추상 클래스다. 일반적인 자바 웹 애플리케이션 개발에서 서블릿이라 함은 HttpServlet을 의미한다.



### servlet container

- 작성 TO-DO

### servlet lifecycle

- 작성 TO-DO

## 참고

- [Oracle: JavaEE7 Tutorial](https://docs.oracle.com/javaee/7/tutorial/)
- [Dzone Article: What is a Servlet Container?](https://dzone.com/articles/what-servlet-container)
- [웹 프로그래머를 위한 서블릿 컨테이너의 이해|저자 최희탁|한빛미디어(주) |2012.09.27](http://book.naver.com/bookdb/book_detail.nhn?bid=7082377)
- [HEAD FIRST SERVLETS & JSP|저자 브라얀 바샴, 버트 베이츠, 케이시 시에라|역자 김종호|한빛미디어 |2009.02.27](http://book.naver.com/bookdb/book_detail.nhn?bid=5902081)