#!/bin/bash -e
commit_message="$1"
git pull origin master
git add . -A
git commit -m "$commit_message"
git push


# 파일 권한은 chmod u+x togithub.sh  설정
# 사용방법: 커맨드라인에서 다음 명령어 입력
# $ ./togithub "Your commit message"
