# 멀티미디어 관련 태그

> [Do it! HTML5+CSS3 웹표준의 정석](http://book.naver.com/bookdb/book_detail.nhn?bid=7309491) (고경희 저. 이지스퍼블리싱. 2013) 을 공부하며 책 내용 중 일부를 요약.

## 이미지 태그
```html
<img src="home.png">
```
- `src` 속성: 이미지의 경로를 명시
	- 절대경로: `c:resources\images\home.png` 또는 `http://www.xxxx.com/images/home.png` 처럼 이미지의 완전한 경로를 명시
	- 상대경로: HTML 문서를 기준으로 경로를 인식
		- `home.png` HTML문서 위치의 같은 폴더에 이미지가 있을 때
		- `images/home.png` HTML문서 위치의 하위 폴더에 이미지가 있을 때
		- `../images/home.png` HTML문서 위치의 상위 폴더의 다른 하위 폴더에 이미지가 있을 때

- `alt` 속성: 이미지가 제대로 표시되지 않을 때, 대체 텍스트. 뿐만 아니라 시각 장애인이나 검색 엔진 노출을 위해서도 속성을 포함하는게 좋음

- `title` 속성: 이미지 위로 마우스 포인터를 가져갔을 때 나타는 설명 상자

```html
<figure>
<img src="home.png" alt="집">
<figcaption>우리집 사진입니다.</figcaption>
</figure>
```

- `<figure>` 태그를 사용해 캡션을 붙일 대상을 그룹핑. 하나 또는 여러 개의 미디어 태그들 또는 텍스트 단락이 될 수 있음. 하지만 `<figure>` 태그의 본래 목적은 해당 영역에 이미지나 다이어그램, 비디오 같은 것들이 있다고 브라우저에 알려주기 위한 것. 단순히 이미지를 묶기 위해서는 `<div>` 태그를 사용
- `<figcaption` 태그를 사용해 캡션을 명시

## 비디오 태그
#### HTML5 이전의 미디어 플레이
플레이 전에 어도비 플래쉬, 마이크로소프트 실버라이트, Active X 같은 플레이어를 설치 하는 과정을 거쳐야 함

- 보안에 취약
- 미디어 파일 형식에 따라 다른 플러그인 필요

```html
<embed src="intro.swf">
```

- `<embed>` 사용이 쉽지만 표준이 아님

```html
<object>
	<param name="filename" value="intro.wmv">
</object
```

- `<object>` 사용이 복잡하지만 일반적인 동영상, 플래시, 자바 애플릿 등 다양한 미디어 포함 가능

#### HTML5의 미디어 플레이
```html
<video src="intro.wmv" controls>
<audio src="intro.mp3" controls>
```
- `mp4`, `orv`, `webm` 비디오 포맷을 지원
- `mp3`, `oga`, `ogg` 오디오 포맷을 지원
- `controls` 옵션을 사용하면 비디오 컨트롤 막대가 나타남
- `preload` 재생 전에 미디어 파일을 모두 다운로드할 것인지를 지정
- `loop` 반복 재생 여부를 지정

```html
<video width="450" height="300" controls>
	<source src="welcome.ogv" type="video/ogg">
	<source src="welcome.mp4" type="video/mp4">
	<source src="welcome.webm" type="video/webm">
</video>
```
- 브라우저에 따라 지원하는 코덱이 다르기 때문에, 같은 영상을 다양한 포맷으로 업로드 하고 필요에 따라 사용