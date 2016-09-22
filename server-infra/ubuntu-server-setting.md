# JVM 서버 설정 on Ubuntu

맥에서는 터미널에서 다음 명령으로 원격 서버에 접속할 수 있다.

```bash
$ ssh [your-user-name]@[your-server-address]
```



## 사용자생성 및 권한부여

 `$ adduser [user-name]` 명령어를 통해 사용자를 추가할 수 있고 root가 아닌 계정에 root 권한을 주기 위해서는 아래의 명령어를 입력한 후 `root ALL=(..` 부분 다음 라인에 등록한 유저명만 추가 후 동일하게 작성한다.

```shell
# 사용자가 정상적으로 추가되었다면 사용자명의 디렉토리가 생김
$ cd /home
$ ls -al

# root가 아닌 계정에 root권한을 부여
$ vi /etc/sudoers

# 재접속
```



## UTF-8 인코딩 설정

```shell
# 시스템 전체에 로케일로 UTF-8을 설정
$ sudo locale-gen ko_KR.EUC-KR ko_KR.UTF-8
$ sudo dpkg-reconfigure locales

# 각 계정에 해당 인코딩을 사용하도록 설정
$ cd /home/[your-user-name] #본인 사용자명 폴더
$ vi .bash_profile

# 아래 내용을 추가 후 저장
LANG="ko_KR.UTF-8"
LANGUAGE="ko_KR:ko:en_US:en"

# 위 내용을 저장하고 빠져 나온 후
$ source .bash_profile

# 정상적으로 설정되었는지 확인
$ env
```



## JDK 설치

[오라클의 JDK 다운로드 페이지](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)에 접속 후 Linux용 JDK 의 링크주소를 복사

```shell
$ wget --header "Cookie: oraclelicense=accept-securebackup-cookie" [your-JDK-URL]
$ gunzip [your-jdk-filename.tar.gz]
$ tar -xvf [your-jdk-filename.tar]

# 심볼릭 링크 지정
$ ln -s [your-jdk-directory] java
$ cd java
```

다음으로 자바 환경 변수를 지정한다.

```shell
$ cd /home/[your-user-name] #본인 사용자명 폴더
$ vi .bash_profile

# 아래 내용을 추가 후 저장
export JAVA_HOME=[your-jdk-directory]
export PATH=$PATH:$JAVA_HOME/bin

# 위 내용을 저장하고 빠져 나온 후
$ source .bash_profile
$ java -version
```



## Maven 설치

JDK 설치 때와 같이 [Maven 사이트](https://maven.apache.org/download.cgi?Preferred=ftp://mirror.reverse.net/pub/apache/)에 접속하여 다운로드 URL을 얻는다.

```shell
$ wget [your-maven-url]
$ gunzip [your-maven-filename.tar.gz]
$ tar -xvf [your-maven-filename.tar]

# 심볼릭 링크 지정
$ ln -s [your-maven-directory] maven
$ cd maven

#환경 변수 지정
$ cd /home/[your-user-name] #본인 사용자명 폴더
$ vi .bash_profile

# 아래 내용을 추가 후 저장. 자바 PATH가 설정 되어 있다고 생각하고 내용을 이어 붙힌다.
export JAVA_HOME=[your-jdk-directory]
export MVN_HOME=[your-jdk-directory]
export PATH=$PATH:$JAVA_HOME/bin:$MVN_HOME/bin

# 위 내용을 저장하고 빠져 나온 후
$ source .bash_profile
$ mvn -v
```



## Git 설치

```shell
# APT(Advanced Packaging Tool) 업데이트 후 Git 설치
$ sudo apt-get update
$ sudo apt-get install git
$ git --version
```



## 사용할 포트의 방화벽 오픈

```shell
# 방화벽 상태 확인
$ sudo ufw status verbose
$ sudo ufw allow [your-port-number]/tcp
```



## 그 외

아래 내용은 [자바 웹 프로그래밍 Next Step 하나씩 벗겨가는 양파껍질 학습법(박재성 저. 로드북. 2016)](http://book.naver.com/bookdb/book_detail.nhn?bid=11037465) 교재의 웹 서버 샘플 소스를 Git 에서 내려 받아 실행 시키는 과정임.

```shell
$ git clone https://github.com/slipp/my-slipp.git
$ cd my-slipp

# 메이븐 빌드
$ ./mvnw clean package

# 맨 마지막에 &를 추가하면 백그라운드로 실행이 가능하다.
$ cd target/
$ java -jar my-slipp-1.0.jar &

# 백그라운드로 실행되는 서버 PID 확인
$ ps -ef | grep java

# 백그라운드로 실행되는 서버 종료
$ kill -[your-server-pid] $PID
```

*만약 공유기에 물려 있는 서버일 경우 공유기 설정에서 포트포워딩을 설정해줘야 외부에서도 해당 서버로 접근 가능하다.

```shell
$ sudo reboot         # 시스템 재부팅
$ sudo reboot -f      # 시스템 강제 재부팅

$ halt              # 시스템 종료
$ halt  -f          # 시스템 강제 종료
```



#### Ubuntu에 oh-my-zsh: agnoster 테마 설치

```shell
$ sudo apt-get install zsh 
$ which zsh               #쉘의 위치를 확인한다.
/usr/bin/zsh

$ chsh -s /usr/bin/zsh    #기본 쉘을 변경한다.
$ curl -L http://install.ohmyz.sh | sh #설치
$ cd ~ ; git clone https://github.com/powerline/fonts.git #전용폰트 다운
$ cd fonts; ./install.sh #설치
$ vim ~/.zshrc

# 기존 ZSH_THEME을 주석처리하고 아래 내용을 추가한다.
ZSH_THEME="agnoster" 
```

