# HTML5와 시맨틱 태그

> [Do it! HTML5+CSS3 웹표준의 정석](http://book.naver.com/bookdb/book_detail.nhn?bid=7309491) (고경희 저. 이지스퍼블리싱. 2013) 을 공부하며 책 내용 중 일부를 요약.

## HTML5 이전의 문서 구조
`<div>` 태그를 활용하여 레이아웃을 구성. 해당 태그의 id로 문서의 영역을 알려줌. 하지만 강제적인 룰이 아니고 암묵적인 룰이기 때문에 개발자에 따라 다른 id를 지정할 수도 있음.

``` html
<!DOCTYPE html>
<html>
<head>
	<title>HTML5 이전의 문서 구조</title>
</head>
<body>
	<div id="header">
		Header
	</div>
	<div id="content">
		Content
	</div>
	<div id="footer">
		Footer
	</div>
</body>
</html>
```

## HTML5의 문서 구조
웹 문서의 레이아웃을 표준화 하고 레이아수을 만들 때 사용하는 주요 태그를 규약. 이런 요소들을 시맨틱 요소라고 지칭.

> Semantic : (주로 명사 앞에 씀) 의미의, 의미론적인

``` html
<!DOCTYPE html>
<html>
<head>
	<title>HTML5의 문서 구조</title>
</head>
<body>
	<header>
		Header
	</header>
	<section>
		Content
	</section>
	<footer>
		Footer
	</footer>
</body>
</html>
```

### 시맨틱 태그의 장점
- 유지보수의 용이: 각 레이아웃의 태그가 정해져 있기 때문에 추후 쉽게 해당 부분을 찾을 수 있음.
- 웹 접근성: 시각 장애인과 같은 사용자가 사이트를 이용할 때 화면 판독기 같은 프로그램을 사용한다면 시맨틱 태그를 통해 정확하게 화면 정보를 전달 가능.

### 시맨틱 태그의 브라우저 호환성
> [시맨틱 태그 브라우저 호환성 매트릭스](http://caniuse.com/#search=semantic)

IE8이하에서는 시맨틱 태그를 전혀 지원하지 않기 때문에 추가적인 조치가 필요.

- [The HTML5 Shiv](https://github.com/afarkas/html5shiv)


위의 자바스크립트를 사용하여 IE8이하의 브라우저에도 대응 가능.

#### 브라우저 파편화 대응
시맨틱 태그를 지원하긴 하지만 특정 기능들이 타 브라우저와 다르게 동작할 때는 아래의 페이지를 참고하여 크로스 브라우징을 위한 폴리필이나 심, 폴백을 찾는다.

- [HTML5 Cross Browser Polyfills](https://github.com/Modernizr/Modernizr/wiki/HTML5-Cross-browser-Polyfills)


## 시맨틱 태그들
시맨틱 태그들은 모두 HTML 문서의 `<body>` 요소 안에 포함 됨.

```
<header></header>
```
- 특정 부분의 머리말. 사이트 전체의 제목 부분이 될 수도 있고, 특정 섹션의 제목이 될 수도 있음

```
<nav></nav>
```
- 사이트 안의 다른 위치로 연결하는 링크들의 모임인 네비게이션(메뉴)를 나타냄. 

```
<h1>가장 큰 제목</h1>
<h2>h1보다 작은 제목</h2>
<h3>h2보다 작은 제목</h3>
<h4>h3보다 작은 제목</h4>
<h5>h4보다 작은 제목</h5>
<h6>가장 작은 제목</h6>
```
- 각 컨텐츠 영역에서 제목을 표시할 때 사용하는 태그.

```
<iframe src=""></iframe>
```
- 웹 문서 안에 다른 웹 문서를 가져와 표시하는 태그(인라인 프레임).

```
<section</section>
```
- 콘텐츠 영역을 나태내는 태그.
- `<article>` 태그와 용도가 혼돈되나, `<section>` 태그는 문맥의 흐름 중 주제별로 컨텐츠를 묶을 때 사용. (컨텐츠 기준이라기보다는 헤더와 섹션, 푸터를 기능을 기준으로 구분하는 용도)

```
<article></acrtice>
```
- 웹상의 실제 내용을 나타내는 태그. 
- `<section>` 태그와 용도가 혼돈되나, 완전히 하나의 컨텐츠가 된다면 `<article` 태그를 사용.

```
<aside></aside>
```
- 본문 내용 외에 주변에 표시되는 기타 내용을 나타내는 태그.

```
<footer></footer>
```
- 푸터를 나타내는 태그.

```
<address></address>
```
- 주로 `<footer>`태그 안에 사용되며 웹 페이지 제작자의 이름이나 피드백을 위한 연락처 정보를 나타내는데 사용.
