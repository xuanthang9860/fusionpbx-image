#bin/bash
php /var/www/fusionpbx/core/upgrade/upgrade_schema.php
user_name=admin
user_password='Namitech#$@342'
user_uuid=c58a1de7-3f6d-40a4-a9d1-bca22968d479
user_salt=c845db3e-bd3c-4212-ad43-7bb0f7f01510
password_hash=$(/usr/bin/php -r "echo md5('$user_salt$user_password');");
echo $password_hash
# update v_users set salt='c845db3e-bd3c-4212-ad43-7bb0f7f01510' where username='admin';
# update v_users set password='4249c44e67f0ecf9c36b0f8afb2d16b6' where username='admin';