# Apdex
API 응답시간이 얼마나 빠른지, 쿼리가 얼마만에 수행되는지 각각의 성능 수치를 측정하고 수집할 수 있지만 하나의 애플리케이션, 즉 하나의 서비스가 비즈니스 관점에서 얼마나 잘 작동하고 있는지에 대한 통찰력을 얻기 어려움.
이에 대한 대안으로 표준화 된 방법을 정의한 것이 Apdex임.

> Apdex is a numerical measure of user satisfaction with the performance of enterprise applications.
> Apdex 는 엔터프라이즈 애플리케이션 성능에 대한 사용자 만족도를 수치화 한 것.

Apdex 는 많은 측정 값을 바탕으로 0 또는 1의 숫자로 변환함. 0 은 만족하는 사용자가 없는 것이고 1 은 모든 사용자가 만족함을 의미함.

Apdex 는 시스템 내에서 사용자와 시스템간 상호작용 할 때의 응답성 (responsiveness) 을 측정하여 최종적인 0 또는 1 의 숫자를 구함. 0 은 만족하는 사용자가 없는 것이고 1 은 모든 사용자가 만족함을 의미함.

## Apdex 측정
![New Relic 의 Apdex  score 계산](https://user-images.githubusercontent.com/13076271/54065945-e6f08600-426a-11e9-9ec4-4077f94eb6de.png)
> 출처: https://docs.newrelic.com/docs/apm/new-relic-apm/apdex/apdex-measure-user-satisfaction

응답성은 크게 세 그룹으로 구분. 임계 값 `T`를 3초라고 했을 때
- Satisfied: 3초 이하
- Tolerated: Satisfied 와 Frustrated 사이
- Frustrated: `4T` 즉, 12초를 초과할 때

100개의 샘플이 있고 그 중, Satisfied 이 60, Tolerated 은 30, Frustrated 가 10 이라고 했을 때 다음과 같이 계산할 수 있음.

> (60 + (30/2)) / 100 = 0.75

## 참고문서
- [Apdex.org](http://apdex.org/overview.html)
- [New Relic - Apdex: Measure user satisfaction](https://docs.newrelic.com/docs/apm/new-relic-apm/apdex/apdex-measure-user-satisfaction)
