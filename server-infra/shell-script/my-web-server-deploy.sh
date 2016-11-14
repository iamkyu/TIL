#!/bin/bash -xe

# fuser -k -n tcp 8089


if lsof -Pi :8089 -sTCP:LISTEN -t >/dev/null ; then
	echo "port8089 killed"
	fuser -k -n tcp 8089
else
	echo "port8089 was stop"
fi



cd /home/kjnam/.jenkins/workspace/my-web-server
BUILD_ID=dontKillMe nohup java -cp target/classes:target/dependency/* webserver.WebServer 8089  &

# cd /home/kjnam/Downloads/my-web-server
# java -cp target/classes:target/dependency/* webserver.WebServer 8089 &

echo "Deploy Success!"
