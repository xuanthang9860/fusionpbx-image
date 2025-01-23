# FROM debian:9
FROM fusionpbx-base-image
# Root install
USER root

# Setup suppervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq supervisor
ADD config/supervisor/conf.d/freeswitch-supervisord.conf /etc/supervisor/conf.d/freeswitch-supervisord.conf
ADD config/supervisor/conf.d/memcahed-supervisord.conf /etc/supervisor/conf.d/memcahed-supervisord.conf
ADD config/supervisor/conf.d/php-fpm-supervisord.conf /etc/supervisor/conf.d/php-fpm-supervisord.conf
ADD config/supervisor/conf.d/nginx-supervisord.conf /etc/supervisor/conf.d/nginx-supervisord.conf
ADD config/supervisor/supervisord.conf /etc/supervisor/supervisord.conf 

# Install mod audio_stream
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq libssl-dev zlib1g-dev libspeexdsp-dev
WORKDIR /usr/src/freeswitch-1.10.12/src/mod/applications/
RUN git clone https://github.com/amigniter/mod_audio_stream.git
WORKDIR /usr/src/freeswitch-1.10.12/src/mod/applications/mod_audio_stream
RUN git submodule init
RUN git submodule update
RUN export PKG_CONFIG_PATH=/usr/include/freeswitch
RUN mkdir build
WORKDIR /usr/src/freeswitch-1.10.12/src/mod/applications/mod_audio_stream/build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make
RUN make install

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq memcached
# Clean apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Tao folder de khoi tao php
RUN mkdir -p /run/php/
# RUN rm -rf /usr/src/debian /usr/src/freeswitch-1.10.12 /usr/src/libks /usr/src/sofia-sip-1.13.17 /usr/src/spansdp /usr/src/v1.13.17.zip
WORKDIR /usr/share/freeswitch/scripts
ADD startup.sh /var/startup.sh
RUN chmod 777 /var/startup.sh
CMD [ "/var/startup.sh" ]