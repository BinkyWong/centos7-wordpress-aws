#   Centos 7 
#   Now includes letsencrypt certbox and AWS centric config and postfix

FROM centos:centos7

MAINTAINER Andy Wong <pslandywong@hotmail.com>

ADD /contents /

RUN yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional

RUN yum -y install https://extras.getpagespeed.com/release-el7-latest.rpm

RUN yum -y install epel-release

RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum -y update 

# Installing supervisor 

RUN yum install -y python-setuptools 

RUN easy_install pip 

RUN pip install supervisor 


RUN yum -y install nginx nginx-module-nps

#RUN yum install -y mod_php71w php71w-cli php71w-common php71w-gd php71w-mbstring php71w-mcrypt php71w-mysqlnd php71w-xml php71w-fpm nginx1w-module-pagespeed openssl net-tools wget git curl certbot-nginx postfix nmap vim mailx telnet bind-utils iftop iptraf tcpdump htop iperf gcc nginx1w-module-http-image-filter

RUN yum install -y mod_php71w php71w-cli php71w-common php71w-gd php71w-mbstring php71w-mcrypt php71w-mysqlnd php71w-xml php71w-fpm openssl net-tools wget git curl certbot-nginx postfix nmap vim mailx telnet bind-utils iftop iptraf tcpdump htop iperf gcc nginx-mod-http-image-filter

RUN mkdir /var/www/html -p

RUN curl -LO http://wordpress.org/latest.tar.gz                         &&\
    tar xvzf /latest.tar.gz -C /var/www/html --strip-components=1       &&\
    rm /latest.tar.gz 

EXPOSE 80 443

RUN groupadd ec2-user -g 1000

RUN useradd -u 1000 ec2-user -g ec2-user

RUN usermod -aG nginx ec2-user

RUN chown -R ec2-user: /var/www/html

RUN mkdir -p /var/cache/nginx

RUN chown -R ec2-user: /var/cache/nginx

RUN mkdir -p /var/ngx_pagespeed_cache

RUN chown -R nobody:nobody /var/ngx_pagespeed_cache

RUN yum clean all

# Executing supervisord
CMD ["supervisord", "-n"]
