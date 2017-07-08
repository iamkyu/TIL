# 선택한 텍스트를 바로 구글 번역(영어->한국어)

on run {input}    return "https://translate.google.com/m/translate?sl=auto&tl=ko&text=" & (input as string)end run


# 이후 보관함 -> 인터넷 -> 웹 사이트 팝업을 선택 후 iPhone 크기로 지정