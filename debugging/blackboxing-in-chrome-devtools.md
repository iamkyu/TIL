# blackboxing -in-chrome-devtools

크롬 브라우저의 개발자도구(Developer Tools)에서 디버깅을 스텝(Step) 단위로 진행할 때, 의존하는 자바스크립트까지 모두 추적하여 따라 들어가기 때문에 불 필요하게 코드를 많이 읽어야 한다. 이에 특정 패턴을 Blackbox 리스트에 추가하여 패턴에 일치하는 리소스들은 따라 들어가지 않도록 설정할 수 있다.

아래는 내가 블랙리스트에 추가하는 패턴들.

```
/underscore\.js$
jquery.js
\.min\.js$
```

- 공식문서 [https://developers.google.com/web/tools/chrome-devtools/javascript/step-code#blackbox_third-party_code](https://developers.google.com/web/tools/chrome-devtools/javascript/step-code#blackbox_third-party_code)