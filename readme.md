# Mysql
# ##############################################################################

* Create the Dockerfile, from text editor, with this configuration :
  FROM mysql
  ENV MYSQL_ROOT_PASSWORD mysecretpassword

* Create the docker image, from terminal, run this command :
docker build -t mysql-image -f api/db/Dockerfile .

** To see the docker image, from terminal, run this command :
docker image ls

* Run the docker container from image, from terminal, run this command :
docker run -d --rm --name mysql-container mysql-image --default-authentication-plugin=mysql_native_password --innodb_use_native_aio=0

** To see the docker container, from terminal, run this command :
docker ps
docker container ps

* Create database structure, from text editor, with this configuration :
  CREATE DATABASE IF NOT EXISTS dockerdb;
  USE dockerdb;
  CREATE TABLE IF NOT EXISTS products (
    id INT(11) AUTO_INCREMENT,
    name VARCHAR(255),
    price DECIMAL(10, 2),
    PRIMARY KEY (id)
  );
  INSERT INTO products VALUE (0, 'Front-End specialist', 25000);
  INSERT INTO products VALUE (0, 'Back-End specialist', 900);

* Execute the docker interactive command INTO container :
docker exec -i mysql-container mysql -uroot -pmysecretpassword < api/db/script.sql

** Execute the docker interactive command IN container :
docker exec -it mysql-container /bin/bash

** Access to mysql command line : 
mysql -uroot -pmysecretpassword

** Check if everything executed from script.sql is there :
use dockerdb;
show tables;
select * from products;
exit -- to exit mysql command line;
exit # to exit terminal command line

* Run the docker container from image :
docker run -d -v "/$(pwd)/api/db/data:/var/lib/mysql" --rm --name mysql-container mysql-image --default-authentication-plugin=mysql_native_password --innodb_use_native_aio=0

* Or Run the docker container from docker hub image :
docker run -d -v "/$(pwd)/api/db/data:/var/lib/mysql" --rm --name mysql-container -e "MYSQL_ROOT_PASSWORD=mysecretpassword" mysql --default-authentication-plugin=mysql_native_password --innodb_use_native_aio=0

* To stop the container :
docker stop mysql-container



# API
# ##############################################################################

cd api
npm init
npm install --save-dev nodemon
npm install --save express mysql

* DB HOST, Look for 'IPAddress', from terminal, run this command : 
docker inspect mysql-container

* Create the Dockerfile with this configuration :
  FROM node:12-slim
  WORKDIR /home/node/app
  CMD npm run start:docker

* Create the docker image :
docker build -t node-image -f api/Dockerfile .

* To see the docker image :
docker image ls

* Run the docker container from image :
docker run -d -v "/$(pwd)/api":/home/node/app -p 9001:9001 --link mysql-container --rm --name node-container node-image

* Or Run the docker container from docker hub image :
docker run -d -v "/$(pwd)/api":/home/node/app -p 9001:9001 --link mysql-container --rm --name node-container -w "//home/node/app" node:12-slim npm run start:docker

* To stop the container :
docker stop node-container

* By browser
http://docker:9001/products


# WEBSITE (PHP)
# ##############################################################################

* Create the Dockerfile with this configuration :
  FROM php:7.4.9-apache
  WORKDIR /var/www/html

* Create the docker image :
docker build -t php-image -f website/Dockerfile .

* Run the docker container from image :
docker run -d -v "/$(pwd)/website":/var/www/html -p 8888:80 --link node-container --rm --name php-container php-image

* Or Run the docker container from docker hub image :
docker run -d -v "/$(pwd)/website":/var/www/html -p 8888:80 --link node-container --rm --name php-container -w "//var/www/html" php:7.4.9-apache

* To stop the container :
docker stop php-container

* By browser
http://docker:8888/


# Docker-Compose
# ##############################################################################
docker-compose up -d



# ##################################################################################################

# Dockerfile Example 1 : Installing and copying app on image -- For production
https://stackoverflow.com/questions/27226653/nodemon-is-not-working-in-docker-environment
FROM node:0.10

WORKDIR /nodeapp
ADD ./package.json /nodeapp/package.json
RUN npm install --production

ADD ./app /nodeapp/app

EXPOSE 8080

CMD ["node", ".", "--production"]


# Dockerfile Example 2 : Installing and copying app on image
https://stackoverflow.com/questions/51518624/nodemon-does-not-recharge-with-docker
FROM node:10

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied 
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

EXPOSE 3000
CMD [ "npm", "run", "dev" ]
