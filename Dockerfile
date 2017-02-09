# Set the base image to use to Ubuntu
FROM ubuntu:16.04

# install base packages
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN apt-get update -y &&  apt-get install -y git wget supervisor unzip ca-certificates wget \
 python-setuptools vlc-nox python-gevent python-psutil  python-appindicator python-m2crypto \
 libpython2.7 python-apsw wrapsrv python-m2ext  && \
   

# install acestream-engine

wget "http://dl.acestream.org/linux/acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz" && \
tar zxvf acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz && \
mv acestream_3.1.16_ubuntu_16.04_x86_64 /opt/acestream && \
rm ./acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz && \

mkdir -p /var/run/sshd && \
mkdir -p /var/log/supervisor && \
mkdir -p /dev/disk/by-id && \

# create user to run aceproxy
adduser --disabled-password --gecos "" tv && \

cd /home/tv/ && git clone https://github.com/AndreyPavlenko/aceproxy.git aceproxy-master && \

echo 'root:password' |chpasswd

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 8000 8621 62062 9944 9903

ENTRYPOINT ["/start.sh"]
