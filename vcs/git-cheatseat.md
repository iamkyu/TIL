# git-cheatseat

자주 사용하는 git 커맨드 모음.



## push 명령시 default 브랜치 지정

- 현재 설정을 확인
  - nothing : Do not push anything
  - matching : Push all matching branches (default)
  - tracking : Push the current branch to whatever it is tracking
  - current : Push the current branch

```shell
$ git config --global push.default
```

- 현재 브랜치를 기본 브랜치로 지정

```shell
$ git config --global push.default current
```

