# Failed to load ApplicationContext

### 오류/예외 메세지
```
Failed to load ApplicationContext
Caused by: java.io.FileNotFoundException: class path resource [applicationContext.xml] cannot be opened because it does not exist
```

### 해결방법
```
말 그대로 context 파일을 찾지 못해 발생하는 예외다. 파일의 위치를 제대로 명시하거나, 나의 경우 IntelliJ IDE 의 일부 설정을 변경하였다.
```

위 증상이 발생한 나의 프로젝트 구조는 아래와 같다.

```text
src
ㄴspringbook
    ㄴuser
        ㄴdao
            ㄴUserDaoTest.java
        ㄴdomain
ㄴapplicationContext.xml
```

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "/applicationContext.xml")
public class UserDaoTest {
    // test code...
}
```

스프링 프레임워크를 공부하는 과정에서 교재와 똑같이  `@ContextConfiguration` 를 설정했는데 계속해서 context 파일을 찾지 못한다는 예외가 발생했다.

절대 경로를 명시한다던가 해서 해결할 수도 있었지만, 왜 똑같이 했는데 읽지를 못했는지가 궁금해서 찾아보니 내가 사용하는 IntellJ 에서 지원하는 설정과 관련이 있는 듯 했다.

(Picture1)

인텔리J의 프로젝트 설정에서는 각 컨텐츠들의 위치를 지정할 수 있는데, 기본적으로 Resources Folders 는 src/main/resource 으로 지정 되어 있다. 그런데 이렇게 기본 설정으로 컴파일 된 클래스들의 위치를 찾아보면 (기본은 target 하위에 컴파일 된 파일들이 위치한다) 위 스크린샷과 같이 소스코드의 루트 디렉토리에 applicationContext.xml 이 존재하지 않는다.

(Picture2)

그래서 위 스크린샷과 같이 Resource Folders를 src로 지정을 하고 다시 컴파일을 해보면...

(Picture2)

classes 아래에 applicationContext.xml 있고,  제대로 인식하는 것을 확인할 수 있다. 아마 xml 같은 파일들은 리소스 파일로 분류하고 리소스 폴더를 지정하지 않았기 때문에 컴파일시에 xml 파일을 아예 제외해버린 것 같지만 단지 내 추측이다.

## 참고자료
시간적으로 여유가 있을 때, `@ContextConfiguration`의 스캔방식과 context 파일을 절대 경로로 지정하는 방법에 관해서는 아래의 링크를 통해 참고해야 겠다.

- [[Spring 레퍼런스] 10장 테스트 #2](https://blog.outsider.ne.kr/860)
- [JUnit Test에서 Web Application의 application context 로딩](http://hightin.tistory.com/42))
