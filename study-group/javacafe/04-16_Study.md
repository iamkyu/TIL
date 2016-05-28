## 04-16 스터디모임: 디자인패턴

#### 디자인패턴(Design Pattern)
디자인 패턴을 왜 사용하는가?
> Someone has already solved your problems.

<br>
#### Strategy Pattern
여러 알고리즘을 하나의 추상적인 접근점을 만들어 접근 점에서 서로 교환가능하도록 하는 패턴.
- 각각의 알고리즘을 *캡슐화*.
- 알고리즘을 사용하는 클라이언트와 *독립적으로* 알고리즘을 변경 가능.
- *같은 문제를 해결하는 여러 알고리즘* 이 클래스별로 캡슐화되어 있어 필요할때 교체할 수 있다.

##### 용어 정리
인터페이스
> - 기능에 대한 `선언`과 `구현` 분리
> - 기능을 사용하는 `통로`


델리게이트
> - 다른 기능을 호출

##### 디자인원칙
- 애플리케이션에서 달라지는 부분을 찾아내고, 달라지지 않는 부분으로부터 분리시킨다.
- 인터페이스에 맞춘 프로그래밍.
- 상속보다는 구성(Composition)을 활용. (`A는 B이다` -> `A에는 B가 있다`)


##### 참고하면 좋은 곳
- 자바API `java.util.Comparator.compare()`
- 자바ee API `javax.servlet.http.HttpServlet.service()`
- [인프런-자바디자인패턴의 이해(가람)](https://www.inflearn.com/course/%EC%9E%90%EB%B0%94-%EB%94%94%EC%9E%90%EC%9D%B8-%ED%8C%A8%ED%84%B4/)

<br>
#### Decorator Pattern
동적으로 책임을 추가할 수 있도록 하는 패턴. 서브클래스를 만드는 것을 통해 기능을 유연하게 확장할 수 있는 방법.

##### 기본 구조
 - Componenet
	- ConcreateComponent, Decorator 의 공통 기능을 정의
 - ConcreateComponent
  	-	기본 기능을 구현하는 클래스
 - Decorator
	- Decorator 의 공통 기능을 제공
 - ConcreateDeco
 	- Decorator의 하위 클래스로 기본 기능에 추가되는 개별 기능을 제공 

##### 참고하면 좋은 곳
 - 자바API `java.io`
 - [인프런-자바디자인패턴의 이해(가람)](https://www.inflearn.com/course/%EC%9E%90%EB%B0%94-%EB%94%94%EC%9E%90%EC%9D%B8-%ED%8C%A8%ED%84%B4/)