> Github 특정 Branch 로 커밋 -> 젠킨스에서 인식 후 Pull -> 빌드 -> 배포 -> Slack 알람

나는 해당 프로세스를 적용할 프로젝트 저장소에  `deploy` 라는 브랜치를 만들고, 해당 브랜치에 커밋(Commit)이 발생하면 자동으로 빌드 프로세스가 진행되도록 설정하였다.

먼저, 이를 위해 Jenkins 에 몇 가지 플러그인을 추가한다.

> 젠킨스관리 > 플러그인 관리 > 설치 가능

- GitHub plugin
- Slack Notification Plugin



> 젠킨스관리 > 시스템설정 

Github 메뉴에 Credentials 항목을 Add 한 다음 Github 계정을 등록

Manage hooks는 체크하지 않는다.

> https://my.slack.com/apps 

먼저 본인의 Slack Team을 생성한 후,  위 URL에 접속하여 Jenkins CI 를 추가한다. 추가한 후 토큰을 확인. 젠킨스관리>시스템설정 - Global Slack Notifier Settings 에 해당 팀, 토큰 정보를 입력한다.

> 자동으로 Github Hook을 할 item > 구성

- 소스코드 관리:  Github 저장소 주소, 브랜치명 등을 추가하고 시스템 설정에서 추가한 Credentials 정보를 선택.
- 빌드 유발: Build when a change is pushed to GitHub 을 체크.
- 빌드 후 조치: Slack Notifications 을 추가하고 설정.



> 본인 Github 저장소 > Settings > Webhooks 

Add webhook 을 선택하고 

본인 젠킨스 CI 주소/github-webhook/

secret은 젠킨스 로그인 비밀번호