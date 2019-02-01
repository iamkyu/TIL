# Too long HTTP Message
## 문제상황
서버 - 서버 간에 HTTP 통신을 함. 하나는 클라이언트, 하나는 서버 Role을 가짐. 그런데 애플리케이션 배포 직후에는 안정적이다. 대략 한 시간쯤 지나면 400 Bad Request 응답이 계속해서 발생하기 시작.
인프라스트럭쳐는 안정적이고 로그에 남은 요청 URI, HTTP 요청 헤더 모두 이상이 없음.
클라이언트 애플리케이션을 재 배포 시 한동안 안정적이다가 같은 패턴의 반복.

## 원인
요청 HTTP 메세지가 너무 길었음. HTTP 스펙에서 따로 길이 제한을 두진 않았지만 [Maximum on http header values? - Stack Overflow](https://stackoverflow.com/a/8623061)  질문의 답변을 보면 웹서버 별로 다음과 같은 헤더 필드 값의 길이 제한을 가짐.

- Apache 2.0, 2.2: 8K
- Nginx: 4K - 8K
- IIS: varies by version, 8K - 16K
- Tomcat: varies by version, 8K - 48K

## 5 Whys
### 요청 HTTP 메세지는 왜 길어졌나?

스프링 프레임웤에서 HTTP 요청을 하기 위해 `RestTemplate` 객체를 사용. 별도의 설정 없이 `RestTemplate` 인스턴스를 생성하면 생성자에서 `HttpMessageConverter`를 추가하는데 최소 5개의 컨버터가 추가 됨. 내 경우 다음 7개의 컨버터가 추가.

- `ByteArrayHttpMessageConverter`
- `StringHttpMessageConverter`
- `ResourceHttpMessageConverter`
- `SourceHttpMessageConverter`
- `AllEncompassingFormHttpMessageConverter`
- `Jaxb2RootElementHttpMessageConverter`
- `MappingJackson2HttpMessageConverter`

컨버터를 보고 HTTP 요청 헤더의 Accept 필드 값을 추가해서 메세지를 보냄.
```
Accept: text/plain, application/json, application/*+json, */*
```

이 Accept 헤더 필드가 길어졌음.


### Accept 헤더 필드는 왜 길어졌나?

디버깅과 몇가지 이유로 응답을 String 으로 파싱함. 그런데 인코딩이 깨지는 문제가 발생하여 다음과 같이 컨버터를 추가 함.

```java
restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(Charset.forName("UTF-8")));
```

문제는 `RestTemplate` 객체를 Bean 으로 등록하여 사용했는데, 기본적으로 싱글톤 객체임. 위 컨버터를 추가하는 코드는 Bean 을 가져다 쓰는쪽에서 매 요청마다 컨버터를 중복해서 추가함. 그에 따라 요청 헤더의 Accept 필드도 중복이 늘어남.

```
Accept: text/plain, text/plain, application/json, application/*+json, text/plain, text/plain, text/plain, text/plain, text/plain, text/plain, text/plain, text/plain, text/plain, text/plain, text/plain, */*, */*, */*, */*, */*, */*, */*, */*, */*, */*, */*, */*, */*]
```

- [SPR-16690 - Remove duplicate RestTemplate headers by geo-m · Pull Request #1776 · spring-projects/spring-framework · GitHub](https://github.com/spring-projects/spring-framework/pull/1776)

링크를 보면 Accept 헤더 필드가 중복 추가되는 것에 대해 이슈를 등록한 사람이 있고 수정도 되었음. 하지만 수정 코드는 스프링 프레임웤 v5.1.0. Release 에 포함 됨. 내가 사용하는 버전은 4.xx.

동료분이 4.3.x 버전에 수정 코드를 P.R 하셨음.
- https://github.com/spring-projects/spring-framework/pull/22320


### 왜 인코딩이 깨졌나?

String 으로 응답을 파싱하는 경우 `StringHttpMessageConverter` 를 사용함. 그런데 이 컨버터의 기본 캐릭터셋은 `ISO-8859-1` 으로 설정되어 있음.
이미 `StringHttpMessageConverter` 컨버터가 등록되어 있는걸 모르고 캐릭터셋을 `UTF-8`로 지정한 `StringHttpMessageConverter`를 추가하는 코드를 작성.


### 클라이언트 측에서 로깅을 했는데 왜 발견하지 못했나?

`RestTemplate` 이 실제로 보내는 요청이 아닌 그 직전의 헤더를 로깅했음. 실제로 `RestTemplate` 이 보내는 요청을 확인하려면 `ClientHttpRequestInterceptor` 를 구현하여 HTTP 요청을 로깅해야 함.


### 서버 측에서는 왜 감지하지 못했나?

서버 애플리케이션의 프레임워크 수준에서 다음과 같은 로그가 남았음.
```
[play-dev-mode-akka.actor.default-dispatcher-6] [akka.actor.ActorSystemImpl(play-dev-mode)] Illegal request, responding with status '400 Bad Request': HTTP header value exceeds the configured limit of 8192 characters
```

하지만 관련 로깅 수준을 Warning 으로 분류해두었기 때문에 Error 로그에 특별한 기록이 없었음. HTTP 400  Bad Request 가 발생하는 경우는 쿼리스트링이나 HTTP [엔티티](https://www.w3.org/Protocols/rfc2616/rfc2616-sec7.html) 에 실어오는 파라미터에서 원인을 찾는 경우가 많아 문제를 빠르게 파악할 수 없었음.



## 교훈
- 많은 경우 문제의 원인은 결국 코드 속에 있는데 생각보다 코드를 꼼꼼하게 안 읽음. 프레임웤에서 제공하는 기능, 라이브러리를 사용할 때 블랙박스로 두지 말고 어떻게 동작하는지 가볍게라도 읽어 보자.
- HTTP 메세지의 [엔티티](https://www.w3.org/Protocols/rfc2616/rfc2616-sec7.html) 에는 신경을 쓰는편인데, 헤더에는 별로 신경 쓰지 않는 경우가 많음.  올바른 메세지를 보내자.
