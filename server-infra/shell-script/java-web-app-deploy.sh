#!/bin/bash

# REPOSITORY_DIR=~/Downloads/jwp-basic
REPOSITORY_DIR=/home/kjnam/.jenkins/workspace/jwp-basic
TOMCAT_DIR=~/tomcat

#cd $REPOSITORY_DIR
#mvn clean package


$TOMCAT_DIR/bin/shutdown.sh

rm -rf $TOMCAT_DIR/webapps/ROOT
pwd

mv $REPOSITORY_DIR/target/jwp-basic  $TOMCAT_DIR/webapps/ROOT

#/etc/sudoers에 아래의 라인을 추가
#jenkins    ALL = NOPASSWD: /path/to/script
sudo $TOMCAT_DIR/bin/startup.sh
