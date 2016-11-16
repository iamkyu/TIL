# A better git log

한 줄씩 차지하는 git 히스토리 출력

```shell
$ git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```



### alias로 등록

```shell
$ git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

```shell
$ git lg
```



변경 된 라인 단위로 출력

```shell
$ git lg -p
```

