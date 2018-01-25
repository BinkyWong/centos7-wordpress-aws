# centos7-wordpress AWS Edition!

This is a Centos 7 based image optimized to work with AWS.

It has the latest Nginx, PHP7 and Letsencrypt certbot binaries installed. It has the latest version of wordpress at the time of build. You can of course install your down version.

We're assuming you are running this under the ec2-user, thus all the config files have been updated so that this user is created and the services are run as that user. All config files have been created with the default user. If I have more time in the future, I may add it as a config variable to change it when creating a new container.

Example setup:

# Build your own

  git clone https://github.com/BinkyWong/centos7-wordpress-aws.git

  cd centos7-wordpress-aws

  docker build -t centos7-wordpress-aws .

# Database setup

  docker run --restart=always --name wordpressdb -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress -d -p 3306:3306 mysql:5.7

Obviously - you'll need to change the password.

If you need to, you can setup phpMyAdmin to connect to it:

  docker run --restart=always --name myadmin -d --link wordpressdb:db -p 8080:80 phpmyadmin/phpmyadmin

# Start the Wordpress container

  docker run --restart=always --name wordpress -d -p 80:80 -p 443:443--link wordpressdb:db binkybong/centos7-wordpress-aws

When configuring your database, select "db" as the host and the password supplied in the database setup.

# Setting up a cront job to autorenew the SSL cert

  0 0 1 */2 * docker exec -it nginx certbot renew

# More advanced setup mapping root html, nginx and letsencrypt configuration

  docker run -d -p 80:80 -p 443:443 --link wordpressdb:db --restart=always \\

  -v /home/ec2-user/websites/mysite/www/html:/var/www/html \\

  -v /home/ec2-user/websites/mysite/etc/nginx:/etc/nginx \\

  -v /home/ec2-user/websites/mysite/etc/letsencrypt:/etc/letsencrypt \\

  --name wordpress \\

  binkybong/centos7-wordpress-aws

# Getting a shell

  docker exec -it wordpress /bin/bash

# References

https://certbot.eff.org/#centosrhel7-nginx


