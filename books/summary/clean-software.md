# Clean Software

> 원제: Agile Software Development, Principles, Patterns, and Practices
>
> 로버트 C. 마틴. 이용원 외 2명 역. 제이펍. 2017 [[상세정보]](http://book.naver.com/bookdb/book_detail.nhn?bid=12035385)

## 목차
<!-- TOC -->

- [Clean Software](#clean-software)
    - [목차](#목차)
    - [7. 애자일 설계란 무엇인가](#7-애자일-설계란-무엇인가)
        - [부패하고 있는 소프트웨어의 악취](#부패하고-있는-소프트웨어의-악취)
        - [Copy 프로그램 예제](#copy-프로그램-예제)
    - [8. 단일 책임 원칙 (Single-Responsibility Principle)](#8-단일-책임-원칙-single-responsibility-principle)
    - [9. 개방 폐쇄 원칙 (Open-Closed Principle)](#9-개방-폐쇄-원칙-open-closed-principle)
        - [폐쇄는 완벽할 수 없다](#폐쇄는-완벽할-수-없다)
    - [10. 리스코프 치환 원칙 (Liskov Substitution Principle)](#10-리스코프-치환-원칙-liskov-substitution-principle)
    - [11. 의존관계 역전 원칙 (Dependency Inversion Principle)](#11-의존관계-역전-원칙-dependency-inversion-principle)
        - [Button 프로그램 예제](#button-프로그램-예제)
    - [12. 인터페이스 분리 원칙 (Interace-Segregation Principle)](#12-인터페이스-분리-원칙-interace-segregation-principle)
        - [보안 시스템 예제](#보안-시스템-예제)

<!-- /TOC -->


## 7. 애자일 설계란 무엇인가

> 애자일 팀은 악취를 제거하기 위해 원칙을 적용하는데, 아무 악취도 나지 않을 때는 원칙을 적용하지 않는다. (중략) 원칙에 대한 맹종은 불필요한 복잡성이란 설계의 악취로 이어진다.



### 부패하고 있는 소프트웨어의 악취

1. 경직성: 시스템의 변경이 어려움. 변경을 하려면 시스템의 다른 부분들도 영향을 받음.
2. 취약성: 시스템의 특정 부분을 변경하면 그 부분과 개념적으로 관련 없는 부분이 망가짐.
3. 부동성: 다른 시스템에서 유용하게 쓸 수 있는 부분을 원래 시스템에서 분리하기가 어려움.
4. 점착성: 옳은 것을 하는 것이 잘못된 것을 하는 것보다 어려움. 예를 들어 변경사항을 마주했을 때, 현재 설계를 유지하는 것이 엉터리 방법보다 어렵다면 설계의 점착성이 높아진다고 할 수 있음. 
    - 점착성이라는 단어가 잘 안 와닿음. 더 어려운 방법이 점착성이 높다? '끈끈하게 착 달라붙음'?
    - 원서에서는 Viscosity 라는 단어를 사용함.
    - 점착성이라는 단어가 '[정보의 점착성이란 무엇인가?](https://blog.naver.com/ckgeem/80189670869)' 이 글에서 설명한 내용과 같은 맥락으로 사용된 것이라 생각 됨. 글에서는 단위의 정보를 받는쪽에 이용 가능한 형태로 이동시키는데 드는 비용을 점착성이라 하며 이 비용이 높을 때 점착성이 높다고 한다고 함. **비용** 의 의미를 나타내는 단어인듯.
5. 불필요한 복잡성: 현재 시점에 유용하지 않은 요소가 설계에 포함 됨. '앞으로 일어날지도 모르는 일'을 과도하게 준비함.
6. 불필요한 반복: Ctrl-C, Ctrl-V 코드의 반복.
7. 불투명성: 모듈, 코드가 읽고 이해하기 어려움. 의도를 잘 표현하지 못함.



### Copy 프로그램 예제

'Copy' 프로그램 예제에서는 소프트웨어가 개발 된 후, 요구사항의 변화를 겪으며 부패하는 예제를 보여 줌. 그 과정에서 다음과 같은 증상들이 나타났음.
- 일정을 지나치게 뻥튀기 함.
- 하지만 실제로 중간 중간 잡다한 일이 많이 끼어 들어 옴.
- 인터페이스 변경에 시스템의 많은 부분들이 영향을 받음 (하지만 이 부분은 어쩔 수 없는 부분인 것 같긴 하다. 따라서 최초에 인터페이스를 설계할 때 신중해야 하며 웹 API의 경우 버저닝 정책 등을 고려하는 듯).
- 계속되는 요구사항 변경으로 고객이 소프트웨어 설계를 망치고 있다고 탓 함.
- 변경된 기능에 대해 코드로 설명할 수 없어 주석이 추가 됨. 실제로 주석이 없다면 코드를 이해할 수 없음.

> 우리는 변하는 요구사항의 세계에 살고 있고, 우리가 만든 소프트웨어가 이런 변화 속에서 살아남을 수 있게 만드는 것이 바로 우리가 해야 하는일.

박성철님의 [슬라이드](https://www.slideshare.net/gyumee/ss-55817747)에서는 제목 그대로 소프트웨어에 유기적이라는 표현을 썼음. 소프트웨어는 생물처럼 변화에 적응하고 대응해야 함. 그럼 어떻게 해야 해?

- 시스템의 설계를 가능한 명료하고 단순하게 유지.
    - 애자일 실천방법으로 문제를 찾아냄
    - 설계 원칙을 적용해 문제를 진단
    - 적절한 방법을(패턴 등) 적용해 문제를 해결
- 이것을 많은 단위 테스트와 인수 테스트로 뒷받침.
- 절대 부패가 시작되도록 놔두지 않음. 몇 주에 한번씩 설계를 청소하지 않음. 매일, 매시간, 매분마다 함.



그런데 설계 할 때 변경을 지나치게 고려하면 복잡성이 높아진다 하고, 설계를 너무 단순하게 했다가 경직성이 높아지는데 어떡하나? 변경에 대응하기 위해 인터페이스를 도입해야 한다는 건 어떻게 알 수 있나? 객체 지향 설계의 기본적인 주의<sup>tenet</sup>을 알고 있어야 함.



## 8. 단일 책임 원칙 (Single-Responsibility Principle)

> 한 클래스는 단 한가지의 변경 이유만을 가져야 한다.

한 클래스는 하나의 책임을 가져야 하는데 SRP의 맥락에서, 책임이란 **'변경을 위한 이유'** 로 정의함.

```java
// 예제 1. 직사각형 인터페이스
interface Rectangle {
    void draw();
    double area();
}

// 예제 2. 모뎀 인터페이스
interface Modem {
    void dial(String pno);
    void hangup();
    void send(char c);
    char receive();
}
```

책에서 예로 든 위 두가지 인터페이스를 보면 현실 세계의 모델을 그대로 잘 옮겨온 것 같아 보이고 자연스럽게 인식됨.
- 예제1의 직사각형은 넓이를 계산할 수 있고 그릴 수 있음.
- 예제2의 모뎀은 연결을 관리하고 데이터 통신을 함.

하지만 현실 세계와 소프트웨어 세계는 다름. 두 예제의 책임을 서술한 문장을 보면 AND('있고', '하고') 가 포함. 이는 두가지 책임을 지고 있다고 할 수 있고 클래스를 변경해야 하는 이유가 두 가지가 됨.

![SRP는 Actor에 관한 것](https://user-images.githubusercontent.com/13076271/41201081-50f849b6-6cec-11e8-8094-0d638982091e.png)

> 그림 출처: [백명석님 Youtube - 클린 코더스 강의 13. SRP(Single Responsibility Principle)](https://youtu.be/AdANHDp5dTM)

백명석님의 강의를 보면 '누가 해당 메소드의 변경을 유발하는 사용자인가'에 따라 책임을 나눌 수 있다고 함. 해당 메서드를 누가 호출하는가? 

- 메서드를 호출하는 각각의 User가 있음.
- User는 각각의 User로 전부 구분하는 것이 아니라 그들이 수행하는 Role에 따라 나뉨.
- User가 특정 Role을 수행할 때 Actor라고 부름.
- 책임은 개인(User)가 아니라 Actor와 연결.

Actor들을 Serve하는 책임을 식별하는 일이 필요.

![](https://user-images.githubusercontent.com/13076271/41202775-b520904e-6d08-11e8-9f8f-5ef25cbf46a2.png)

> 그림 출처: [백명석님 Youtube - 클린 코더스 강의 13. SRP(Single Responsibility Principle)](https://youtu.be/AdANHDp5dTM)

그런데 이렇게 Actor를 찾아내고 다이어그램을 그리고 코드로 구현하는 일이 폭포수<sup>waterfall</sup>모델로 차례 차례 진행되기는 굉장히 어려움. 테스트를 바탕으로 동작하는 모델을 만든 후 그 과정에서 책임을 식별하고 리팩터링 과정을 거침. 이쁜 다이어그램이 그려질 수 있는 건 모든 구현이 완료 된 후임.



SRP를 어렵게 하는 또 한 가지는 두 책임이 항상 분리 되어야만 하는 것은 아님. 앞으로 애플리케이션이 어떻게 바뀌느냐에 달려 있음. 두 가지 책임에 대해 각각 변경이 유발될 일이 없다면 분리가 오히려 불필요한 복잡성을 유발함. 그러나 많은 경우 변경 되는 것 같음.

` // TODO: 실제 경험 사례 내용을 추가하면 좋을 것 같은데 뭐가 있을까..`



## 9. 개방 폐쇄 원칙 (Open-Closed Principle)

> 개체(클래스, 모듈, 함수 등)는 확장에 대해 열려 있어야 하고, 수정에는 닫혀 있어야 한다.

일종의 전략으로 요구사항이 변경 되었을 때 원래 코드를 변경하는 것이 아니라 아예 새로운 타입을 추가함.
1. 확장에 열려 있음: 모듈의 행위가 확장될 수 있음. 요구사항이 변경될 때 이에 맞는 새로운 행위를 추가해 모듈을 확장하는 것이 가능. 즉, 모듈이 하는 일을 변경할 수 있음.
2. 수정에 닫혀 있음: 어떤 모듈의 행위를 확장하는 것이 그 모듈의 소스 코드나 바이너리 코드의 변경을 초래하지 않음.

![](https://user-images.githubusercontent.com/13076271/41227410-9b42a232-6daf-11e8-99d3-971717a5100f.png)
> 그림 출처: [백명석님 Youtube - 클린 코더스 강의 14.1. OCP(Open-Closed Principle)](https://youtu.be/dqa-IdafeIE)

OCP를 준수하는 방법은 행위의 묶음을 표현하는 추상화<sup>abstraction</sup>를 만드는 것. 위 그림에서 Reader와 Writer의 서브타입들은 원하는 방식으로 그 인터페이스를 구현할 수 있음.

```java
void drawAllShape(List<Shape> shapes) {
    for (Shape shape : shapes) {
        switch (shape.getType()) {
            case SQUARE:
                // do something
            case CIRCLE:
                // do something
                
            // 다른 도형이 추가되면 case 문이 또 추가되어야 함
        }
    }
}
```

책에서 C# 코드로 OCP를 위반하는 도형 그리기 함수 예제를 보여주는 것을 간단히 자바로 표현해봄. 현재 코드에서 삼각형 도형이 추가 된다면..
- drawAllSahpes() 함수에 `case`절을 추가해야 함.
- ShapeType enum에 새 멤버 `TRIANGLE`를 추가해야 함.

자바에서는 주로 switch/case 문이나 if/else 사슬이 이어지는 형태로 OCP 위반의 냄새를 풍김.

```java
interface Shape {
    void draw();
}
```

```
void drawAllShape(List<Shape> shapes) {
    for (Shape shape : shapes) {
        shape.draw();
    }
}
```

OCP를 따르기 위해서 이전에는 Circle, Square 등 제각각 구현되있던 구체 클래스에서 -> Shape라는 이름의 인터페이스를 만들고 draw()라는 행위를 추상화함으로써 타입을 체크하고 그에 맞는 행위를 호출할 필요 없이, 추상화 된 행위를 호출하고 구현은 서브타입들이 원하는 방식으로 함.


### 폐쇄는 완벽할 수 없다
이전 예제에서 앞으로 다른 도형 종류가 추가될 것이라고 예상하고 확장가능하도록 만들었음. 그런데 그런 요구 사항이 아니라 그리기 순서에 대한 요구사항이 온다면? 순서에 대해 요구사항이 왔을 때, 앞의 예제에서 구현한 모델은 자연스럽지 않음. 모든 상황에서 잘 어울리는 자연스러운 모델은 존재하지 않음. 

> 폐쇄는 완벽할 수 없기 때문에, 전략적이어야 한다.

OCP에 완벽히 순응하기 위해서는 미래를 완벽하게 예측할 수 있어야 함. 하지만 불가능함. 이를 극복하기 위해서는 다음 두가지 접근법을 취할 수 있음.

1. Big Design Up Front
    - 고객과 문제 영역을 고찰.
    - OCP가 가능하도록 도메인 모델에 추상화 적용.
    - 변경될 가능성이 있는 모든 것들에 대한 청사진을 얻을 때까지 헛된 짓을 반복.

이 방법으로 접근할 경우 불필요한 추상화로 도배되고 무겁고 복잡한 설계를 만들어 냄. 추상화는 비용이 큼. 어설픈 추상화를 피하는 일은 추상화 자체만큼이나 중요.

2. Agile Design
    - 최대한 빨리 고객의 요구사항을 끌어낼 수 있는 단순한 일을 함 (올가미 놓기).
    - 고객은 그 결과물에 대해 요구사항 변경을 시작.
    - 어떤 변경이 요구되는지 알게 됨.

변화에 대한 가장 좋은 예측은 변화를 경험하는 것. 빨리 자주 Deliver 하고, 고객의 요구사항 변화에 기반하여 리팩토링을 진행. 단, BDUF를 피해야 하지만 No DUF 도 피해야 함. 기본적인 도메인 모델은 초기 단계에서 갖추려고 노력해야 함.



## 10. 리스코프 치환 원칙 (Liskov Substitution Principle)
> 서브타입은 그것의 기반타입으로 치환 가능해야 한다.

![Square IS A Rectangle](https://user-images.githubusercontent.com/13076271/41410078-3e205660-7013-11e8-9851-7b2ac826f629.png)

책의 예제는 직사각형과 정사각형 예제를 보여줌. '정사각형 IS-A 직사각형' 만족하는 것 같음. 직사각형에서 파생 된 정사각형이라는 서브타입을 만듬.

```java
@Test
public void calculate_area() {
    r.setWidth(5);
    r.setHeight(4);

    assertThat(r.getArea()).isEqualTo(20);
}
```

- 위 테스트에서 직사각형의 가로 길이를 바꾸는 것이 세로 길이에 영향을 주지 않을 것이라 생각함.
- 하지만 직사각형의 서브타입인 정사각형에서는 가로와 세로가 항상 같음.

종종 상속은 IS-A 관계라고 함. 하지만 IS-A는 행위에 대한 것. 위 예제에서 정사각형 객체의 행위는 `calculate_area()`가 기대하는 직사각형의 행위와 일치하지 않음. 

```java
//when
Rectangle rectangle = new Rectangle(height, width);
rectangle.setWidth(newWidth);

//then
assertTrue((rectangle.getWidth() == newWidth) && (rectangle.getHeight == height));
```

사용자가 정말로 기대하는 행위를 어떻게 알 수 있는가? 추정을 명시적으로 만드는 테크닉을 계약에 의한 설계<sup>design by contract</sup>라고 함. 

- DBC를 통해 클래스 작성자는 그 클래스의 계약사항을 명시적으로 정함.
- 각 메소드의 사전조건과 사후조건을 선언하는 것으로 구체화 됨.
- 위 예에서 사후조건은 `assertTrue((rectangle.getWidth() == newWidth) && (rectangle.getHeight == height))` 와 같음.
- 파생된 객체는 기반 클래스가 받아들일 수 있는 것은 모두 받아들어야 함. 또한 모든 사후조건을 따라야 함.

X가 Y의 모든 제약을 강제하지 않는다면 X는 Y보다 약하다 할 수 있는데, 직사각형 예제에서 정사각형의 사후조건은 직사각형의 사후조건보다 약함. 따라서 정사각형 클래스의 `setWidth` 메소드는 기반 클래스의 계약을 위반함.

또한, 파생 클래스를 만드는 것이 기반 클래스의 변경으로 이어진다면 대개는 이 설계에 결점이 있음을 의미 함.



## 11. 의존관계 역전 원칙 (Dependency Inversion Principle)
> 상위 수준의 모듈은 하위 수준의 모듈에 의존해서는 안 된다. 둘 모두 추상화에 의존해야 한다. 추상화는 구체적인 사항에 의존해서는 안 된다. 구체적인 사항은 추상화에 의존해야 한다.

상속, 캡슐화, 다형성과 같은 것들이 객체지향의 메커니즘이라고 한다면 의존관계 관리는 객체지향 디자인의 핵심이라 할 수 있음.

전통적인 소프트웨어 구조에서 상위 수준의 모듈이 하위 수준의 모듈에 의존하는, 정책이 구체적인것에 의존하는 경향이 있었음. 상위 수준의 모듈은 중요한 정책 의사결정과 업무 모델을 포함하고 있는 애플리케이션의 본질인데 하위 수준의 모듈에 의존한다면 하위 수준 모듈의 변경이 상위 수준 모듈에 직접적인 영향을 미칠 수 있음.

![미숙한 레이어 나누기 계획](https://user-images.githubusercontent.com/13076271/41413041-e0733348-701c-11e8-951c-9efc608bf67d.png)

위 레이어 구조는 얼핏 보기에 괜찮아 보임. 하지만 다음과 같은 문제가 있음.
- Policy 레이어가 하위 수준의 Utility 레이어의 변화에 민감함.
- 의존성은 이행적<sup>transitive</sup>. 따라서 Policy 레이어는 Utility 레이어에 이행적으로 의존하게 됨.

> 각 레이어는 잘 정의되고 제어되는 인터페이스를 통해 일관된 서비스의 집합을 제공한다.

![역전된 레이어](https://user-images.githubusercontent.com/13076271/41413050-e39dc060-701c-11e8-9a44-2913889b088a.png)

위 레이어 구조는 좀 더 적절함.
- 상위 수준 레이어가 필요로 하는 서비스에 대한 인터페이스 선언.
- 하위 수준의 레이어에서 인터페이스를 구현.
- 인터페이스의 소유권도 역전 되며, 이 인터페이스는 어떤 문맥에서든 재사용 가능함.
- Policy 레이어는 하위 레이어의 어떠한 변경에도 영향을 받지 않음.

### Button 프로그램 예제
```java
class Button {
    private Lamp lamp;

    void poll() {
        if (/* condition */) {
            lamp.turnOn();
        }
    }
}
```

의존성 역전은 한 클래스가 다른 클래스에 메시지를 보내는 장소라면 어디든 적용 가능. 위 예제에서는 Button 객체가 Lamp 객체에 강하게 의존함.
- Button 이 Lamp 의 변경에 영향 받음.
- Button 으로 나중에 Motor 객체를 제어할 수 있게 재사용하는 것 불가능.
- Button 객체는 오직 Lamp 객체만 제어함.

> 상위 수준의 정책이란? 애플리케이션에 내재하는 추상화이자, 구체적인 것이 변경되더라도 바뀌지 않는 진실. 시스템 안의 시스템이며, [메타포](https://ko.wikipedia.org/wiki/%EC%9D%80%EC%9C%A0)다.

Button 예제에 내재하는 추상화는 '사용자로부터 켜고 쓰는 동작을 탐지해 그 동작을 대상 객체에 전한다' 임.

```java
class Button {
    private SwitchableDevice switchableDevice;

    public Button(SwitchableDevice switchableDevice) {
        this.switchableDevice = switchableDevice;
    }

    void poll() {
        if (/* condition */) {
            switchableDevice.turnOn();
        }
    }
}
```

- 위 코드는 Lamp 객체의 의존성을 역전시킴. 
- SwitchableDevice 는 Button 이 어떤 것을 켜고 끄기 위한 추상 메소드를 제공, Lamp 가 구체적인 동작을 구현.
- 인터페이스 이름을 SwitchableDevice 로 변경함으로써 Button 에 대한 의존성이 사라짐. 꼭 Button 이 아니라도 SwitchableDevice 인터페이스를 사용할 줄 알면 Lamp 를 제어할 수 있음.



## 12. 인터페이스 분리 원칙 (Interace-Segregation Principle)
> 클라이언트가 자신이 사용하지 않는 메소드에 의존하도록 강제되어서는 안 된다.

사용하지 않는 것에 의존성을 가진다면
- 해당 인터페이스가 변경되면 재컴파일/빌드/배포 필요.
- 독립적인 개발/배포 불가.
- SRP와도 연관. 한 기능에 변경이 발생하면 다른 기능을 사용하는 클라이언트들에도 영향을 미침.

### 보안 시스템 예제
Door를 열거나 잠굴 수 있는 보안 시스템이 있음. 이 시스템에 문이 열린 채로 일정 시간이 지나면 알람을 울려야 한다는 요구사항이 추가 됨.

![계층 구조 제일 위의 Timer Client](https://user-images.githubusercontent.com/13076271/41531281-cea14fba-732d-11e8-966b-8427cff3015f.png)

- Door 클래스가 TimerClient에 의존하게 됨. 
- Door의 구현 클래스가 모두 타이머 기능을 필요로 하지는 않을 것임.
- 원래 추상 Door 클래스는 제한 시간과 관련해 아무일도 하지 않음.

타이머 기능을 쓰지 않는 Door의 구현 클래스가 만들어진다면 다음과 같은 코드를 작성해야 함.
```java
@Override
public void timeOut() {
    throw new UnsupportedOperationException();
}
```

- 비대한 클래스는 클라이언트 간에 해가 되는 결합도 유발
- 한 클라이언트가 이 비대한 클래스에 변경을 가하면, 모든 나머지가 영향을 받음

서브클래스 중 하나의 이득 때문에 포함한 `timeOut()` 메소드로 인해 인터페이스가 오염 됨. 그리고 앞으로 이런 방식으로 계속해서 메소드가 추가 된다면 기반 클래스의 인터페이스를 오염시키고, 더 비대하게 만들것 임.

![Door Timer Adapter](https://user-images.githubusercontent.com/13076271/41531288-d229d35a-732d-11e8-87af-bb16e854337b.png)

클라이언트 입장에서 인터페이스를 분리해야 함. 위그림을 보면 Timer가 TimerClient를 사용하고, 문을 조작하는 클래스가 Door를 사용할 것임. 이처럼 클라이언트가 분리되어 있기 때문에 인터페이스도 분리된 상태로 있어야 함.

![다중 상속한 Timed Door](https://user-images.githubusercontent.com/13076271/41531890-ed4ccd48-732f-11e8-8a3c-25ad2419ce4b.png)

인터페이스를 분리할 수 있는 방법에는 (1) 위임을 통한 분리 (2) 다중 상속을 통한 분리 등이 있음.
