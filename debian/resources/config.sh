
# FusionPBX Settings
domain_name='namitech.io'                      # hostname, ip_address or a custom value
system_username=admin                       # default username admin
system_password='Namitech#$@342'                      # random or a custom value
system_branch=5.3                           # master, 5.3

# FreeSWITCH Settings
switch_branch=stable                        # master, stable
switch_source=true                          # true (source compile) or false (binary package)
switch_package=false                        # true (binary package) or false (source compile)
switch_version=1.10.12                      # which source code to download, only for source
switch_tls=true                             # true or false
switch_token=                               # Get the auth token from https://signalwire.com
                                            # Signup or Login -> Profile -> Personal Auth Token

swtich_event_socket_port=7001
swtich_event_socket_password='n@m!te^chPa$$w0rD'                                            
# Sofia-Sip Settings
sofia_version=1.13.17                       # release-version for sofia-sip to use

# Database Settings
database_name=fusionpbx                     # Database name (safe characters A-Z, a-z, 0-9)
database_username=fusionpbx                 # Database username (safe characters A-Z, a-z, 0-9)
database_password='n@m!!techP@sSwrDD@TbasE@270498'                    # random or a custom value (safe characters A-Z, a-z, 0-9)
database_repo=official                      # PostgreSQL official, system
database_version=16                         # requires repo official
database_host=127.0.0.1                     # hostname or IP address
database_port=5432                          # port number
database_backup=false                       # true or false

# General Settings
php_version=8.1                             # PHP version 7.1, 7.3, 7.4, 8.1
letsencrypt_folder=true                     # true or false

# Optional Applications
application_transcribe=true                # Speech to Text
application_speech=true                    # Text to Speech
application_device_logs=true               # Log device provision requests
application_dialplan_tools=false           # Add additional dialplan applications
application_edit=false                     # Editor for XML, Provision, Scripts, and PHP
application_sip_trunks=false               # Registration based SIP trunks
