# 폼 관련 태그

> [Do it! HTML5+CSS3 웹표준의 정석](http://book.naver.com/bookdb/book_detail.nhn?bid=7309491) (고경희 저. 이지스퍼블리싱. 2013) 을 공부하며 책 내용 중 일부를 요약.

## form 태그
```html
<form>
/* 폼 요소들 */
</form>
```
- `method` 폼을 서버로 전송할 방식. GET 방식과 POST 방식이 있지만, 보통 `<form>` 태그 안에서는 POST 형식으로 전달한다
- `action` 폼을 전송할 서버 쪽의 스크립트 파일을 지정

```html
<fieldset>
<legend>로그인 정보</legend>
<ul>
<li>아이디: <input type="text" id="user_id"></li>
<li>비밀번호: <input type="password" id="user_pw"></li>
</ul>
</fieldset>
<fieldset>
<input type="submit" value="가입하기">
</fieldset>
```

- `<fieldset>` 폼 요소들을 그룹으로 묶어 주는 태그
- `<legend>` 태그로 그룹의 제목을 명시

```html
<form>
<fieldset>
<legend>로그인 정보</legend>
<ul>
<li>
	<label for="user_id">아이디(6자이상)</label>
	<input type="text" id="user_id">
</li>
<li>
	<label for="user_pw">비밀번호</label>
	<input type="password" id="user_pw">
</li>
</ul>
</fieldset>
<fieldset>
<input type="submit" value="가입하기">
</fieldset>
</form>
```

- `<label>` 태그를 사용하거나 사용하지 않아도 화면에 보이는 모습은 같지만, 시각 장애인들이 폼을 사용할 때 폼의 캡션 부분과 입력 부분을 정확하게 연결할 수 있음. 브라우저에서도 `<label>`과 `<input>`을 한 묶음으로 인식
- `for` 속성을 사용하면 `<label>` 태그와 `<input>` 태그가 멀리 떨어져 있어도 무관. 또는 `<label>아이디(6자이상) <input type="text" id="user_id"></label>` 와 같은 방식으로 감싸줌

```html
<li>
	<label><input type="radio" name="chkitem" value="item1">옵션1</label>
</li>
```

- 라디오버튼과 체크박스 사용시에도 `<label>` 태그를 활용하면 텍스트를 선택해도 체크가 발생하도록 처리 가능

## input 태그
```html
<input type="유형" [속성="속성 값"]>
```

- `readonly` 속성은 해당 필드를 읽기 전용으로 바꿈
- `placeholder` 해당 필드에 hint 를 표시
- `autofocus` 페이지를 불러오자마자 커서를 위치할 필드를 지정
- `autocomplete` 웹 브라우저의 자동 완성 기능을 제어
- `min`, `max`, `maxLength`, `step` 필드의 최소값, 최대값 등을 지정
- `required` 필수 필드 지정

[*]표시는 `html5` 부터 지원. 더 많은 input type의 유형들 [http://www.w3schools.com/tags/att_input_type.asp]()

| type 속성 | 설명 |
|--------|--------|
|hidden|사용자에게 보이지 않는 값|
|text|한줄 텍스트 입력 필드|
|*search|검색 상자 필드|
|tel|전화번호 입력 필드|
|url|URL 주소 입력 필드|
|*email|메일 주소 입력 필드|
|password|비밀번호 입력 필드|
|*number|숫자를 조절할 수 있는 화살표|
|*range|숫자를 조절할 수 있는 슬라이드 막대|
|*color|색상 표|
|checkbox|주어진 항목에서 2개 이상 선택 가능한 체크박스|
|radio|주어진 항목에서 1개만 선택할 수 있는 라디오버튼|
|*datetime|국제 표준시로 날짜와 시간을 넣음|
|*datetime-local|사용자 지역을 기준으로 날짜와 시간을 넣음|
|*date|사용자 지역을 기준으로 날짜(년, 월, 일)을 넣음|
|*month|사용자 지역을 기준으로 날짜(년, 월)을 넣음|
|*week|사용자 지역을 기준으로 날짜(년, 주)을 넣음|
|*time|사용자 지역을 기준으로 날짜(시, 분, 초, 분할초)을 넣음|
|button|버튼을 넣음|
|file|파일을 첨부할 수 있는 버튼을 넣음|
|submit|서버 전송|
|image|이미지를 넣음|
|reset|리셋|

## 선택 리스트들
```html
<select>
  <optgroup label="Swedish Cars">
    <option value="volvo">Volvo</option>
    <option value="saab">Saab</option>
  </optgroup>
  <optgroup label="German Cars">
    <option value="mercedes">Mercedes</option>
    <option value="audi">Audi</option>
  </optgroup>
</select>
```

- `size` 속성을 지정하면 한번에 몇 개의 항목을 표시할지 설정 가능 (기본 1개)
- `multiple` 속성을 통해 여러 항목을 선택 가능하도록 설정 가능
- `<optgroup>` 태그를 이용하여 드롭다운 목록을 그룹화

```html
<input list="browsers">
<datalist id="browsers">
  <option value="Internet Explorer">
  <option value="Firefox">
  <option value="Chrome">
  <option value="Opera">
  <option value="Safari">
</datalist>
```

- `<datalist>` 태그는 텍스트 필드에 입력할 수 있는 값을 목록 형태로 제시하여 값을 선택하도록 함

## 그 외 폼 요소들
- `<textarea>`
- `<button>`
- `<output>`
- `<progress>`
- `<mether>`