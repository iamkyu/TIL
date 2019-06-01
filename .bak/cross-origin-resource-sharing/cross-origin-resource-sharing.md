# Cross-Origin Resource Sharing
마이크로 서비스에서 API 게이트웨이와 게이트웨이 뒤에 위치한 서비스가 Cross-Origin Resource Sharing (이하 CORS)에 대해 중복으로 처리 하면서 생긴 문제를 추적하는 과정에서 CORS에 대해 간략히 정리.

## Cross-Origin Resource Sharing
> 처음 전송되는 리소스의 도메인과 다른 도메인으로부터 리소스가 요청될 경우 해당 리소스는 **cross-origin HTTP 요청**에 의해 요청됩니다. 예를 들어, http://domain-a.com 으로부터 전송되는 HTML 페이지가 `<img> src` 속성을 통해 http://domain-b.com/image.jpg 를 요청하는 경우가 있습니다. 오늘날 많은 웹 페이지들은 CSS 스타일시트, 이미지, 그리고 스크립트와 같은 리소스들을 각각의 출처로부터 읽어옵니다. - [HTTP 접근 제어 (CORS) - HTTP | MDN](https://developer.mozilla.org/ko/docs/Web/HTTP/Access_control_CORS)

하지만 웹 브라우저에서는 자바스크립트 코드가 제공된 소스가 아닌 다른 곳으로 HTTP 요청 하는 것을 보안상 이유로 [Same-origin policy](https://developer.mozilla.org/ko/docs/Web/Security/Same-origin_policy) 적용. 즉, 제한함.

보통 정적파일서빙이나, API 등은 사용자에 제공되는 서비스의 도메인과 다른 도메인을 가짐. XHRHttpRequest를 통해 API를 호출하는 경우 위에 위에 언급한 정책으로 인해 응답을 처리하지 않음.

이를 간단히 해결하기 위해서는 서버에서 응답헤더에  `Access-Control-Allow-Origin` 를 추가하면 됨. 그럼 브라우저가 요청의 `Origin`과 일치하는지 확인하고 일치한다면 응답을 처리함.

- HTTP 요청
```
GET /greeting/ HTTP/1.1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1
Accept: application/json, text/plain, */*
Referer: http://foo.client.com/
Origin: http://foo.client.com
```

- HTTP 응답
```
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
Date: Wed, 20 Nov 2013 19:36:00 GMT
Server: Apache-Coyote/1.1
Content-Length: 35
Connection: keep-alive
Access-Control-Allow-Origin: http://foo.client.com

[response payload]
```

위 예제의 HTTP 응답의 `Access-Control-Allow-Origin` 헤더를 보면 값이 http://foo.client.com 로 되어 있음. 요청한 곳이 http://foo.client.com 이면 CORS를 허용한다는 의미임. 그럼 브라우저가 응답을 처리 함. `Access-Control-Allow-Origin: *` 인 경우 어떠한 도메인의 요청이더라도 CORS를 허용함.

좀 더 안전한 방법은 사전 요청([preflighted](https://spring.io/understanding/CORS#pre-flight-requests)) 방법이 있음. 


## HTTP 응답 헤더
CORS와 관련 HTTP 응답 헤더에는 다음과 같은 종류가 있음.

- Access-Control-Allow-Origin
- Access-Control-Expose-Headers
- Access-Control-Max-Age
- Access-Control-Allow-Credentials
- Access-Control-Allow-Methods
- Access-Control-Allow-Headers

각 헤더에 대한 설명은 [HTTP 접근 제어 (CORS) - HTTP | MDN](https://developer.mozilla.org/ko/docs/Web/HTTP/Access_control_CORS) 문서의 HTTP 응답헤더 절에 잘 정리되어 있음. 


## 중복된 헤더
```
Access-Control-Allow-Credentials: true
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://example.com
Access-Control-Allow-Origin: http://example.com
```

내가 개발 중 API에서 위와 같이 응답 헤더가 내려갔는데 파이어폭스에서 다음과 같은 메세지가 나타나며 응답이 차단 됨.

> 교차 출처 요청 차단: 동일 출처 정책으로 인해 http://api-example.com 에 있는 원격 자원을 차단했습니다. (원인: ‘Access-Control-Allow-Origin` CORS 헤더가 ‘http://example.com', ‘http://example.com'와 일치하지 않음).

이와 관련해서는 [CORS Spec 문서](https://www.w3.org/TR/cors/#resource-sharing-check-0)에서 사용자 에이전트가 Resource Sharing에 대해 어떻게 처리해야 하는지에 대해 명시한 부분을 참조할 수 있음.

> 1. If the response includes zero or more than one Access-Control-Allow-Origin header values, return fail and terminate this algorithm.


## 그 외
API Gateway로 Netflix의 Zuul을 사용한다면 설정을 통해 Downstream 서비스 특정 응답 헤더를 무시하도록 할 수 있음.
- [Ignore Headers](https://cloud.spring.io/spring-cloud-netflix/multi/multi__router_and_filter_zuul.html#_ignored_headers)
- [Zuul  Access-Control-* Headers are duplicated · Issue #1250 · spring-cloud/spring-cloud-netflix · GitHub](https://github.com/spring-cloud/spring-cloud-netflix/issues/1250)


# 참고
- [W3C Cross-Origin Resource Sharing](https://www.w3.org/TR/cors/)
- [HTTP 접근 제어 (CORS) - HTTP | MDN](https://developer.mozilla.org/ko/docs/Web/HTTP/Access_control_CORS)
- [Server-Side Access Control (CORS) - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Server-Side_Access_Control)
- [Cross-origin resource sharing - Wikipedia](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing#Preflight_example)
- [Same-origin policy - Wikipedia](https://en.wikipedia.org/wiki/Same-origin_policy)
- [Spring | Understanding CORS](https://spring.io/understanding/CORS#pre-flight-requests)
