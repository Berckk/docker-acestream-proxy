# Set the base image to use to Ubuntu
FROM ubuntu:16.04

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git wget supervisor unzip ca-certificates

RUN echo 'deb http://repo.acestream.org/ubuntu/ trusty main' > /etc/apt/sources.list.d/acestream.list
RUN wget -q -O - http://repo.acestream.org/keys/acestream.public.key | apt-key add -
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y acestream-engine vlc-nox python-gevent python-psutil

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN adduser --disabled-password --gecos "" tv

RUN cd /home/tv/ && git clone https://github.com/AndreyPavlenko/aceproxy.git aceproxy-master

RUN echo 'root:password' |chpasswd

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 8000 8621 62062 9944 9903

ENTRYPOINT ["/start.sh"]
