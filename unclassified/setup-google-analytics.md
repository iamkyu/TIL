# Google Analytics 적용

> Google 웹로그 분석(이하 GA)은 매출 및 전환을 측정할 뿐만 아니라 방문자의 사이트 활동, 사이트 유입경로, 고객의 재방문을 유도하는 방법에 대한 최신 분석 자료도 제공. - [공식 구글 웹로그 분석 소개](https://www.google.com/intl/ko/analytics/features/index.html)



본 내용은 GA의 데이터의 분석이나 활용에 관한 것이 아닌, 웹사이트에 실제 적용에 관한 내용.



## GA 적용

[공식 사이트](https://www.google.com/analytics/) 에 접속하여 추적 ID를 발급 받은 후, 적용하고자 하는 웹사이트에 스크립트 코드를 추가.

```javascript
<head>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  // {YOUR-TRACKING-ID} 부분에 발급받은 추적ID 삽입
  ga('create', '{YOUR-TRACKING-ID}', 'auto');
  ga('send', 'pageview');
</script>
</head>
```

- 추적할 모든 페이지에 위 코드를 삽입.
- 코드의 중복을 줄이기 위해 모든 페이지에 공통적으로 `include `되는 header 또는 footer 템플릿에 위 코드를 한 번만 포함하면 모든 페이지뷰를 쉽게 추적 가능.
- 공식 사이트에서는 추적 코드를 `</head>` 직전에 포함할 것을 권하지만, 페이지 로딩 최적화를 위해 스크립트 코드를 최하단에 위치해도 무관. 단, 페이지가 완전히 로드 되기 전, 즉 추적 코드가 로드 되기 전에 페이지를 떠난다면 추적 할 수 없다는 점도 고려.




## 사용자 반응(Interactions) 추적

GA에서 추적 가능한 사용자 반응은 크게 여섯가지 카테고리로 분류.

- 페이지뷰
- 이벤트
- 소셜(Social) 반응
- 앱 / 스크린 추적
- 타이밍 (퍼포먼스)
- 예외 추적

### 페이지뷰 추적

위 **[GA 적용]** 의 추적코드를 적용함으로써, 페이지뷰를 측정 가능.

- 더 자세한 내용은 공식 문서를 참고 - [Page Tracking](https://developers.google.com/analytics/devguides/collection/analyticsjs/pages)

### 이벤트 추적

추적하고자 하는 이벤트가 발생시 마다, 아래와 같은 형식의 코드를 실행.

```javascript
// 명령, 타입(hitType), 분류, 행동, 라벨, 값
ga('send', 'event', [eventCategory], [eventAction], [eventLabel], [eventValue], [fieldsObject]);
```

명령과 타입은 필수이지만, 나머지 파라미터들은 선택 옵션. 아래는 몇가지 사용 예시.

```javascript
// 메뉴 카테고리에 속하는 이벤트이고, about메뉴를 클릭을 Google Analytics로 전송(기록)한다.
ga('send', 'event', 'Menu', 'Click', 'about');

// SNS 카테고리에 속하는 이벤트이고, Facebook을 클릭 Google Analytics로 전송(기록)한다.
ga('send', 'event', 'SNS', 'Click', 'Facebook');
```

사전에 GA를 적용하고자 하는 웹사이트에 분류명 / 이벤트명 /라벨에 관한 분류와 명명 규칙을 정해 놓고 시작하는 것이 추후 데이터를 분석하기 수월.

- 더 자세한 내용은 공식 문서를 참고 - [Event Tracking](https://developers.google.com/analytics/devguides/collection/analyticsjs/events)




## 유용한 도구(Tools)

- 크롬확장- [Page Analytics (by Google)](https://chrome.google.com/webstore/detail/page-analytics-by-google/fnbdnhhicmebfgdgglcdacdapkcihcoh?utm_source=chrome-ntp-icon): 누적 된 GA 데이터를 바탕으로 웹사이트 위에서 각 링크들의 클릭율을 히트맵 형식으로 보여 주는 확장 프로그램.
- 크롬확장- [Google Analytics Debugger](https://chrome.google.com/webstore/detail/google-analytics-debugger/jnkmfdileelhofjcijamephohjechhna?utm_source=chrome-ntp-icon): 개발자 도구의 콘솔 창을 통해 GA 코드들의 적용 여부를 쉽게 디버그 할 수 있게 하는 확장 프로그램.
- 크롬확장- [WASP](https://chrome.google.com/webstore/detail/waspinspector-analytics-s/niaoghengfohplclhbjnjheodgkejpih?utm_source=chrome-ntp-icon): GA, GTM(Google Tag Manager), EC(Enhanced eCommerce) 디버깅을 위한 확장 프로그램.
- 크롬확장- [Google 웹로그 분석 차단](https://chrome.google.com/webstore/detail/google-analytics-opt-out/fllaojicojecljbmefodhfapmkghcbnh?utm_source=chrome-ntp-icon): 웹 사이트에 자주 접속하는 개발자나 업무 관계자들을 해당 플러그인을 설치하여 데이터 측정에서 제외를 권함.




# Google Tag Manager

기존 GA의 몇 가지 문제점. 

1. 코드를 공통화 하기 힘든 각각의 이벤트 추적을 위해 추적 코드를 계속 더 하다 보면 관리가 어려워짐.
2. 웹사이트에 이런 추적 코드를 포함 하기 위해서는 코딩에 대한 지식이 필요. 즉, 주로 데이터 분석과 사용은 기획/마케팅 분야에서 필요로 하는데, 매 Task 마다 개발팀에 요청을 하여 반영.
3. 직접 코드 레벨에서 구현 되기 때문에 혹시 모를 부작용(Side Effect).

이에 대한 대안으로 등장한 것이 구글태그매니저(이하 GFM). 

- GFM에 관한 개요 및 기본적인 사용법은 [Google Tag Manager Fundamentals](https://analyticsacademy.withgoogle.com/course/5/unit/1/lesson/1)을 참고 (한국어 CC 지원).



## GTM 적용

[공식 사이트](https://www.google.com/analytics/tag-manager/) 에 접속하여 추적 ID를 발급 받은 후, 적용하고자 하는 웹사이트에 스크립트 코드를 추가.

```javascript
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','{YOUR-TRACKING-ID}');</script>
// {YOUR-TRACKING-ID} 부분에 발급받은 추적ID 삽입
<!-- End Google Tag Manager -->
```

공식 사이트에서는 위 코드를 `<head>` 에서 가능한 높은 위치에 포함할 것을 권함.

```html
<!-- Google Tag Manager (noscript) -->
/* {YOUR-TRACKING-ID} 부분에 발급받은 추적ID 삽입 */
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id={YOUR-TRACKING-ID}"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
```

또한, 스크립트가 동작하지 않도록 설정한 사용자도 추적하기 위하여 위와 같은 코드도 `<body>`에 포함할 것을 권함(선택). GFM은 위의 코드를 적용한 후에는 GFM과 관련하여 더 이상 코드 레벨을 다룰 일이 없음.



## 페이지뷰 추적

- 변수 > 사용자정의변수 > 새로만들기

```
이름: trackingId
변수유형: 상수
값: GA에서 발급받은 추적 아이디를 입력
```

- 태그 > 새로만들기

```
이름: GA-모든페이지

- 태그구성
태그유형: 유니버설 애널리틱스
추적ID: 위에서 설정한 trackingId라는 상수를 선택
추적유형: 페이지뷰

- 트리거
트리거선택: All Pages
```

직접 코드를 수정하거나 추가하는 것이 아닌, GUI 환경에서몇 번의 클릭 과정으로 페이지뷰 추적이 가능. GA의 경우 코드레벨에서 `  ga('send', 'pageview');`  와 같은 코드를 매 페이지마다 추가 해야 했음..

- 클릭 이벤트를 추적하는 태그 구현은 다음 강좌 영상을 참고. [MeasureSchool. GFM 클릭 이벤트 추적 및 트리거 적용 강좌](https://measureschool.com/video/google-tag-manager-button-click-tracking/)




## 유용한 도구(Tools)

- 크롬확장- [Tag Assistant (by Google)](https://chrome.google.com/webstore/detail/tag-assistant-by-google/kejbdjndbnbjgmefkgdddjlbokphdefk?utm_source=chrome-ntp-icon): GFM이 정상적으로 동작하고 있는지 추적하기 위해 사용하는 크롬 확장 프로그램.
- GFM에서는 새로운 태그를 적용하기 전에 '미리보기 및 디버깅' 모드를 제공하는데,  uBlock, Adblock 과 같은 웹사이트 내 광고 차단 프로그램 실행시에는 정상적으로 동작하지 않음.




# GA를 통한 A/B테스트

A/B 테스트에 대한 개요는 아래를 참고.

- [Optimizely - A/B Testing](https://www.optimizely.com/ab-testing/)
- [Spoqa 기술블로그 - A/B Testing에 대한 기초적인 정보들](https://spoqa.github.io/2012/05/15/ab-testing-basic.html)

GA에서는 A/B테스트를 쉽게 진행할 수 있는 도구를 제공.



## A/B테스트 적용

[공식 사이트](https://www.google.com/analytics/) 에 접속하여 [보고] 탭에 진입 - 좌측 메뉴 중 [방문형태 > 실험] 메뉴에 진입하여 실험 만들기를 선택.

실험을 만드는 과정에서 설명이 워낙 잘 되어 있지만, 간략히 정리하자면

1. 원본페이지와 함께 테스트 할 페이지를 하나 더 생성 (A페이지 / B페이지).
2. 실험을 통한 GOAL을 명확하게 설정하는 것이 중요.
   - 기본옵션: 세션시간 / 이탈수 / 페이지뷰수
   - 좀 더 세부적인 측정을 위해서는 별도의 별도의 목표 수립 필요
3. 두 페이지에 모두 실험 코드(스크립트)를 삽입. 
   - 실험코드가 GA코드 다음에 포함되어 있음면 경고를 하는데, 이는 올바르지 않은 데이터가 누적되기 때문인 듯 함. 실험 대상 페이지는 실험 기간 동안 데이터 측정에서 제외하는 것이 좋을 듯.
   - 단순 A, B 페이지가 아니라 더 많은 샘플링도 가능.
4. 실험시작



위 과정을 거친 후 실험 대상 URL로 접근하면 자동으로 A페이지와 B페이지가 번걸아가며 등장한며, 실험 데이터들이 측정.



# 참고

### 도서

- [Google 구글 웹로그 분석|저자 미나가와 아키히로|역자 김성재|한빛미디어 |2016.01.01](http://book.naver.com/bookdb/book_detail.nhn?bid=10001329) GA 적용부터 수집 된 데이터를 분석하는 법을 간략하게 설명. 얇은 책인데도 불구하고, 관리하는 웹사이트에 처음 GA 적용을 위해 빠르게 흝어보기 좋은 책.
- [구글 애널리틱스로 모아보는 데이터|저자 다니엘 와이스버그|역자 송용근|에이콘출판 |2016.01.27](http://book.naver.com/bookdb/book_detail.nhn?bid=10144994) GA를 구현해야 하는 포지션 보다는 GA 데이터를 분석하는 포지션에서 볼 책. GA 데이터를 통합하고 관리하는 것에 관한 책.
- [구글 애널리틱스|저자 브라이언 클리프튼|역자 이세현, 박종채|에이콘출판 |2010.06.14](http://book.naver.com/bookdb/book_detail.nhn?bid=6287248) 600페이지가 넘는 두꺼운 책이라 가장 많은 내용을 포함하고 있긴 하지만, 2010년에 출간 된 책. 6년 사이에 GA가 많이 바뀌어 다소 차이가 있음. 하지만 GA에 대한 전체적인 개념을 좀 더 이해하고 싶다면 참고할만 함.

### 링크

- [Google Analytics 공식 문서](https://developers.google.com/analytics/)
- [Google Tag Manager Fundamentals](https://analyticsacademy.withgoogle.com/course/5/unit/1/lesson/1)
- [Jay Jin님 블로그. 구글 애널리틱스 설치부터 적용까지](https://milooy.wordpress.com/2016/01/14/google-analtyics-1-intro/)
- [MeasureSchool. GFM 클릭 이벤트 추적 및 트리거 적용 강좌](https://measureschool.com/video/google-tag-manager-button-click-tracking/)