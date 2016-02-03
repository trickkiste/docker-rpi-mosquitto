# Pull base image
FROM resin/rpi-raspbian:latest
MAINTAINER Markus Kienast <mark@trickkiste.at>

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update &&\
  apt-get install -y wget &&\ 
  wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
  apt-key add mosquitto-repo.gpg.key && \
  cd /etc/apt/sources.list.d/ && \
  wget http://repo.mosquitto.org/debian/mosquitto-jessie.list && \
  apt-get update && \
  apt-get install -y mosquitto \
  --no-install-recommends && \
  apt-get clean &&\
  apt-get autoclean &&\
  rm -rf /var/lib/apt/lists/*

COPY config /mqtt/config

RUN mkdir -p /mqtt/data &&\
  mkdir /mqtt/log &&\
  chown -R mosquitto /mqtt

VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

# Define working directory
USER mosquitto
WORKDIR /mqtt

EXPOSE 1883 9001
CMD ["/usr/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]
