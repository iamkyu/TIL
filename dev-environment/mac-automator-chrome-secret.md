# 크롬을 시크릿 모드로 실행하는 스크립트

if application "Google Chrome" is running then
    tell application "Google Chrome" to make new window with properties {mode:"incognito"}
else
    do shell script "open -a /Applications/Google\\ Chrome.app --args --incognito"
end if

