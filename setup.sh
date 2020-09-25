do_run(){
  docker run -d --name mysql-container -v "/$(pwd)/api/db/data:/var/lib/mysql" -e "MYSQL_ROOT_PASSWORD=mysecretpassword" mysql --default-authentication-plugin=mysql_native_password --innodb_use_native_aio=0
  docker run -d --name node-container -v "/$(pwd)/api":/home/node/app -p 9001:9001 --link mysql-container -w "//home/node/app" node:12-slim npm run start:docker
  docker run -d --name php-container -v "/$(pwd)/website":/var/www/html -p 8888:80 --link node-container -w "//var/www/html" php:7.4.9-apache
}

do_start(){
  docker start mysql-container
  docker start node-container
  docker start php-container
}

do_stop(){
  docker stop php-container
  docker stop node-container
  docker stop mysql-container
}

do_rm(){
  docker rm $(docker ps -aq -f name=mysql-container -f name=node-container -f name=php-container)
}

do_rmi(){
  docker rmi $(docker images -aq -f reference=mysql -f reference=node -f reference='php')
}

do_init(){
  docker exec -i mysql-container mysql -uroot -pmysecretpassword < api/db/script.sql
  cd api && npm i && cd ..
}

[ "$1" = "run" ]   && { echo "Running containers...";  do_run;   exit 0; }
[ "$1" = "start" ] && { echo "Starting containers..."; do_start; exit 0; }
[ "$1" = "stop" ]  && { echo "Stopping containers..."; do_stop;  exit 0; }
[ "$1" = "rm" ]    && { echo "Removing containers..."; do_rm;    exit 0; }
[ "$1" = "rmi" ]   && { echo "Removing images...";     do_rmi;   exit 0; }
[ "$1" = "init" ]  && { echo "Initializing...";        do_init;  exit 0; }
