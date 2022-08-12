@ECHO OFF
echo [INFO] Building image: c++ compiler for MySQL and make MySQL 5.7.31
docker build ./MySQL_5_7_31 -t patools/mysql:5.7.31
echo [INFO] Running container with MySQL build image
docker run --name mysql_5_7_31 patools/mysql:5.7.31
mkdir dependencies
echo [INFO] Getting MySQL build from container
docker cp mysql_5_7_31:/usr/local/mysql-5.7.31/mysql-5.7.31-linux-x86_64.tar.gz ./dependencies
echo [INFO] Stopping container with MySQL build image
docker stop mysql_5_7_31
echo [INFO] Removing container with MySQL build image
docker rm mysql_5_7_31
cmd /k