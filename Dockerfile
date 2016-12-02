# Set the base image to use to Ubuntu
FROM ubuntu:16.04

# install base packages
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN apt-get update -y &&  apt-get install -y git wget supervisor unzip ca-certificates && \
   
# install acestream-engine
echo 'deb http://repo.acestream.org/ubuntu/ trusty main' > /etc/apt/sources.list.d/acestream.list && \
wget -q -O - http://repo.acestream.org/keys/acestream.public.key | apt-key add - && \

apt-get update -y && \
apt-get install -y acestream-engine vlc-nox python-gevent python-psutil && \

mkdir -p /var/run/sshd && \
mkdir -p /var/log/supervisor && \

# create user to run aceproxy
adduser --disabled-password --gecos "" tv && \

cd /home/tv/ && git clone https://github.com/AndreyPavlenko/aceproxy.git aceproxy-master && \

echo 'root:password' |chpasswd

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 8000 8621 62062 9944 9903

ENTRYPOINT ["/start.sh"]
