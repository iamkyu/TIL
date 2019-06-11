# 오브젝트
> 조영호 저, 위키북스, 2019 [링크](http://www.yes24.com/Product/Goods/74219491?scode=032&OzSrank=1)  

# 1장. 객체, 설계
## 의존성과 캡슐화
- 의존성은 어떤 객체가 변경될 때 그 객체에 의존하는 다른 객체도 함께 변경될 수 있다는 사실을 내포. 객체간 의존성이 과할 때 결합도가 높다고 말함.
- 어떤 객체가 변경 될 때 그 객체에 의존하는 객체가 세부 사항을 너무 많이 알고 있으면 함께 변경될 수 밖에 없음. 이런 변경은 버그를 부르고 버그에 대한 두려움은 코드의 변경을 어렵게 함.
- 캡슐화를 통해 객체 내부의 세부 사항을 감춤으로써  객체 사이의 결합도를 낮출 수 있음.  즉, 캡슐화는 객체의 변경을 쉽게 만들어줌.

## 객체지향 설계와 트레이드 오프
- 책 예제의 코드를 개선하는 과정에서 변경 전에 없던 새로운 의존 관계가 생김. 이 예제를 통해 두가지 메세지를 전달. 첫째, 어떤 기능을 설계하는 방법은 한 가지 이상일 수 있음. 둘째, 동일한 기능을 한 가지 이상 방법으로 설계할 수 있기 때문에 결국 설계는 트레이드오프의 산물임. 은 총알은 없음.
- 객체지향 패러다임 역시 마찬가지. 객체지향이 적합하지 않은 상황에서는 언제라도 다른 패러다음을 적용할 수 있는 시야를 길러야 함.
- 좋은 설계란 오늘의 요구 사항을 온전히 수행하며 내일의 변경을 매끄럽게 수용할 수 있는 것.
- 좋은 객체지향 설계란 객체 사이의 의존성을 적절하게 관리하는 것.

## 의인화
```java
public class Theater {
    public void enter(Audience audience) {
        if (audience.getBag().hasInvitation()) {
            Ticket ticket = ticketSeller.getTicketOffice().getTicket();
            audience.getBag().setTicket(ticket);
        } else {
            Ticket ticket = ticketSeller.getTicketOffice().getTicket();
            audience.getBag().minusAmount(ticket.getFee());
            ticketSeller.getTicketOffcie().plusAmount(ticket.getFee());
            audience.getBag().setTicket(ticket);
        }
    }
}
```
- 위 코드는 `Theater` 가 모든 책임을 지고 너무 많은 객체에 의존하고 있음. 매표소에서 티켓을 가져와서 관람객의 가방을 열어 초대장이 있는지 확인하고, 있으면 티켓을 넣어주고 없으면 돈을 꺼내고..
- 예제에 등장하는 영화관, 가방, 매표소 등은 현실 세계에서는 모두 수동적인 존재. 하지만 객체지향 세계에서는 능동적이고 자율적인 존재로 의인화 되야 함.
- 각 객체가 적절한 책임을 할당함으로써 응집도를 높이고 객체간의 결합도를 낮출 수 있음.
- 객체지향 설계의 핵심은 적절한 객체에 적절한 책임을 할당하는 것.
