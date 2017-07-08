# Github Pages 에 Custom Domain 설정

> GitHub Pages is a static site hosting service.

Git 원격 저장소 공간을 제공하는 [github.com](https://github.com) 에 `사용자명.github.io ` 의 저장소(repository)를 만든다. 
그럼 Github 에서 제공하는 Pages 를 사용할 준비는 끝이다. 이 저장소에 코드를 올리면 저장소 이름과 같은 이름으로 무료 호스팅을 해준다. 

하지만 `username.github.io` 형태의 도메인이 마음에 들지 않아 멋진 도메인을 따로 구입했다. 이 도메인을 Github Pages 에 적용하기 위해서 몇가지 사소한 수정만 하면 된다.

내가 도메인을 구입한 [godaddy.com](https://kr.godaddy.com/) 을 기준으로 말하자면, DNS 관리 페이지에 접속 후 아래 내용을 추가한다.
- 유형 `A` | 호스트 `192.30.252.153` 또는 `192.30.252.154` | 지시방향은  `본인 도메인주소(e.g. namkyujin.com)`
- 유형 `CNAME` | 호스트 `www` | 지시방향은  `Github Pages 도메인 (e.g. https://iamkyu.github.io)`

이제 호스팅 업체 에서의 설정의 마쳤고 Gihub Pages 저장소로 이동한다. 설정 메뉴에 진입한 후 스크롤을 조금 내리면 `Custom Domain` 부분이 있다. 이곳에 직접 구입한 도메인 주소를 입력한다.

### 참고
- [What is GitHub Pages?](https://help.github.com/articles/what-is-github-pages/)
- [Using a custom domain with GitHub Pages](https://help.github.com/articles/using-a-custom-domain-with-github-pages/)