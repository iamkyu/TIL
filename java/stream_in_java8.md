# Stream() in Java8

지난 4월 부터 참석하고 있는 [2016년 상반기 자바카페 스터디](http://onoffmix.com/event/63992) 의 4회차 모임에 다녀왔다. 이 스터디는 강의형 스터디인데 다루는 주제는 아래와 같다.

- Java8 람다 & Stream API
- JavaScript 함수 & 클로저
- GoF 디자인패턴

한 주 마다 번갈아가며 배우니 심도 있게 공부하긴 힘들긴 하지만 어차피 스터디는 약간의 의지만 북돋아줄 뿐이고 결국 공부를 하냐 마나는 본인 몫이라고 생각하기에 그리 나쁘지는 않다.

Java8 이 2014년 3월에 릴리즈 되었으니 벌써 1년이 훌쩍 넘었다. 자바8에서 많은 부분들이 변했지만 그 중 람다와 스트림이 가장 흥미롭고, 함수형 프로그래밍이라는 패러다임이 자바에 스며들고 있다는 것은 앞으로 자바가 어떻게 변해가게 될 지 기대를 품게 한다.<br>
하지만 자바8을 기반으로 자바를 배우기 시작했고, 자바8을 기반으로 현업의 프로젝트를 진행하면서도 함수형 프로그래밍은 고사하고 람다와 스트림을 접해 보지도 못했다. 물론 객체지향의 개념도 잘 이해한 것은 아니지만 새로운 기능은 꼭 써봐야 하는 성격이라  궁금했다. 왜 이렇게 다들 함수형 프로그래밍, 함수형 프로그래밍 그러는거야?

처음에 스터디에서 람다에 대해서 들었을 땐 '대체 뭐라는거야...' 라는 생각을 하다가 이번에 스트림 API에 관해 듣고 와서는 그래도 '오호라..' 하는 생각이 들고 쥐꼬리만큼 이해할까 말까 해서 관련 내용을 조금 정리해두려 한다.

## Stream 개요
아래와 같은 요구 사항이 있다고 해보자.

- 칼로리가 400 이상인 음식을 선별
- 칼로리를 내림차순으로 정렬
- 상위 칼로리 음식 3개만을 출력


자바8 이하에서 요구 사항을 구현한 소스 코드의 예는 다음과 같다.

```
List<Dish> lowCaloricDishes = new ArrayList<>();

// 칼로리가 400이하인 메뉴만 가지고 온다.
for (Dish dish : menuList) {
    if (dish.getCalories() >= 400) {
        lowCaloricDishes.add(dish);
    }
}

// 칼로리 순으로 정렬한다
Collections.sort(lowCaloricDishes, new Comparator<Dish>() {
    @Override
    public int compare(Dish o1, Dish o2) {
        return Integer.compare(o1.getCalories(), o2.getCalories());
    }
});

// 요리 이름만 가지고 온다.
List<String> lowCaloricDishesName = new ArrayList<>();
for(Dish lowCaloricdish : lowCaloricDishes){
    lowCaloricDishesName.add(lowCaloricdish.getName());
}

// 상위 칼로리 음식 3개를 출력
List<String> lowCaloricLimit3DishesName = lowCaloricDishesName.subList(0,3);
System.out.println(lowCaloricLimit3DishesName);
```

위의 코드를 자바 8의 `Stream` API를 사용해서 나타낸다면

```
List<String> lowCaloricDishesName = menu.stream()
	.filter(d -> d.getCalories() <400)
	.sorted(comparing(Dish::getCalories))
	.map(Dish::getName)
	.colloct(toList());
	
System.out.println(lowCaloricDishesName);

```