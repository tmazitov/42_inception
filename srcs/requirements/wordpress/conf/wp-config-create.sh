#Specify that the script should be executed in the sh shell
#!/bin/sh

#Check if the file wp-config.php is already created.
#If the file is not created, start writing to it.
if [ ! -f "/var/www/wp-config.php" ]; then

#If the file is not created, start writing to it - in order to create a new WordPress configuration file
#Everything after it and before the EOF tag will be written to /var/www/wp-config.php file.
cat << EOF > /var/www/wp-config.php

#Enter the PHP code for the WordPress configuration.
<?php

#Set the database name from an environment variable - so that WordPress knows which database to work with
define( 'DB_NAME', '${DB_NAME}' );

#Set the database username - so WordPress can connect to the database
define( 'DB_USER', '${DB_USER}' );

#Set the database user password - for secure access to the database
define( 'DB_PASSWORD', '${DB_PASS}' );

#Specify that the database host is mariadb - so WordPress knows where to connect to
define( 'DB_HOST', 'mariadb' );

#Set database encoding as UTF-8 - for correct processing of text data
define( 'DB_CHARSET', 'utf8' );

#Leave empty the parameter of comparing strings in the database - to use the standard settings
define( 'DB_COLLATE', '' );

#Set the direct method of accessing the file system (FS_METHOD,'direct') - so that WordPress 
#can directly access the file system, it is useful for automatic updates and loading plugins
define('FS_METHOD','direct');

#Set a prefix for the database tables - to avoid conflicts with other applications that may use the same database
\$table_prefix = 'wp_';

#Disable debugging mode - to avoid displaying unnecessary error messages and warnings on the site
define( 'WP_DEBUG', false );

#Set the absolute path to the WordPress directory, if not set - it is necessary for the correct operation of WordPress
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );}

#Plugging in the main WordPress settings file - to make all these settings take effect 
require_once ABSPATH . 'wp-settings.php';

##Finish writing to the wp-config.php file - to save all our settings
EOF
fi