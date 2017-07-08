# 텍스트 관련 스타일

> [Do it! HTML5+CSS3 웹표준의 정석](http://book.naver.com/bookdb/book_detail.nhn?bid=7309491) (고경희 저. 이지스퍼블리싱. 2013) 을 공부하며 책 내용 중 일부를 요약.

## 글꼴 지정

```html
p { font-family: "Times New Roman", Georgia, Serif; }
```

- `font-family` 속성은 웹 문서에 포함 된 텍스트를 ***사용자 시스템에 설치된 글꼴*** 로 브라우저에 표시. 지정한 글꼴이 없을 때를 대비해서 두번째, 세번째 글꼴까지 지정 가능.
- 폰트명에 공백이 있다면 따옴표(")로 감싸줘야 함.
- `font-family` 속성을 주는 경우, 마지막에는 기본적으로 내장되어 있을 폰트를 지정하는게 좋음.

## 웹폰트
`웹폰트` 사용자 시스템에 서비스 제공자가 원하는 서체가 없을 경우, 온라인의 특정 서버에 위치한 서체 파일을 내려 받아 표현할 수 있도록 하는 웹 전용 서체.

```html
/* style.css */
@font-face {
    font-family: MyHelvetica;
    src: local("Helvetica Neue"),
         local("HelveticaNeue-Regular"),
         url(/res/fonts/HelveticaNeue-Regular.ttf) format('truetype');
    font-style: normal;
    font-weight: normal
}
```
- `local` 사용자 시스템에서 해당 서체를 탐색.
- `url` 해당 서체를 로컬에서 찾지 못하면 서버에서 다운로드.

### 브라우저 호환성

|  | Firefox | Chrome | IE | Opera | Safari |
|--------|--------|--------|--------|--------|--------|
| Basic(EOT) | - | - | O | - | - |
| W.O.F.F | O | O | 9.0~ | O | O |

- Can I Use : EOT [http://caniuse.com/#feat=eot]() 
- Can I Use : WOFF [http://caniuse.com/#search=woff]()
- 좀 더 자세한 내용 [웹 폰트 파헤치기](http://www.beautifulcss.com/archives/431)

### CDN에서 웹 폰트 사용하기
컨텐츠 전송 네트워크 (Contents Delivery Network)를 통해 css를 import 하여 웹폰트 사용.

```html
<style>
@import url(http://fonts.googleapis.com/earlyaccess/notosanskr.css);

p { font-family: 'Noto Sans KR', sans-serif; }
</style>
```

## 폰트 사이즈
```html
font-size: 속성값;
```

### 상대크기로 설정: 각 단계는 1.2배씩 크기 차이 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_font-size&preval=medium)
- xx-small < x-small < small < medium(default) < large < x-large < xx-large
- `larger` / `smaller` 부모 요소의 크기를 기준으로 크기 조절.

### 크기 값 [[비교표]](http://kukie.net/resources/design/font_size.html)
| 단위 | 설명 |
|--------|--------|
| em | 해당 글꼴의 대문자 M의 너비를 기준으로 함 |
| ex | 해당 글꼴의 소문자 x의 높이를 기준으로 함 |
| px | 모니터에 따라 상대적인 크기 |
| pt | 문서에 사용하는 단위 |
| % | 부모 요소의 글꼴 기준으로 계산 |

### 그 외의 속성들
```html
font: font-size/line-height font-variant font-family ...
```
- font-style: `normal` / `italic` / `oblique` 
- font-variant: 작은대문자 `normal` / `small-caps` [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_font-variant)
- font-weight: 두께 `normal` / `bold` / `lighter` / `bolder` / `수치값`(100~900) [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_font-weight)

## 텍스트 스타일

```html
h1 { direction: 속성 }
```
- 텍스트의 쓰기 방향 지정: `ltr`, `rtl`
- 아랍어처럼 오->왼 으로 쓰는 언어를 위해 만들어진 속성으로 영어, 한글과 같이 왼->오 쓰는 언어는 단지 오른쪽 정렬.

```html
.txt-field { text-align: 속성 }
```
- 텍스트 정렬 방법 지정 `left`, `right`, `center`, `justify` [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_text-align)

```html
.txt-field { text-shadow: 횡값 종값 블러값 컬러값 }
```
- 텍스트에 그림자 효과 추가 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_text-shadow)
- `h-shadow` 가로 오프셋 (음수값:왼쪽 / 양수값:오른쪽)
- `v-shadow` 세로 오프셋 (음수값:위쪽 / 양수값:아래쪽)
- `blur` 번지는 정도

```html
.txt-field { text-overflow: 속성 }
```
- 박스 모델 안에 텍스트를 표시 할 때, 줄을 바꿀 수 없는 경우 넘치는 텍스트의 처리 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_text-overflow)

```html
.txt-field { text-decoration: 속성 }
```
- 텍스트에 밑줄을 긋거나 취소선을 표시 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_text-decoration)
- `none`, `underline`, `overline`, `line-through`

```html
.txt-field { text-indent: 수치값 }
```
- 문단의 첫 글자 들여쓰기 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_text-indent)

```html
.txt-field { text-transform: 속성 }
```
- 텍스트를 대문자 혹은 소문자로 변환 
- `capitalize`, `uppercase`, `lowercase`

```html
.txt-field { 
	letter-spacing: 수치값;
	word-spacing: 수치값;
	line-height: 수치값;
 }
```
- `letter-spacing` 글자 사이의 간격 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_letter-spacing)
- `word-spacing` 단어 사이의 간격 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_word-spacing)
- `line-height` 줄 간격 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_line-height)

```html
.txt-field { white-space: 속성 }
```
- 텍스트에 함께 입력된 공백의 처리 방식 결정 [[PLAY]](http://www.w3schools.com/cssref/playit.asp?filename=playcss_white-space)
- `normal` 연속하는 공백을 하나로 처리
- `nowrap` 연속하는 공백을 하나로 처리, 줄바꿈하지 않음
- `pre` 원본 그대로 표시
- `pre-line` 연속하는 공백을 하나로 처리, 줄바꿈
- `pre-wrap` 연속하는 공백을 원본 그대로 표시, 줄바꿈

## 목록 스타일
```
ul {
	list-style-type: 속성;
	list-style-positon: 속성;
	list-style-image: url(경로);
}
```

- `list-style-type`  리스트 불릿의 유형 설정
- `list-style-positon` 들여쓰기 효과. `inside` / `outside`
- `list-style-image` 기본 불릿 대신 별도 이미지 사용