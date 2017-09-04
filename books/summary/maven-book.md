# 자바 세상의 빌드를 이끄는 메이븐을 읽고

메이븐(Maven)은 프로젝트 빌드 툴이다. 어쩌면 내가 웹 개발에 사용하는 기술들 중에 아예 학습을 하지 않은 기술이고, 학습할 필요를 가장 못 느낀 기술이다. 왜 학습의 필요를 느끼지 못했을까?

1. 프로젝트의 최초 구조는 보통 리드 프로그래머(Lead-Programmer)가 잡는다.

2. 이렇게 구조를 잡아주면 버전관리시스템에서 프로젝트를 체크아웃(Checkout) 받아 의존성 라이브러리 추가 하기 위해 최초 메이븐을 한번 실행 하는 것 외에는 딱히 메이븐을 사용할 일이 없다.

3. 사내에서 메이븐을 의존 라이브러리 관리 용도로만 사용한다. (빌드, 배포는 직접)

그런데 최근 뭔지는 알고 써야 겠다는 생각이 강하게 들었다. 갑자기 내가 학습의 필요를 느낀 이유들은

1. 개인 프로젝트를 진행하기 위해 직접 `pom.xml` 을 정의하다 보니 메이븐에 대해 호기심이 생겼다

2. 이전의 경험으로는 오픈 소스의 메이븐 프로젝트를 내려 받거나 사내 프로젝트에서 체크아웃 받았을 때, 첫 빌드를 위해 삽질하는 경우가 많았다. 빌드(Build)툴이라는 것이 여러 사람, 여러 환경에서 동일한 환경을 구축하여 개발하기 위함인데 빌드가 매번 깨지니 왜 이렇게 불편한가 하고 생각한 적이 있다. 일단 내가 메이븐을 잘 몰라서 빌드가 잘 되지 않으면 문제를 해결하기 보다는 될 때까지 새로 체크아웃 받고 새로 빌드 했었다. 그리고 `나는 프로그래머다`라는 팟캐스트 청취 중 잘 정의 된 메이븐 프로젝트는 어디서든 빌드가 잘 된다는 얘기를 들었다. *그래? 그럼 나도 잘 쓰고 싶은데?* 라는 생각이 들었다.

3. TDD 주도 개발과 관련 된 세미나에서 메이븐 빌드와 연동하여 지속적 통합(CI)에도 사용 되는 것을 보고 학습의 욕구가 생겼다.


