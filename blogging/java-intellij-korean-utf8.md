# IntelliJ 한글깨짐 해결

### 오류/예외 메세지
```
Eclipse IDE 에서는 문제가 없으나 IntelliJ IDE 에서는 자바(Java)단의 한글이 제대로 표시 되지 않음.
```

### 해결방법
IntelliJ 에서는 자바 웹 개발시에 체크해야 할 부분들이 꽤 있다.

- Settings > Editor > File Encodings 에서 `IED Encoding`, `Project Encoding`, `Default Encoding for properties files` 를 UTF-8로 변경.
- Tomcat 사용시 실행할 때 VM options 에 `-Dfile.encoding=UTF-8` 추가.
- Tomcat 디렉토리의 `conf > server.xml`에서 Connector 설정에 `URIEncoding="UTF-8` 속성을 추가.

위의 내용들을 모두 적용하였고, 뷰(view)단에서 한글이 깨진다면 아래의 태그를 명시하고, 뷰에서 서버단으로 파라미터를 전송할 때 한글이 깨진다면 `encodeURL()` 자바스크립트 함수를 사용해본다.
```
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
```

문제는 위의 내용을 모두 적용하고도 백단(Java)에서 계속 한글이 깨졌다. 혹시 몰라 컴파일 된 class 파일을 열어 보니 컴파일시에 한글이 모두 깨진 것이었다. 해결책은 찾았지만 사실 명확한 원인은 잘 모르겠다.

`Settings > Build, Execution, Deployment > Compiler > Java Compiler` 에서
`Additional command line parameters` 란에 `-encoding utf-8` 을 추가하고 새로 컴파일을 하면 한글이 정상적으로 처리되는 것을 확인할 수 있다.

### 덧+ 함께 보면 좋은 글
- [Naver D2 오영은님 - 한글 인코딩의 이해 1편: 한글 인코딩의 역사와 유니코드](http://d2.naver.com/helloworld/19187)
- [Naver D2 오영은님 - 한글 인코딩의 이해 2편: 유니코드와 Java를 이용한 한글 처리](http://d2.naver.com/helloworld/76650)