# centos7-wordpress AWS Edition!

This is a Centos 7 based images optimized to work with AWS.

It has the latest Nginx, PHP7 and Letsencrypt certbot binaries installed.

We're assuming you are running this under the ec2-user, thus all the config files have been updated so that this user is created and the services are run as that user.

Example setup:

# Database setup

  docker run --restart=always --name wordpressdb -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress -d -p 3306:3306 mysql:5.7

# Start the Wordpress container

  docker run -d -p 80:80 -p 443:443--link wordpressdb:db binkybong/centos7-wordpress-aws

When configuring your database, select "db" as the host and the password supplied in the database setup.

