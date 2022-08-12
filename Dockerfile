FROM alpine:latest
ENV TZ="Europe/Brussels"
ENV USER='infrabel'
ENV PASS='infrabel'
ENV GROUP='test_group'
ENV DISPLAY :1
ENV RESOLUTION 1920x1080x16
ENV XRES 1920x1080x16
ENV MYSQL_TCP_PORT=3306
 
RUN apk update && apk upgrade
 
# Alpine configuration
RUN apk add alpine-conf tzdata bash ca-certificates
RUN update-ca-certificates
RUN cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime
RUN echo "Europe/Brussels" >  /etc/timezone
 
# Window manager and (temporarily VNC)
RUN apk add openbox xterm terminus-font xvfb x11vnc supervisor
RUN echo 'exec openbox-session' >> ~/.xinitrc
RUN mkdir /home/$USER/.config
RUN cp -r /etc/xdg/openbox ~/.config

# Java 8
RUN apk add openjdk8
 
# Maven 3.6
RUN wget https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN tar -xvf apache-maven-3.6.3-bin.tar.gz -C /usr/local
ENV PATH=$PATH:/usr/local/apache-maven-3.6.3/bin
RUN rm apache-maven-3.6.3-bin.tar.gz
 
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
RUN make install
RUN mkdir data
#RUN chown mysql:mysql data
RUN chmod 750 data
#RUN mysqld --initialize-insecure --user=mysql --datadir=/usr/local/mysql-5.7.31/data

# User
RUN addgroup -g 1000 -S $GROUP
RUN adduser -S -D -u 1000 --gecos "Infrabel PA Tools" $USER -G $GROUP
RUN addgroup $USER input
RUN addgroup $USER video
# Root permissions using doas
RUN adduser $USER wheel
RUN apk add doas
RUN echo 'permit persist :wheel' >> /etc/doas.d/doas.conf
RUN echo 'permit nopass :wheel' >> /etc/doas.d/doas.conf
# Make user root (security risk, use doas)
#RUN echo "root:$PASS" | /usr/sbin/chpasswd && echo "$USER:$PASS" | /usr/sbin/chpasswd && echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

WORKDIR /home/$USER
USER $USER
RUN doas -u root setup-xorg-base; exit 0
 
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
ADD etc /etc
 
EXPOSE 5900
EXPOSE 3306
 
USER root