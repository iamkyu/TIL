```shell
$ docker search mysql

$ docker pull mysql:latest # latest 생략해도 기본값이 최신버전

$ docker \
  run \
  --detach \
  --env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  --env MYSQL_USER=${MYSQL_USER} \
  --env MYSQL_PASSWORD=${MYSQL_PASSWORD} \
  --env MYSQL_DATABASE=${MYSQL_DATABASE} \
  --name ${MYSQL_CONTAINER_NAME} \
  --publish 3306:3306 \
  mysql;

$ docker exec -t -i mysql /bin/bash

# mysql 컨테이너의 bash
$ mysql -u root -p
```
