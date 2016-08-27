# GDG WebTech Workshop: 측정하는 놈, 로딩하는 놈, 그리는 놈

- [http://onoffmix.com/event/75765]()


- 2016년 8월 27일 (토) 15시 30분 ~ 18시 30분
- 우아한형제들 키친



## 오늘의 AGENDA

- 렌더링 성능 인자 이해하기
- 인스턴트 로딩과 오프라인 웹앱
- 측정




> 발표자료 [http://www.slideshare.net/cwdoh/gdg-webtech-1]()




## 하드웨어 가속

- 주방장 혼자 VS 주방장 + 보조들
- Software rendering VS Software rendering + Hardware rendering
- 소프트웨어랜더링 실행성능 = 주요기능의수행시간 + 그래픽스 출력시간



##### CPU와 GPU 이슈

1. 서로 다른 메모리 공간 사용 (CPU-> Main Memory / GPU -> Video Memory)
   - 통신이 필요 (BUS)
2. 메모리 한계 (유한한 자원)
3. 데이터의 잦은 변경 (1번의 과정 재필요)



##### GPU (Graphics Processing Unit))

- 정점(Vertex) & 다각형(Polygon)
- 텍스쳐 & 텍스쳐매핑
- 트랜스폼



잘하는 것: 수신된 데이터로 무언가를 그리는 것 (출력, 회전, 확대, 축소, 기울임 등)

못하는 것: 비디오메모리로의 전송 (느림) + CPU의 처리 시간



화면에 나타나는 모든 것은 이미지(=랜더링 대상)



## 크롬의 렌더링



##### Reflow (= Layout = Layouting)

- DOM 노드가 가지는 레이아웃 정보가 바뀌면 재배치를 위한 계산 필요 (CPU 부하)

##### Repaint

- 레이아웃 내 컨텐츠가 변경 시 텍스쳐를 새로 생성



## Service Worker

- [Service Worker 101 (한국어)](http://www.slideshare.net/cwdoh/service-worker-101?qid=da332d77-d011-4f2e-8ed9-9fccd2fde38a&v=&b=&from_search=2)

