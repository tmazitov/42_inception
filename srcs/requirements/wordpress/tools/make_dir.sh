#!/bin/bash

#The script checks if there is a data directory in the current user's home directory. 
#If there is no such directory, the script creates it and two subdirectories inside it: mariadb and wordpress. 
#These directories will be used to store MariaDB database data and WordPress files. 
#This is done to organize data storage in a certain structure, 
#which simplifies server management and configuration
if [ ! -d "/home/${USER}/data" ]; then
        mkdir ~/data
        mkdir ~/data/mariadb
        mkdir ~/data/wordpress
fi