# Get Your Hands Dirty on Clean Architecture

> 톰홈버그스 저 | Packt | 2019.


![book-cover](https://user-images.githubusercontent.com/13076271/101275124-9f53b100-37e6-11eb-9ac3-46fb8b4d493b.png)



클린 아키텍처 위에서 손을 더럽힌다? 

무슨 말인지 의아했지만 "어떤 일을 실제로 한다." 는 비유적인 표현으로 사용되는 듯하다. 나의 무지. 

굳이 한국말로 번역하면 "클린 아키텍처 만들기" 정도의 느낌일까.

이 책은 육각(a.k.a Port & Adapters) 아키텍처 스타일에 관해 이야기 하는 책이다.

> An architectural style is a coordinated set of architectural constraints that restricts the roles/features of architectural elements and the allowed relationships among those elements within any architecture that conforms to that style. [Fielding00]

아키텍처 스타일이란 제약조건의 집합[Eunjun07] 이라고도 하는데 육각 아키텍처가 가진 각종 제약조건은 도메인 주도 설계(이하 DDD)의 구현과 궁합이 잘 맞아 함께 자주 언급된다.

이 책 역시 책 전반에 DDD 가 언급되지만, 육각 아키텍처에 대한 설명과 구현에 초점이 맞춰져 있다.

첫 챕터에서는 전통적인 계층형 아키텍처를 경험하며 저자가 느낀 단점에 관해 이야기 한다.

그 후 챕터별로 육각 아키텍처의 각 영역을 어떻게 구현할 것인지, 이것이 유지보수 가능한 소프트웨어를 만드는 데 어떤 도움이 되는지 예제 코드를 중심으로 설명한다. 이 아키텍처를 구현한 코드를 많이 보진 못한 나는 많은 참고가 되었다. 또한, 아키텍처는 촉박한 일정, 다양한 요구사항 등 여러 가지 이유로 점점 더 부식<sup>erode</sup>되어 가는데 이를 방지 하기 위한 여러 기법도 소개한다.

저자는 계층형 아키텍처의 단점 중 하나로 침범하기 쉬움 (prone to shortcuts) 을 들었는데 육각 아키텍처도 가질 수 있는 단점이라 생각한다. 물론, 이런 침범을 최소화 하기 위한 제약이 더 많지만, 결국 그 아키텍처 위에서 코드를 작성하는 사람들이 신경을 곤두세우고 주의하지 않으면 결국 경계를 침범하고, 뒤죽박죽 엉퀴어 아키텍처를 무너뜨릴 것이다.

따라서 아키텍처가 변화하는 요구사항에 부식을 최소화 화기 위해 계속해서 아키텍처를 살피고 변화해야 하며 책에서 소개한 것 같은 여러 장치로 제약이 필요하다. 앞서 얘기했지만 아키텍처 스타일 또한 이런 부식을 최소화하기 위한 제약 중 하나다.

이 책에서 또 한가지 좋았던 점은 책 전반의 뉘앙스이다.

각 영역의 세부 구현 방식에 대해서도 트레이드오프와 함께 설명하였는데 책 종반에 와서는 "그럼 우린 앞으로 육각 아키텍처 스타일로 구현해야 할까?"라는 질문에 그것은 상황에 따라 다르다고 답한다.

"은 총알은 없다" 로이 필딩의 논문을 또 한번 인용한다.

> Some architectural styles are often portrayed as "silver bullet" solutions for all forms of software. However, a good designer should select a style that matches the needs of the particular problem being solved. [Fielding00]

이 책을 먼저 읽은 동료가 사내에서 세미나 하며 말하기를,

현재 우리가 만들어나가고 있는 서비스 아키텍처는 만들어질 당시의 팀의 구성, 일정 등 여러 가지 상황을 고려 했을 때 알맞은 아키텍처라고 생각하지만, 앞으로는 그 아키텍처가 맞지(fit) 않을 수 있다. 그러므로 이 책의 좋았던 부분들을 소개하고 함께 고민했으면 좋겠다고 했다.

동감한다. 상황은 계속 변화하고 그 상황에 맞춰 최초 만들어진 아키텍처 그대로 있는 게 아닌, 변화한 상황에 맞춰 변해야 한다. 매 선택의 갈림길에서 손안에 여러 카드를 쥘 수 있어야 하고 그중 최고의 카드를 내기 위해 지속해서 배우고 공유해야겠다.



[책 구매하기](https://www.amazon.com/Hands-Dirty-Clean-Architecture-hands-ebook/dp/B07YFS3DNF/ref=sr_1_2?dchild=1&keywords=get+your+hands&qid=1617199975&sr=8-2)




## 참고
- [Eunjun07] EungJun Yi - [그런 REST API로 괜찮은가, 2017](https://slides.com/eungjun/rest#/29)
- [Fielding00] Roy Thomas Fielding - [Architectural Styles and the Design of Network-based Software Architectures, 2020](https://www.ics.uci.edu/~fielding/pubs/dissertation/software_arch.htm#sec_1_5)