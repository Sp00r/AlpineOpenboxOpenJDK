FROM alpine:latest
ENV MYSQL_TCP_PORT=3306
ENV MYSQLX_TCP_PORT=30306

RUN apk update && apk upgrade

# Alpine configuration
RUN apk add alpine-conf ca-certificates
RUN update-ca-certificates

# Git
RUN apk add git

# MySQL
RUN apk add build-base cmake make perl ncurses ncurses-dev openssl-dev libtirpc-dev rpcgen bison libaio-dev
RUN wget https://downloads.mysql.com/archives/get/p/23/file/mysql-boost-5.7.31.tar.gz
RUN tar -xvf mysql-boost-5.7.31.tar.gz -C /usr/local
RUN rm mysql-boost-5.7.31.tar.gz
WORKDIR /usr/local/mysql-5.7.31
RUN cmake . -DDOWNLOAD_BOOST=1 -DWITH_BOOST="/usr/local/boost" -DBUILD_CONFIG="mysql_release"
RUN make ..
RUN make package