<<<<<<< HEAD
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

- `Preferences > Settings > User`에서 아래의 세팅 추가

```
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

```
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

- `Tools > Build System > New Build System...` 에서 크롬 빌드 추가 *크롬 설치 경로 등에 따라 차이가 있을 수 있음


#### macOS
```
{ "cmd": ["open", "-a", "Google Chrome", "$file"] }
```

#### Windows
```
{ "cmd": ["C:\/Program Files (x86)\/Google\/Chrome\/Application\/chrome.exe","$file"] }
```
=======
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

- `Preferences > Settings > User`에서 아래의 세팅 추가

```
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

```
{
	"always_show_minimap_viewport": true,
	"bold_folder_labels": true,

    "theme": "Afterglow-blue.sublime-theme",
    "color_scheme": "Packages/Theme - Afterglow/Afterglow.tmTheme",
    "folder_no_icon": true,
    "tabs_small": true,
    "tab_size": 4,
    "translate_tabs_to_spaces": true,
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

- `Tools > Build System > New Build System...` 에서 크롬 빌드 추가 *크롬 설치 경로 등에 따라 차이가 있을 수 있음


#### macOS
```
{ "cmd": ["open", "-a", "Google Chrome", "$file"] }
```

```
{ "cmd": ["open", "-a", "Google Chrome Canary", "$file"] }
```

#### Windows
```
{ "cmd": ["C:\/Program Files (x86)\/Google\/Chrome\/Application\/chrome.exe","$file"] }
```
>>>>>>> 9842b424f25c2a72d09d08def824c6d6b71c9a79
