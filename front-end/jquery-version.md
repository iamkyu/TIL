jQuery 버전별 변경사항 및 보안 이슈
===
*   각 버전별 릴리즈 노트 [https://gist.github.com/teppeis/9264080](https://gist.github.com/teppeis/9264080)


## 1.6

- .attr(), .val() 확장 (-> .attr(), .prop() )

- 애니메이션 처리 개선, 성능향상

## 1.7

- 이벤트 처리를 위한 .on() .off() API 추가

- jQuery.Deferred 객체 확장

- jQuery.isNumeric() 추가 - 매개변수의 정수 여부 체크 함수

- .bind(), delegate(), live() 등의 API 통합, 새로운 API추가

- Delegated 이벤트의 성능 향상

- IE6/IE7/IE8에서 HTML5의 더 나은 지원

- 토글링 애니메이션의 직관적인 동작

- AMD(Asynchronous Module Definition) API 지원

- event.layerX와 event.layerY 속성 제거

- jQuery.isNaN() 함수 제거

- jQuery.event.proxy() 함수 제거

## 1.8

- 밴드프리픽스 CSS 속성 지원

- XSS 보안 강화

- $(element).data(“events”) 제거

## 1.9

- .finish 추가

- .toggle(function, function) 제거

- jQuery.browser() 제거

- .live() 제거

- .die() 제거

- jQuery.sub() 제거

- .addBack() -> .addSelf() 이름변경

## 2.0.0

### 중요사항!

- IE 6,7,8 지원 폐지(표준 DOM만을 제공)
- 2.X 버전대는 더이상 IE 6,7,8, 을 지원하지 않긴 하지만, 1.X버전대와 2.X버전대 병행 업그레이드 지원.

### jQeury 보안 이슈

- 1.5.0 이하 버전의 ajax 통신시 Cross Domain 공격 취약점 (1.5.0 버전 이후 크로스도메인 원천봉쇄)
- 1.6.3 이하 버전의 XSS(크로스 사이트 스크립팅) 취약점
- 제이쿼리 1.6.3 릴리즈 노트 - 취약점 패치 내용 [http://blog.jquery.com/2011/09/01/jquery-1-6-3-released/](http://blog.jquery.com/2011/09/01/jquery-1-6-3-released/)

> XSS란 : XSS(Cross-site Scripting)는 웹 상에서 가장 기초적인 취약점 공격 방법의 일종으로 악의적인 사용자가 공격하려는 사이트에 스크립트를 넣는 기법을 말한다. 공격에 성공하면 사이트에 접속한 사용자는 삽입된 코드를 실행하게 되며, 보통 의도치 않은 행동을 수행시키거나 쿠키나 세션 토큰 등의 민감한 정보를 탈취한다. - 출처 : 나무위키 ([https://namu.wiki/w/XSS](https://namu.wiki/w/XSS))