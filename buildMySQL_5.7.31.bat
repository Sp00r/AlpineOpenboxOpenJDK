@ECHO OFF
echo Building image: c++ compiler for MySQL and make MySQL 5.7.31
docker build ./MySQL_5_7_31 -t patools/mysql:5.7.31
echo Starting container: image with MySQL package build
docker run --rm patools/mysql:5.7.31 --name mysql_5_7_31
docker cp mysql_5_7_31:/usr/local/mysql-5.7.31/mysql-5.7.31-linux-x86_64.tar.gz ./dependencies
cmd /k