https://try.github.io/

`git init`


`git status`

untraced files = new file

`git add newfilename.txt`
`git add '*.txt'`
`git add octofamily/octodog.txt`

untraced file 이 Staging Area로 이동.



`git commit -m "Add cute octocat story"`


`git log`
commit number, author, date, message 를 확인

`git remote add origin https://github.com/try-git/try_git.git`

`git push -u origin master`

`git pull origin master`

`git diff HEAD`

`git diff -staged`

`git reset octofamily/octodog.txt`

`git checkout -- octocat.txt`

`git branch clean_up`

git checkout clean_up

git rm '*.txt'

git commit -m "Remove all the cats"

git checkout master

git merge clean_up

git branch -d clean_up

