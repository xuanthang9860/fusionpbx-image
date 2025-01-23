#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./resources/config.sh
. ./resources/colors.sh
. ./resources/environment.sh

# removes the cd img from the /etc/apt/sources.list file (not needed after base install)
sed -i '/cdrom:/d' /etc/apt/sources.list

#Update to latest packages
verbose "Update installed packages"
DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -yq

#Add dependencies
DEBIAN_FRONTEND=noninteractive apt-get install -yq wget
DEBIAN_FRONTEND=noninteractive apt-get install -yq lsb-release
DEBIAN_FRONTEND=noninteractive apt-get install -yq systemd
DEBIAN_FRONTEND=noninteractive apt-get install -yq systemd-sysv
DEBIAN_FRONTEND=noninteractive apt-get install -yq ca-certificates
DEBIAN_FRONTEND=noninteractive apt-get install -yq dialog
DEBIAN_FRONTEND=noninteractive apt-get install -yq nano
DEBIAN_FRONTEND=noninteractive apt-get install -yq net-tools
DEBIAN_FRONTEND=noninteractive apt-get install -yq gpg

#SNMP
# DEBIAN_FRONTEND=noninteractive apt-get install -yq snmpd
# echo "rocommunity public" > /etc/snmp/snmpd.conf
# service snmpd restart

#disable vi visual mode
echo "set mouse-=a" >> ~/.vimrc

#IPTables
# resources/iptables.sh

#sngrep
# resources/sngrep.sh

#PHP
# resources/php.sh

#NGINX web server
# resources/nginx.sh

#FusionPBX
# resources/fusionpbx.sh

# #Optional Applications
# resources/applications.sh

# #FreeSWITCH
# resources/switch.sh

# #Fail2ban
# # resources/fail2ban.sh

# #Postgres
# # resources/postgresql.sh

# #set the ip address
# server_address=$(hostname -I)

# #add the database schema, user and groups
# resources/finish.sh
