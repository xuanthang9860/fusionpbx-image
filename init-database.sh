#bin/bash
php /var/www/fusionpbx/core/upgrade/upgrade_schema.php
user_name=admin
user_password='Namitech#$@342'
user_uuid=c58a1de7-3f6d-40a4-a9d1-bca22968d479
user_salt=c845db3e-bd3c-4212-ad43-7bb0f7f01510
password_hash=$(/usr/bin/php -r "echo md5('$user_salt$user_password');");
domain_uuid=b99c8f1f-6543-44a6-91b3-65747da96073
user_group_uuid=1f10a9ec-498d-48b2-9b61-80e054d72b08
group_name=superadmin
domain_name=namitech.io

database_host=127.0.0.1
database_port=5432
database_username=fusionpbx
database_password=namitech
database_name=fusionpbx

cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_schema.php > /dev/null 2>&1
psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_domains (domain_uuid, domain_name, domain_enabled) values('$domain_uuid', '$domain_name', 'true');"
cd /var/www/fusionpbx && /usr/bin/php /var/www/fusionpbx/core/upgrade/upgrade_domains.php

psql --host=$database_host --port=$database_port --username=$database_username -t -c "insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('$user_uuid', '$domain_uuid', '$user_name', '$password_hash', '$user_salt', 'true');"
group_uuid=$(psql --host=$database_host --port=$database_port --username=$database_username -qtAX -c "select group_uuid from v_groups where group_name = 'superadmin';");
psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_user_groups (user_group_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$user_group_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"
cd /var/www/fusionpbx && /usr/bin/php /var/www/fusionpbx/core/upgrade/upgrade.php

# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# apt update
# apt install postgresql-client-16