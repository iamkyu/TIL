# Sublime Text Setup (Base Ver. ST3)

- `View > Show Console` 메뉴에서 `Package Control` 설치를 위한 [import 소스](https://packagecontrol.io/installation) 추가

- `Package Control > Install Package` 에서 추가할 패키지들
	- Material Theme
	- Emmet
	- BracketHighlighter
	- SideBarEnhancements
	- SublimeCodeIntel
	- HTML-CSS-JS Prettify
	- AutoBackups
    - MarkdownEditing
    - OmniMarkupPreviewer

- `Preferences > Settings > User`에서 아래의 세팅 추가

```json
{
    "always_show_minimap_viewport": true,
    "bold_folder_labels": true,
    "color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme",
    "font_size": 12,
    "ignored_packages":
    [
        "Vintage"
    ],
    "indent_guide_options":
    [
        "draw_normal",
        "draw_active"
    ],
    "line_padding_bottom": 3,
    "line_padding_top": 3,
    "overlay_scroll_bars": "enabled",
    "theme": "Material-Theme.sublime-theme"
}
```

- Afterglow 테마로 설치하기 `Install Package > Search Theme - Afterglow`

```json
{
	"always_show_minimap_viewport": true,
	"bold_folder_labels": true,

    "theme": "Afterglow-blue.sublime-theme",
    "color_scheme": "Packages/Theme - Afterglow/Afterglow.tmTheme",
    "folder_no_icon": true,
    "tabs_small": true,
    "draw_white_space": "all",

	"font_size": 12,
	"ignored_packages":
	[
		"Vintage"
	],
	"indent_guide_options":
	[
		"draw_normal",
		"draw_active"
	],
	"line_padding_bottom": 3,
	"line_padding_top": 3,
	"overlay_scroll_bars": "enabled",

	// set vertical rulers in specified columns.
    // Use "rulers": [80] for just one ruler
    // default value is []
    "rulers": [120],

    // turn on word wrap for source and text
    // default value is "auto", which means off for source and on for text
    // "word_wrap": true,

    // set word wrapping at this column
    // default value is 0, meaning wrapping occurs at window width
    // "wrap_width": 80
}

```

- `Preferences > Package Settings > Markdown Editing > Markdown GFM Settings-Userr`에서 아래의 세팅 추가

```json
{
  "color_scheme": "Packages/MarkdownEditing/MarkdownEditor-Dark.tmTheme"
}
```

- `Preferences > Package Settings > OmniMarkupPreviewer > Settings-User`에서 아래의 세팅 추가

```json
{
    "renderer_options-MarkdownRenderer": {
        "extensions": ["tables", "fenced_code", "codehilite"]
    }
}
```



- `Tools > Build System > New Build System...` 에서 크롬 빌드 추가 *크롬 설치 경로 등에 따라 차이가 있을 수 있음

#### macOS
```json
{ "cmd": ["open", "-a", "Google Chrome", "$file"] }
```

#### Windows
```json
{ "cmd": ["C:\/Program Files (x86)\/Google\/Chrome\/Application\/chrome.exe","$file"] }
```

