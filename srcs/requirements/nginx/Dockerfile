#We start with the Alpine image version 3.17.5. 
#Alpine is a lightweight Linux image, a good choice for many web applications
FROM alpine:3.17.5

#Update the package list and install the Nginx web server. This is the basic setup for the server
RUN apk update && apk upgrade && apk add --no-cache nginx

#Copy the Nginx configuration file from the local ./requirements/nginx/conf/ folder 
#to the /etc/nginx/http.d/ folder inside the Docker container. This file contains Nginx settings
COPY ./requirements/nginx/conf/nginx.conf /etc/nginx/http.d/nginx.conf

#Add the wget, curl, and openssl utilities to the container. 
#These tools are used to download files and work with SSL certificates
RUN apk update && apk add --no-cache wget curl openssl

#Set the working directory /etc/nginx/ssl. SSL certificates will be stored here
WORKDIR /etc/nginx/ssl
#Download the mkcert tool for creating SSL certificates. 
#Find it on GitHub, download it and make it executable
RUN curl -s https://api.github.com/repos/FiloSottile/mkcert/releases/latest \
    | grep browser_download_url \
    | grep linux-amd64 \
    | cut -d '"' -f 4 \
    | wget -qi - \
    && mv mkcert-v*-linux-amd64 mkcert \
    && chmod a+x mkcert
#Use mkcert to create an SSL certificate and key for the domain tmazitov.42.fr. 
#After that, rename the files and delete mkcert
RUN ./mkcert tmazitov.42.fr \
    && mv tmazitov.42.fr-key.pem tmazitov.42.fr.key \
    && mv tmazitov.42.fr.pem tmazitov.42.fr.crt \
    && rm mkcert
#Back to the root directory 
WORKDIR /

#Set permissions on the Nginx configuration file. This is done for security and correct operation
RUN chmod 644 /etc/nginx/http.d/nginx.conf

#Change the owner of the /etc/nginx/http.d folder to the nginx user. This is done for security reasons
RUN chown -R nginx:nginx /etc/nginx/http.d

#Set permissions on the SSL certificate and key. This is necessary for security
RUN chmod 600 /etc/nginx/ssl/tmazitov.42.fr.crt
RUN chmod 600 /etc/nginx/ssl/tmazitov.42.fr.key

#Change the owner again, but now for two folders: /etc/nginx/http.d and /etc/nginx/ssl. 
#This is done for security and correct operation of the server
RUN chown -R nginx:nginx /etc/nginx/http.d /etc/nginx/ssl

#Open port 443 for SSL connections. This is the port on which the web server will run
EXPOSE 443

#Specify the command to start Nginx. 
#The daemon off; parameter says that the server should run in the background.
CMD ["nginx", "-g", "daemon off;"]