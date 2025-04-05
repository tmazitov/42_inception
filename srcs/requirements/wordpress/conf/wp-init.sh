#!/bin/sh

#Check if WordPress is installed in the /var/www/ directory. 
#The --allow-root option allows you to run this command as root user. 
#If WordPress is not installed, the script will execute the following commands inside this conditional block.
if ! wp core is-installed --allow-root --path=/var/www/; then

#Install WordPress with the specified parameters:
#--url=$DOMAIN_NAME: Site URL
#--title=Inception: Title of the site
#--admin_user=$WP_ADUSER: Administrator Name
#--admin_password=$WP_ADPASS: Admin Password
#--admin_email=$WP_ADEMAIL: Admin Email
#The --allow-root option is again needed to run the command as root user.
wp core install --url=$DOMAIN_NAME --title=Inception --admin_user=$WP_ADUSER --admin_password=$WP_ADPASS --admin_email=$WP_ADEMAIL --allow-root

#Create a new user in WordPress with the role "subscriber":
#$WP_USER1: Username
#$WP_EMAIL1: User Email
#--user_pass=$WP_PASS1: User Password
#The --allow-root option again allows you to run this command as root.
wp user create $WP_USER1 $WP_EMAIL1 --role=subscriber --user_pass=$WP_PASS1 --allow-root
fi

#Run PHP FastCGI Process Manager (FPM) version 8.1 in a mode that does not 
#make it a daemon (it runs in the foreground). This is needed to process PHP requests on the server.
/usr/sbin/php-fpm81 -F