> [자바 세상의 빌드를 이끄는 메이븐](http://book.naver.com/bookdb/book_detail.nhn?bid=6600936), 박재성 저, 한빛미디어, 2011


메이븐에 관련 된 국내 서적이 별로 없긴 했지만, 선택지가 많았어도 아마 이 책을 선택했을 것이다. 왜냐하면 저자이신 박재성님은 자바지기(javajigi))라는 닉네임으로 개발자 커뮤니티에서 유명하시기도 하고, 지난 4월 [스프링캠프 컨퍼런스](http://onoctober.tistory.com/97) 에서 직접 강연하시는 것도 인상 깊게 들었기 때문이다. 또한, 웹개발을 공부하던 시절에 유튜브에서 [공감 세미나 (세션4) 박재성 -자바 웹 개발자의 학습 로드맵](https://www.youtube.com/watch?v=3mgMwObtaQ0&app=desktop) 이라는 영상이 많은 도움이 되기도 했었다.

## Quick Start

> [Maven in 5 Minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)

메이븐을 설치하고, 환경변수를 잡는 과정을 거치고 나면 메이븐 공식 사이트에서 메이븐 퀵스타트 가이드를 따라할 수 있다. 

```bash
$ mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app 
-DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

터미널에서 위와 같은 명령어를 작성하면 프로젝트가 생성된다. 아래와 같은 프로젝트 구조가 생성된다.

```
my-app
|-- pom.xml
`-- src
    |-- main
    |   `-- java
    |       `-- com
    |           `-- mycompany
    |               `-- app
    |                   `-- App.java
    `-- test
        `-- java
            `-- com
                `-- mycompany
                    `-- app
                        `-- AppTest.java
```

프로젝트의 구조라는 것이 결국 폴더(디렉토리) 구성이 어떻게 되어 있느냐는 것인데, 위의 구조가 터미널에서 입력한 `archtype-quickstart` 의 프로젝트 구조이다.

```
$ mvn archetype:generate
```

터미널에서 위와 같은 명령어를 입력하면 다양한 프로젝트 구조를 설정할 수 있는데, 대략 200개 가까운 구조들이 있다. 자세한 목록은 [https://maven.apache.org/archetype/index.html](https://maven.apache.org/archetype/index.html) 여기서 확인할 수 있다. 그리고 꼭 미리 정의되어 있는 아키타입대로만 사용 가능한 것이 아니라 `pom.xml` 조작을 통해 취향에 따라 프로젝트 구조를 변경할 수 있다. 



## 메이븐 라이프사이클

> 프로젝트 빌드의 과정:  이전 결과물 삭제 > 컴파일에 필요한 자원 복사 > 소스코드 컴파일 > 테스트 > 압축(패키지) > 배포

메이븐에서 미리 정의하고 있는 빌드 순서를 `라이프사이클` 이라 한다. 그리고 라이플 사이클의 각 빌드 단계를 `페이즈`라고 한다. 페이즈들은 또 연결되어 있는 `플러그인`을 실행한다. 메이븐의 라이프사이클의 종류에는

1. 소스 코드를 컴파일 > 테스트 > 압축 > 배포 하는 기본 라이프사이클
    - `compile`: 소스 컴파일
    - `test`: 단위 테스트 프레임워크로 테스트를 실행(JUnit, TestNG 등)
    - `package`: pom.xml 설정에 따라 패키징(war, jar, ear 등)
    - `install`: 로컬 저장소에 압축 파일 배포(개발자 PC의 저장소)
    - `deploy`: 원격 저장소에 압축 파일 배포

2. 빌드 결과를 제거하기 위한 clean (target 디렉토리 삭제)

3. 프로젝트 문서 사이트 생성을 위한 site

## Project Object Model

메이븐 빌드와 관련된 정보를 프로젝트 객체 정보라는 이름으로 정의하고 있고, 이 이름을 따서 기본 설정 파일 이름은 `pom.xml` 이다. 이 설정 파일 내에서 크게 네 개의 카테고리에 대해 설정할 수 있다.

- 프로젝트 관계 설정
- 프로젝트 기본 정보
- 빌드 설정
- 빌드 환경

그리고 우리가 생성하는 `pom.xml` 파일은 메이븐에서 사용할 수 있는 기본적인 플러그인을 포함하고 있는 최상위 `pom`을 상속하는 구조이다.

## 메이븐을 통한 의존 라이브러리 관리

- 중앙저장소: [http://mvnrepository.com/]()
- 원격저장소: 사내 레파지토리 등으로 구축하여 활용
- 로컬저장소: 메이븐을 빌드할 때 다운로드 하는 라이브러리, 플로그인을 관리하는 개인 PC의 저장소. 기본 위치는 `USER_HOME/.m2/repository`

메이븐은 의존 관계에 있는 라이브러리를 `pom.xml` 으로 관리하기 때문에 Git이나 SVN 같은 버전 관리 시스템에 모든 라이브러리를 올리고, 다운받고 할 필요가 없다. 단지 `pom.xml`파일만 있으면 된다. 단 각자의 PC에서 다시 라이브러리를 받기 위해 빌드 과정을 거쳐야 한다. 의존 라이브러리는 `<dependencies/>` 엘리먼트 안에 정의 한다.

```xml
<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

junit과 같은 라이브러리는 단위테스트에서만 필요하다. 라이브러리도 scope 설정이 가능하다.

- `compile`: 스코프를 설정하지 않았을 때 기본 값. 컴파일 및 배포시 같이 제공해야 하는 lib
- `provided`: 컴파일 시점에는 필요 하지만 배포 시점에는 필요 없는 lib
- `runtime`: 컴파일 시점에는 필요 없지만 배포 시점에는 필요 한 lib
- `test`: 테스트 시점에만 필요한 lib
- `system`: provided와 비슷한 옵션. 단 사용자가 직접 jar 파일을 제공해야 함.
- `import`: 다른 pom 설정 파일의 의존 관계를 가져 옴.

`pom.xml` 으로 라이브러리 관리가 된다고 했다. 하지만 만약 꼭 프로젝트 안에 라이브러리들을 포함하고 싶다면 아래의 터미널 명령으로 프로젝트에 라이브러리 파일들을 직접 포함 시킬 수 있다.

```bash
mvn clean dependency:copy-dependencies package
```

#### 의존성 전이

`<dependencies/>` 안에 10개의 의존라이브러를 정의했는데 실제로는 10개 이상의 라이브러리가 포함될 수 있다. 이유는 각 라이브러리들이 의존하고 있는 또 다른 라이브러리들이 있을 수 있기 때문이다. 실제로 라이브러리를 뜯어 보면 각각의 라이브러리들이 `pom.xml`파일을 가지고 있음을 확인할 수 있다.

## 정리

알고 삽질하는 것과 아무것도 모르고 삽질하는 것은 큰 차이가 있다고 생각한다. 메이븐이 빌드툴이라는 말은 들어봤었지만 그 빌드라는 것이 정확히 어떤 것인지를 명확히 이해하지 못했었고, 단지 메이븐을 사용하면 `라이브러리 같은 것들을 편하게 사용할 수 있구나~`하는 정도의 생각을 가지고 있었다. 하지만 책을 보고 나니 메이븐은 그 이상의 역할을 할 수 있었다. 말 그대로 빌드툴이다. `pom.xml` 파일만 잘 정의해두면 몇몇 터미널 명령어만으로 메이븐이 알아서 라이브러리를 받고 > 컴파일하고 > 유닛테스트하고 > 패키징 해주고.. 거기다 배포까지. `pom.xml`의 좀 더 세부적인 설정 내용들은 따로 정리하지 않아 다시 한번 책을 참고해야 할 것 같다. 하지만 앞으로 메이븐을 사용하는 과정에 문제가 발생하면 마냥 메세지를 복사해 구글신에 묻기 보다 문제를 추적 해 나갈 수 있을 것 같다.