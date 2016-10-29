# jquery-dialog-uncaught-error



(image1)



### 오류/예외 메세지

``` js
Uncaught Error : cannot call method on dialog prior to initialization; attempted to call method 'open'
```



### 해결방법

```
초기화(정의)되지 않는 다이얼로그를 open 하려고 해서 발생하는 문제이다.
jQuery 의 다이얼로그를 다루는 과정에서 위 에러를 만났다면, 
jQuery 관련 스크립트를 한 페이지 내에서 중복해서 로드하지 않는지 체크한다.
(레이아웃 관련 프레임워크(tiles 등)를 사용한다면 설정 확인)
```

웹페이지를에서 스크립트 에러를 추적하는 일은 너무나 어렵다. 한 페이지 내에서 여러 가지 스크립트를 포함해서 사용하고 여러 가지 이벤트들을 복잡하게 다루다 보면 같은 에러 메시지라도 다양한 원인이 있을 수 있고, 정확히 에러가 나는 지점을 파악하기가 힘들다. 이 내용은 jQuery 의 Dialog 를 다루다 발생한 문제이다.

```js
<div id="chartDetailDlg" title="">
    <div id="chartDetailDlgContent"></div>
</div>

<script type="text/javascript">
$(document).ready(function ($) { 
    // 다이얼로그 정의
    $("#chartDetailDlg").dialog({
        resizable   : false,
        autoOpen    : false,
        width       : 1200,
        height      : 650,
        modal       : true,
        close: function() {
            $("#chartDetailDlgContent").html("");
        }
    });
}); 

// 다이얼로그 로드
function openchartDetailDlg(url) {
    $("#chartDetailDlgContent").load(url);
    $("#chartDetailDlg").dialog("open");
}
</script>
```

HTML 페이지가 준비되고 나면 특정 디비전 태그(DIV)에 다이얼로그를 정의했다. 해당 과정이 끝나고 난 후 소스 코드를 보면 해당 디비전 태그를 둘러싸는 태그들이 추가로 생겨난 것을 확인할 수 있다.



(img2)



그리고 특정 버튼을 눌렀을 때(예를 들어 상세보기)를 눌렀을 때, `openchartDetailDlg()` 함수에 다이얼로그 위에 호출할 페이지의 url 을 전달하여 다이얼로그를 오픈한다. 여기서 발생한 문제는 첫번째 호출은 문제가 없었으나, 그 이후에 다시 `openchartDetailDlg()` 호출했을 때는 글의 서두에 명시한 에러가 발생하며 다이얼로그가 열리지 않는 것이다. 비슷한 기능이 구현 된 다른 페이지와 소스를 비교 해봐도 별반 차이가 없었고, 이것저것 바꿔 시도해봤지만 도무지 해결되지 않았다. 그러다 (역시) stackoverflow 에서 해결책을 찾았다.

- [stackoverflow: jquery ui Dialog cannot call methods on dialog prior to initialization](http://stackoverflow.com/questions/13520139/jquery-ui-dialog-cannot-call-methods-on-dialog-prior-to-initialization)

페이지가 준비 된 시점에 다이얼로그를 정의하는게 아니라, 다이얼로그를 호출하는 시점에 `openchartDetailDlg()` 다이얼로그를 정의하고 호출하는 것이다.

```js
function openchartDetailDlg(url) {
    var initOption = {
            resizable   : false,
            autoOpen    : false,
            width       : 1200,
            height      : 650,
            modal       : true,
            close: function() {
                $("#chartDetailDlgContent").html("");
            }
    };

    $("#chartDetailDlgContent").load(url);
    $("#chartDetailDlg").dialog(initOption).dialog("open");
}
```

위 방법으로 해결 하긴 했지만, 이미 다이얼로그를 구현 했던 모든 페이지들과 다른 방식으로 구현 된 점과 명확한 원인을 찾지 못한 점이 마음에 걸렸다. 그래서 계속해서 추적을 하였고 원인을 아래 소스에서 찾을 수 있었다.

(image3)

```js
$("#chartDetailDlgContent").load(url);
```

다이얼로그를 사용하는 jQuery 소스를 보면 호출할 페이지의 url을 전달한다. 그리고 호출한 페이지의 소스들이 `<div id='chartDetailDlgContent'>` 자식으로 붙는다. 위 이미지를 보면 해당 디비전 태그 아래에 수 많은 스크립트를 로드 하는 것을 알 수 있다. 이는 `tiles` 때문이다. 타일즈는 레이아웃을 편리하게 다루기 위한 프레임워크로 특정 url 패턴으로 페이지를 호출할 때 해당 페이지에 미리 정의한 페이지를 추가로 덧붙여 응답한다. 
해당 프로젝트에서는 공통적으로 사용하는 css 및 자바스크립트를 한페이지에서 모두 선언해두고(예를 들어  common.jsp), 각 페이지를 생성할 때 마다 사용할 리소스들을 정의하는게 아니라 공통 정의 된 페이지를 함께 로드해서 공통 리소스를 사용할 수 있도록 하는 것이다.

이 과정에서 jQuery 라이브러리가 새로 호출 됐고, 다이얼로그 초기화(initialization) 가 꼬이게 된 것이다(아주 정확한 동작 방식을 확인하지는 못했다). 따라서 tiles 설정을 통해 다이얼로그에 호출하는 페이지에는 jQuery 스크립트를 로드 하지 않도록 하였고 문제를 해결했다.

해당 에러를 추적하는 과정에서 느끼는 것은 역시 막 쓰지 말고 알고 쓰자이다. 유명한 프레임워크나 라이브러리가 그렇듯 jQuery도 API 문서가 잘 정의되어 있는데 내가 사전에 `dialog()` 함수에 관한 문서를 한번이라도 읽어보고 해당 함수가 동작할 때 DOM(Document Object Model) 이 어떤식으로 조작하는지 관심을 가졌었다면, 위와 같은 에러가 발생했을 때 좀 더 쉽게 범위를 좁혀가며 추적해 갈 수 있었을 것이다. 개발자를 편리하게 해주는 여러 도구들이 참으로 고맙긴 하지만 어떻게 구현된 것인지 고민하고 사용하는 습관을 기르자.

## 참고
- [jQuery API Doc: Dialog Widget](https://api.jqueryui.com/dialog/)

