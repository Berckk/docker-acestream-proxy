# Set the base image to use to Ubuntu
FROM ubuntu:16.04

MAINTAINER Igor Katson <igor.katson@gmail.com>

RUN apt update -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y git wget supervisor unzip ca-certificates

RUN echo 'deb http://repo.acestream.org/ubuntu/ trusty main' > /etc/apt/sources.list.d/acestream.list
RUN wget -q -O - http://repo.acestream.org/keys/acestream.public.key | apt-key add -
RUN DEBIAN_FRONTEND=noninteractive apt update -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y acestream-engine vlc-nox python-gevent

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN adduser --disabled-password --gecos "" tv

RUN git clone https://github.com/ValdikSS/aceproxy.git
RUN mv /home/tv/aceproxy /home/tv/aceproxy-master

RUN echo 'root:password' |chpasswd

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 8000 62062

ENTRYPOINT ["/start.sh"]
