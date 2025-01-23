# FROM debian:9
FROM debian:11 AS build-stage
# Root install
USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update -yq
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq git lsb-release


# Prepare
WORKDIR /usr/src/debian
ADD debian/resources/config.sh /usr/src/debian/resources/config.sh
ADD debian/resources/colors.sh /usr/src/debian/resources/colors.sh
ADD debian/resources/environment.sh /usr/src/debian/resources/environment.sh

ADD debian/install.sh /usr/src/debian/install.sh

# Install php
ADD debian/resources/ioncube.sh /usr/src/debian/resources/ioncube.sh
ADD debian/resources/php.sh /usr/src/debian/resources/php.sh
RUN /bin/bash resources/php.sh

# Install nginx
ADD debian/resources/nginx /usr/src/debian/resources/nginx
ADD debian/resources/nginx.sh /usr/src/debian/resources/nginx.sh
RUN /bin/bash resources/nginx.sh

# Install fusionpbx
ADD fusionpbx /var/www/fusionpbx
ADD debian/resources/fusionpbx.sh /usr/src/debian/resources/fusionpbx.sh
RUN /bin/bash resources/fusionpbx.sh

# #FreeSWITCH
ADD debian/resources/switch /usr/src/debian/resources/switch
ADD debian/resources/switch.sh /usr/src/debian/resources/switch.sh
RUN /bin/bash resources/switch.sh

# Install Application
ADD debian/resources/applications.sh /usr/src/debian/resources/applications.sh
RUN /bin/bash resources/applications.sh

# Finish
ADD debian/resources/fusionpbx /usr/src/debian/resources/fusionpbx
ADD debian/resources/finish.sh /usr/src/debian/resources/finish.sh
RUN /bin/bash resources/finish.sh

FROM build-stage AS debug-stage
# Setup suppervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq supervisor
ADD config/supervisor/conf.d/freeswitch-supervisord.conf /etc/supervisor/conf.d/freeswitch-supervisord.conf
ADD config/supervisor/conf.d/memcahed-supervisord.conf /etc/supervisor/conf.d/memcahed-supervisord.conf
ADD config/supervisor/conf.d/php-fpm-supervisord.conf /etc/supervisor/conf.d/php-fpm-supervisord.conf
ADD config/supervisor/conf.d/nginx-supervisord.conf /etc/supervisor/conf.d/nginx-supervisord.conf
ADD config/supervisor/conf.d/cron-supervisord.conf /etc/supervisor/conf.d/cron-supervisord.conf
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

WORKDIR /usr/src/freeswitch-1.10.12/src/mod/applications/mod_oreka/
RUN make
RUN make install

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq memcached

# Setting crontab
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq cron
RUN echo "* * * * * root /usr/bin/php /var/www/fusionpbx/app/xml_cdr/xml_cdr_import.php 300" > /etc/cron.d/pbx_cron_tab
RUN chmod 0644 /etc/cron.d/pbx_cron_tab
RUN /usr/bin/crontab /etc/cron.d/pbx_cron_tab

# Clean apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN DEBIAN_FRONTEND=noninteractive apt-get update -yq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq postgresql-client-16

# Tao folder de khoi tao php
RUN mkdir -p /run/php/
# RUN rm -rf /usr/src/debian /usr/src/freeswitch-1.10.12
RUN rm -rf /usr/src/libks /usr/src/sofia-sip-1.13.17 /usr/src/spandsp /usr/src/v1.13.17.zip
WORKDIR /var/cache/fusionpbx
ADD init-database.sh /var/init-database.sh
ADD reset-password.sh /var/reset-password.sh
ADD startup.sh /var/startup.sh
RUN chmod 777 /var/startup.sh
CMD [ "/var/startup.sh" ]

# docker build -t pbx-core-base-image .
# docker build -t pbx-core .
# /usr/bin/tar -czvf data-pbx-db.tar.gz data-pbx-db
# docker run -it --rm --network host --name freeswitch pbx-core
# namichain.azurecr.io/pbx/pbx-core
# namichain.azurecr.io/pbx/pbx-core-base-image

# docker tag pbx-core-base-image namichain.azurecr.io/pbx/pbx-core-base-image
# docker tag pbx-core namichain.azurecr.io/pbx/pbx-core