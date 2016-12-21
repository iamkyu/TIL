# git-cheatseat

자주 사용하는 git 커맨드 모음.



## git version upgrade

```shell
$ git --version
$ brew upgrade git
$ which git
# 경로가 /usr/bin/git인 경우,  Xcode와 함께 설치 된 Git을 사용. 따라서 참조 경로 변경
# 홈디렉토리에서 .bashrc 또는 .bash_profile

$ sudo vim .bash_profile
# 아래 path를 추가
# export PATH="/usr/local/bin:/usr/bin/git:/usr/bin:/usr/local/sbin:$PATH"

$ source .bash_profile
```



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

