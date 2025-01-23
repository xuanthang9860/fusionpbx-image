
php /var/www/fusionpbx/core/upgrade/upgrade_schema.php
insert into v_domains (domain_uuid, domain_name, domain_enabled) values('b99c8f1f-6543-44a6-91b3-65747da96073','namitech.io','true');
/usr/bin/php /var/www/fusionpbx/core/upgrade/upgrade_domains.php


// Tao user portal
/usr/bin/php /var/www/fusionpbx/resources/uuid.php // user_uuid=c58a1de7-3f6d-40a4-a9d1-bca22968d479
/usr/bin/php /var/www/fusionpbx/resources/uuid.php // user_salt=c845db3e-bd3c-4212-ad43-7bb0f7f01510

/usr/bin/php -r "echo md5('$user_salt$user_password'); // pasdwordhash = 
/usr/bin/php -r "echo md5('c845db3e-bd3c-4212-ad43-7bb0f7f01510Namitech#$@342');" // password_hash=1cb874d5f4e935844492f88dc7c516e0
insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('c58a1de7-3f6d-40a4-a9d1-bca22968d479', 'b99c8f1f-6543-44a6-91b3-65747da96073', 'admin', '1cb874d5f4e935844492f88dc7c516e0', 'c845db3e-bd3c-4212-ad43-7bb0f7f01510', 'true');

// #get the superadmin group_uuid
#echo "psql --host=$database_host --port=$database_port --username=$database_username -qtAX -c \"select group_uuid from v_groups where group_name = 'superadmin';\""
# group_uuid=$(psql --host=$database_host --port=$database_port --username=$database_username -qtAX -c "select group_uuid from v_groups where group_name = 'superadmin';");
group_uuid=3c443ac7-f2d0-47ae-b525-3ecf163147d9
#add the user to the group
# user_group_uuid=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);
user_group_uuid=1f10a9ec-498d-48b2-9b61-80e054d72b08

# group_name=superadmin
insert into v_user_groups (user_group_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('1f10a9ec-498d-48b2-9b61-80e054d72b08', 'b99c8f1f-6543-44a6-91b3-65747da96073', 'superadmin', '3c443ac7-f2d0-47ae-b525-3ecf163147d9', 'c58a1de7-3f6d-40a4-a9d1-bca22968d479');
#echo "insert into v_user_groups (user_group_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$user_group_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"
# psql --host=$database_host --port=$database_port --username=$database_username -c "insert into v_user_groups (user_group_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$user_group_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"


/usr/bin/php /var/www/fusionpbx/core/upgrade/upgrade.php