# github-with-ssh

```shell
$ ls -al ~/.ssh
# id_rsa, id_rsa.pub가 존재하지 않는다면 계속 진행

$ ssh-keygen -t rsa -C “your@email.com”
# Enter passphrase는 공백으로 스킵

$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/id_rsa

$ pbcopy < ~/.ssh/id_rsa.pub
# github > setting > SSH and GPG keys > SSH Kyes 등록

$ ssh -T git@github.com
# Hi라는 인사와 함께 성공 메시지
```

