# Eclipse Setup

- `Preferences > Validation` 에서 아래 항목들의 유효성 검사를 Build 시 제외
	- Application Client Validator
	- Client-side Javascript Validator 
	- HTML Syntax Validator
	- JSP Content Validator
	- JSP Syntax Validator
	- WSDL Validator
	- XML Schema Validator
	- XML Validator

- `Preferences > General > Editors > Text Editors > Spelling` 메뉴 에서 `Enable spell checking`을 해제

- `Preferences > Java > Folding` 메뉴 에서 `Enable folding`을 해제

- `Preferences > Java > Editor Content Assist` 메뉴 에서 `Enable auto activation`을 해제

- `Markers`탭에서 `Configure Contents > Show items that match any configuration chcked below` 선택 후 Scope를 `On any element in same project`로 설정

- `검색`창을 열어 `Customize`

- 메이븐 루트 프로젝트의 `Properties > Resource > Resource Filters`에서 아래와 같이 설정
	- Filter type: Exclude all
	- Applies to: Folders (체크박스선택 All children(reucursive)
	- Filter Details: Name과 matches 선택 후 텍스트 필드에 `target` 입력

- Debug 퍼스펙티브에서 각 레이어의 뷰 크기 조정