# Cannot find module 'xxx'

Github에서 xml형식의 티스토리 백업 파일을 markdown 형식으로 파싱해주는 프로젝트를 사용하려던 중, npm 관련 오류를 겪음.

- 프로젝트 저장소 [Tistory Backup Extractor](https://github.com/doortts/tistory-backup-extractor)

```shell
$ npm start

> tistory-backup-extractor@0.8.1 start /Users/kjnam/local/tistory-backup-extractor
> babel-node --presets es2015 app/app.js

module.js:472
    throw err;
    ^

Error: Cannot find module 'xml-stream'
    at Function.Module._resolveFilename (module.js:470:15)
    at Function.Module._load (module.js:418:25)
    at Module.require (module.js:498:17)
    at require (internal/module.js:20:19)
    at Object.<anonymous> (/Users/kjnam/local/tistory-backup-extractor/app/parser/analyzer.js:2:1)
    at Module._compile (module.js:571:32)
    at loader (/Users/kjnam/local/tistory-backup-extractor/node_modules/babel-register/lib/node.js:144:5)
    at Object.require.extensions.(anonymous function) [as .js] (/Users/kjnam/local/tistory-backup-extractor/node_modules/babel-register/lib/node.js:154:7)
    at Module.load (module.js:488:32)
    at tryModuleLoad (module.js:447:12)

npm ERR! Darwin 16.1.0
npm ERR! argv "/usr/local/bin/node" "/usr/local/bin/npm" "start"
npm ERR! node v7.2.0
npm ERR! npm  v4.0.3
npm ERR! code ELIFECYCLE
npm ERR! tistory-backup-extractor@0.8.1 start: `babel-node --presets es2015 app/app.js`
npm ERR! Exit status 1
npm ERR!
npm ERR! Failed at the tistory-backup-extractor@0.8.1 start script 'babel-node --presets es2015 app/app.js'.
npm ERR! Make sure you have the latest version of node.js and npm installed.
npm ERR! If you do, this is most likely a problem with the tistory-backup-extractor package,
npm ERR! not with npm itself.
npm ERR! Tell the author that this fails on your system:
npm ERR!     babel-node --presets es2015 app/app.js
npm ERR! You can get information on how to open an issue for this project with:
npm ERR!     npm bugs tistory-backup-extractor
npm ERR! Or if that isn't available, you can get their info via:
npm ERR!     npm owner ls tistory-backup-extractor
npm ERR! There is likely additional logging output above.

npm ERR! Please include the following file with any support request:
npm ERR!     /Users/kjnam/local/tistory-backup-extractor/npm-debug.log
```



## 해결방법

이것 저것 시도해봄. 먼저 npm과 node 버전 최신화.

```shell
#node 업데이트
$ node -v
$ sudo npm cache clean -f
$ sudo npm install -g n
$ sudo n stable
$ node -v # 최신화 확인

#npm 업데이트
$ npm -v
$ sudo npm install -g npm
$ npm -v # 최신화 확인
```

하지만 여전히 같은 에러 발생. 스택 오버 플로우의 아래 질문을 참고.

- [NPM global install “cannot find module”](http://stackoverflow.com/questions/12594541/npm-global-install-cannot-find-module)

맥 OS를 기준으로 환경변수에 아래 경로를 추가 후 해결.

```shell
$ vim .bash_profile

export NODE_PATH=/usr/local/lib/node_modules

$ source .bash_profile
```

