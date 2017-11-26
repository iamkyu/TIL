# Microservice 구현을 위한 Container Native

- 행사소개 [https://www.meetup.com/Cloud-Native-Application/events/244676979/](https://www.meetup.com/Cloud-Native-Application/events/244676979/)
- 2017년 11월 18일 (토) 12:30~17:00
- 아셈타워 15층 한국 오라클

## 자바9
자바9 관련 섹션은 연사 사정으로 취소 됨.

오라클이 쿠버네티스 CNCF 프리미엄 스폰서

## Docker & Kubernetes 알아보기 / 황주필 컨설턴트, 오라클

> in 2000. LB - Server - Store 로 구성 된 Fixed architecture

- 컨테이너 기술의 대두
    - Microservice Architecture
    - DevOps
- static 한 인프라 환경으로는 감당이 안됨

### 컨테이너 기술의 핵심
- isolation
- resource manage

### Container Orchestration
- 관리해야 할 도커가 점점 많아지면서 통제가 어려움
- Container Orchestration 도구들이 등장

### Kubernetes (k8s)
- C.O. 솔루션들은 대체적으로 지원하는 기능을 비슷
    - 참고 슬라이드: [container-orchestration-wars](https://www.slideshare.net/KarlIsenberg/container-orchestration-wars)
- 활발한 커뮤니티, 오픈소스
- 인프라스트럭처에 대한 추상 계층이라고 생각하면 편함
    - 구체적인 구현, 예를 들어 어떤 로드밸런서를 사용할지, 저장소를 사용 명시만 하면 쿠버네티스가 알아서
- [Kubernetes Architecture](https://cdn.yongbok.net/ruo91/architecture/k8s/v1.1/kubernetes_architecture.png)

### Link
- [발표자료](https://www.slideshare.net/namoo4u/kubernetes-101-82568738)
- [Hands On](https://gitpitch.com/credemol/k8s_tutorial#/)
- [Hands On - Sample Code](https://github.com/credemol/k8s_tutorial/blob/master/PITCHME.md)
