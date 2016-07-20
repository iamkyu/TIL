# 16-05-21 스터디_JS Function & Closure


## Function

- 호출되거나 실행될 수 있는 자바스크립트 코드 블록
- 일급 객체 (First Class Citizen)
	- 변수나 데이터 구조 안에 담을 수 있다
	- 파라미터로 전달할 수 있다.
	- 반환값으로 사용할 수 있다.

#### 함수 VS 메서드
`console.dir()` 은 함수인가 메서드인가? -> 메서드. Dot(.) 으로 접근하기 때문.

- 함수를 객체의 속성에 저장하는 경우를 메서드라 함.


#### 호이스팅
`function` 키워드와 `var` 키워드 순으로 먼저 읽어들임.<br>
`function` 키워드는 호이스팅이 일어나지만 `var` 키워드는 일어나지 않음.

```
console.log(a); 
function a() {};
var a = 1;
console.log(a);

// 출력
function a(){}
1
```

```
console.log(a); 
var a = 1;
function a() {};
console.log(a);

// 출력
function a(){}
1
```

```
console.log(a); 
var a = 1;
var a = function(){};
console.log(a);

// 출력
undefiend
function(){}
```

#### 함수전달인자 (arguments)
함수 선언부에 매개변수를 명시하지 않아도 가변전달인자로 전달 받을 수 있음.

```
function dirArgu() {
	console.dir(arguments);
}

dirArgu(123);
dirArgu(12345);
```

## Prototype
`프로토타입` 은 값이 아니라 참조(링크). 

## Scope
자바스크립트에서 유효범위는 `블록 단위`가 아니라 `함수 단위`

- ex) `if`문 안에 선언 된 변수의 유효 범위가 `if` 안으로 한정되지 않음.

## Closure
함수를 선언할 때 만들어지는 유효 범위. 함수는 클로저를 통해서 자신이 선언될 때 속해 있던 유효범위 내의 변수와 함수를 사용할 수 있고, 변수의 경우 그 값을 변경할 수도 있다.
**흥미로운 경우는 함수를 선언한 후에 언제든지, 심지어 함수가 속해 있던 유효 범위가 사라진 후에도 그 함수를 호출 할 수 있는 경우가 있다.**

```
// 간단한클로저

var outerValue = 'outerValue';

function outerFunction() {
	console.log(outerValue == 'outerValue');
}

outerFunction();
```

## 재귀

```
var factorial = function recurs(x) {
	if (x <= 1) return 1;
	else return x * recurs(x-1);
}

factorial(5);
```
익명 함수에 이름을 주면 함수 내에서 사용 가능