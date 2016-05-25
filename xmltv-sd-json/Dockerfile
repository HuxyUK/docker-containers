# This is a comment
FROM phusion/baseimage:0.9.18
MAINTAINER James Huxtable <admin@codeape.co.uk>

# Set correct environment variables 
ENV HOME /root 
ENV DEBIAN_FRONTEND noninteractive 
ENV LC_ALL C.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US.UTF-8 

# Use baseimage-docker's init system
# CMD ["/sbin/my_init"]
CMD ["/usr/sbin/cron","-f"]

# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /home nobody && \
 chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh 

# Install XMLTV & SD JSON
RUN apt-get update && apt-get install -y xmltv wget
RUN wget https://raw.githubusercontent.com/kgroeneveld/tv_grab_sd_json/master/tv_grab_sd_json -O /usr/local/bin/tv_grab_sd_json && chmod +x /usr/local/bin/tv_grab_sd_json

#set config directory
VOLUME /config

# Add plex.sh to execute during container startup
# RUN mkdir -p /etc/my_init.d
# ADD plex.sh /etc/my_init.d/plex.sh
# RUN chmod +x /etc/my_init.d/plex.sh
