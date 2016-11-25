# 나프콘 2016

- [http://onoffmix.com/event/82486](http://onoffmix.com/event/82486)
- 2016년 11월 25일 (금) 13:00 ~ 18:00
- 삼성SDS 서관

## 스칼라와 함수형 프로그래밍 기초 / 케빈리 님

Coursera의 Scala 강의를 통해 함수형프로그래밍에 관심을 가짐.

### Functional Programming

함수를 이용해 프로그래밍 하는 것

- 여기서 함수란? 입력 => 결과

### Why Need?

- 동시성: 멀티코어 환경
- 간결: 동일 입력 값에 대해 동일 결과 값을 반환
- 명확
- 테스트 하기 쉬운 코드
- 재밌다!

### 특징

- if문과 같은 statement를 변수에 대입 가능
- 함수우선

### 스칼라

- Object-Functional 
- Pure-bred Object-Oriented Language (자바와 같은 언어보다 더 순수한 객체지향)
  - 1, false 와 같은 기본형 값들도 모두 object로 취급
- Full-blown Functional Language



## 지적 프로그래밍을 위한 넓고 얕은 습관 / 서지연 님

### 지적프로그래밍이란?

아름다운 코드를 작성하고, 스스로 검증하고 성장하는 프로그래밍

- 당신이 반복하는 일은 당신을 규정한다. 위대함은 하나의 행위가 아니라 습관에서 온다. - 아리스토 텔레스

### 아름다운 코드 작성 습관

- 룰을 정하자 (코드 컨벤션, 팩키지 구조 등)
  - But, 최고의 룰은 없다
  - 그때는 맞고 지금은 틀리다
  - 상황에 맞게 적용
- 코드 리뷰를 하자
  - 자동화된 코드 리뷰 ([Sonar Qube](http://www.sonarqube.org/) 등)
  - 수동코드 리뷰 (Pull Request 등) - [Pull Approve](https://about.pullapprove.com/) 일정 횟수 이상의 리뷰 받아야 PR통과

### 자동검증 습관

- 협업시 코드에 문제가 있으면 팀원에게 영향을 끼침. CI를 통해 빌드 자동화
- [Codacy](https://www.codacy.com/), [Codecov](https://codecov.io/)

### 성장하는 습관

- Follow
  - Github, Twitter에서 고수 follow
  - 한국 깃헙 랭킹: [http://rankedin.kr](http://rankedin.kr)
  - 전세계 깃헙 랭킹: [https://github-ranking.com](https://github-ranking.com)
  - 컨퍼런스, 커뮤니티 참가, 참여, 만남
- Follow Me
  - 내가 익힌 것을 다른 사람에게 보여주기(공유하기)
  - 발표하기 *Don't be afraid to look like an idiot*

## 본격 서버리스 개발기 / 데니스 님

### 서버는 왜 Down 되나

- Bandwidth
- IO Load Error
- Unknown Error

### Cloud SLA

클라우드 서버 선택시 중요하게 고려해야 할 것 SLA (Service Level Agreement: 서비스 품질 보장 제도)

- SLA 99.54% = 한달에 약 24분 다운될 수 있다
- 크리티컬한 서비스를 운용시 이 시간은 심각한 문제

### 대안

- DNS 이중화: DNS도 다운될 수 있음
- CDN: 99.9%~100% SLA 보장
- 클라우드

### Devops의 문제

- SE의 부재
- 개발자가 서버까지



## 스타트업 1인 개발 극복기 & 함수형 언어 방황기 / 박미정 님

### 왜 함수형 언어를 고려했나

- 새로운 패러다임에 대한 성장욕구
- 높은 추상화
- 코드 신뢰성
- 사이드 이펙트가 적다
- 회사의 스케쥴은 다음 제품을 이후나 시간적 여유

### 하드웨어 스타트업의 소프트웨어 이야기

어느 정도 회사가 성장 후 합류. 문제가 많은 레거시에 당면.

- 레거시의 모든 것을 알고 있는 담당자의 부재
- iOS 1명, 안드로이드 1명, 펌웨어 1명 각개전투
- 프로세스의 부재

### 당면과제

- 서버 불안정
- 자동화 부재
- 개발환경 부재
- 프로세스 부재
- 사용중인 기능보다 미사용 기능이 더 많은 서버

