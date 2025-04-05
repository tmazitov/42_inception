#!/bin/sh

#Checks if the directory /var/lib/mysql/mysql already exists. 
#If it does not, then everything inside this conditional block will be executed
if [ ! -d "/var/lib/mysql/mysql" ]; then
        #changes the owner and group for the directory /var/lib/mysql 
        #and all its contents to the user and group mysql
        chown -R mysql:mysql /var/lib/mysql

        #Initialize the database
        #--basedir=/usr: The location of MySQL/MariaDB executable files
        #--datadir=/var/lib/mysql: The directory where data will be stored
        #--user=mysql: The user under which the process will run
        #--rpm: Used when initializing from an RPM package, sets some default options
        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

        #Create a temporary file and stores its name in the variable tfile
        #Check if the temporary file was successfully created
        #If the temporary file was not created, the script will return an error code of 1
        #Whether there is enough disk space for creating temporary files, 
        #which is important for stable operation of the database
        tfile=`mktemp`
        if [ ! -f "$tfile" ]; then
                return 1
        fi
fi

#Check if the directory /var/lib/mysql/wordpress already exists. 
#If it does not, the script will execute the commands within the if conditional block. 
#This is done to avoid overwriting an existing database
if [ ! -d "/var/lib/mysql/wordpress" ]; then
        #Begin creating a file /tmp/create_db.sql where SQL commands will be written. 
        #The text between EOF will be saved in this file.
        cat << EOF > /tmp/create_db.sql
#Select the MySQL system database for executing subsequent commands
USE mysql;

#Refresh the privileges to ensure that all changes take effect
FLUSH PRIVILEGES;

#Delete all accounts without a username
DELETE FROM     mysql.user WHERE User='';

#Delete a test database named 'test'
DROP DATABASE test;

#Delete privileges associated with the test database
DELETE FROM mysql.db WHERE Db='test';

#Remove access to the root account from any hosts other than localhost, 127.0.0.1, and ::1
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

#Change the password for the root user to the value stored in the ${DB_ROOT} variable
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';

#Create a new database with the name stored in the ${DB_NAME} variable and sets its character set and collation rules
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;

#Create a new user with the name and password stored in the ${DB_USER} and ${DB_PASS} variables
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';

#Grant the new user all privileges on the wordpress database
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;

#End the writing to the file /tmp/create_db.sql
EOF
        #Start the MySQL server with the user mysql and initializes it by executing the commands 
        #from the file /tmp/create_db.sql (run init.sql)
        /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
        #Delete the temporary file /tmp/create_db.sql
        rm -f /tmp/create_db.sql
fi