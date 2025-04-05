#Specifies that the base image for our Docker container will be Alpine Linux version 3.17.5. 
#Alpine is a lightweight Linux distribution
FROM alpine:3.17.5

#Declare arguments that will be available during the image build. 
#These variables will be used in scripts to create the database and users
ARG DB_NAME \
    DB_USER \
    DB_PASS \
    DB_ROOT

#Updates the packages in Alpine and installs MariaDB and its client. 
#The --no-cache flag means the cache won't be stored, reducing the image size
RUN apk update && apk add --no-cache mariadb mariadb-client

#Creates the directory /var/run/mysqld, where the MariaDB socket file will be stored
RUN mkdir /var/run/mysqld; \
    #Sets the permissions to 777 on this directory, allowing all users to access it
    chmod 777 /var/run/mysqld; \
    #Starts a block of commands that will create a configuration file for MariaDB
    { echo '[mysqld]'; \
      #Disables host caching
      echo 'skip-host-cache'; \
      #Disables DNS name resolution
      echo 'skip-name-resolve'; \
      #Allows MariaDB to accept connections from any IP address
      echo 'bind-address=0.0.0.0'; \
    #Writes all these commands to the file /etc/my.cnf.d/docker.cnf
    } | tee  /etc/my.cnf.d/docker.cnf; \
    #Alters the skip-networking setting in the mariadb-server.cnf configuration file to allow network connections
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

#Initializes the MariaDB database with the specified parameters
#--user=mysql: The database server must run as the mysql user. This is for security reasons, 
#so that the server process does not run as the root user
#--datadir=/var/lib/mysql: This is the location where the database files will be stored
#/var/lib/mysql is the default directory for MariaDB and MySQL data storage on most Linux systems
RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

#This line tells Docker that the container will listen on port 3306, which is the standard port for MariaDB and MySQL
EXPOSE 3306

#Copies the local script create_db.sh into the container's working directory
COPY requirements/mariadb/conf/create_db.sh .
#Executes the create_db.sh script to create the database and then removes it
RUN sh create_db.sh && rm create_db.sh

#Specifies that all subsequent commands in this Dockerfile will be run as the mysql user
USER mysql

#The command that will be run when the container starts. 
#Here, MariaDB is started with the --skip-log-error option, which disables error logging
CMD ["/usr/bin/mariadbd", "--skip-log-error"]