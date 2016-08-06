10장. 변형(transform)
===

`transform`: 웹 요소의 위치를 옮기거나 크기를 조절하고 회전, 왜곡시키는 것.

#### CSS3 이전

별도의 그래픽 툴(포토샵)을 이용해 수정해야 했지만, CSS3 에서는 스타일시트 소스만으로 다양한 변형을 주는 것이 가능.

`transform` 태그는 아직 완벽한 표준이 정해지지 않아서 각 브라우저를 대응하기 위해 앞에 브라우저 별 접두사를 붙여야 함.

- 웹 킷 기반 브라우저(크롬, 사파리): -webkit-transform

- 파이어폭스: -moz-transform

- 오페라: -o-transform

## transform

```html
trasform: 함수(값);

<!-- 값이 주어지지 않으면 0으로 간주 -->
transform:translate(x,y);

<!-- 값이 주어지지 않으면 같다고 간주 -->
transform:scale(x,y);

transform:rotate(angle);

<!-- 값이 주어지지 않으면 0으로 간주 -->
transform:skew(x-angle,y-angle);
```

| 축 | 음수 | 양수 |
|--------|--------|--------|
|x(수평)|왼쪽|오른쪽|
|y(수직)|위쪽|아래쪽|
|z(전후)|뒤쪽|앞쪽|


- CSS3이기 때문에 IE9 이하 미지원 [http://caniuse.com/#search=transform]() 

[예제] 
- [http://www.westciv.com/tools/transforms/index.html](http://www.westciv.com/tools/transforms/index.html)

## transition

한 스타일에서 > 다른 스타일로 바뀌는 효과. 플래시나 자바스크립트를 통하지 않고 CSS 만으로 애니메이션 효과. 트랜지션 속성 역시 `transform`과 마찬가지로 브라우저 별로 접두사를 붙여야 함.

```html
transition-property: 속성 값, 속성 값;
transition-duratin: 시간;
transition-timing-function: 속성;
```

[예제] 
- [http://css3.bradshawenterprises.com/transitions/](http://css3.bradshawenterprises.com/transitions/)

- 활용 [http://css3.bradshawenterprises.com/cfimg/](http://css3.bradshawenterprises.com/cfimg/)

## animation

transition 속성과 비슷하게 동작. 단, `@keyframe` 속성을 사용해 애니메이션을 정의할 수 있음.

```
animation-name: myani;
animation-duration: 시간;

@keyframes myani {
    0% { left: 10px; }
    100% { left: 500px; }

    from { left: 10px; }
    to {  left: 500px; }
}
```

[예제] 
- [http://css3.bradshawenterprises.com/animations/](http://css3.bradshawenterprises.com/animations/)