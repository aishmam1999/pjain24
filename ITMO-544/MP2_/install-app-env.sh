#!/bin/bash
cd /home/ubuntu
sudo apt-get -y update
echo "/////////////////////////////////////////////////////////////////installing apache2////////////////////////////////////////////////////"
sudo apt-get -y install apache2
echo "//////////////////////////////////////////////////////////////installing php///////////////////////////////////////////////////////////////"
sudo apt-get -y install php
echo "//////////////////////////////////////////////////////////////installing php-gd/////////////////////////////////////////////////////////////"
sudo apt-get -y install php-gd
echo "///////////////////////////////////////////////////////////////installing mysql-server////////////////////////////////////////////////////////"
sudo apt-get -y install mysql 
sudo apt-get -y install mysql-client
echo "////////////////////////////////////////////////////////////////installing php-mysql/////////////////////////////////////////////////////////"
sudo apt-get -y install php-mysql
echo "//////////////////////////////////////////////////////////////////installing php.2.xml////////////////////////////////////////////////////////"
sudo apt-get -y install php7.2.xml
echo "/////////////////////////////////////////////////////////////////////installing php-xml///////////////////////////////////////////////////"
sudo apt-get -y install php-xml
sudo apt-get -y install unzip zip

echo "///////////////////////////////////////////////////////////////////// aws-cli///////////////////////////////////////////////////"

sudo apt-get -y install awscli

cd /home/ubuntu
pwd
echo "//////////////////////////////////////////////////////////////////////installing composer-setup////////////////////////////////////////////"
 php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
 php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php

cd /home/ubuntu
pwd
echo "///////////////////////////////////////////////compser-setup finished///////////////////////////////////////////////////////////////////////////////"
sudo php -d memory_limit=-1 composer.phar require aws/aws-sdk-php


echo "//////////////////////////////////////////////////// apache enable and start////////////////////////////////////////////////////////////////////////////////"
sudo systemctl enable apache2
sudo systemctl start apache2
cd /home/ubuntu
pwd
echo "/////////////////////////////////////////////////////////////////github repo cloneing ///////////////////////////////////////////////////////////////////////"
#git clone git@github.com:illinoistech-itm/pjain24.git
sudo git clone https://palashjain2801:28011993p.j@github.com/illinoistech-itm/pjain24

echo "//////////////////////////////////////////////////////////////////copying index.php to /var/www/html///////////////////////////////////////////////////"
sudo cp pjain24/ITMO-544/Mid_Term/Frontend/index.php /var/www/html/
sudo cp pjain24/ITMO-544/Mid_Term/Frontend/submit.php /var/www/html/
sudo cp pjain24/ITMO-544/Mid_Term/Frontend/gallery.php /var/www/html/
sudo cp pjain24/ITMO-544/Mid_Term/config  ~/my.cnf
sudo cp pjain24/ITMO-544/Mid_Term/config  /my.cnf
sudo cp pjain24/ITMO-544/Mid_Term/config  /etc/my.cnf




#sudo cp ~/my.cnf ~/.ssh/                                                                                                                                                                                                                                                              

sudo cp pjain24/ITMO-544/Mid_Term/createSchema.sql ~
sudo cp pjain24/ITMO-544/Mid_Term/createSchema.sql /home/ubuntu

mysql --host=pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com -u master < createSchema.sql 

mysql --host=pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com -u master "records"

#mysql --host=pjain24-instance.cvs4vczdbufc.us-east-1.rds.amazonaws.com -u master < createSchema.sql 





 exit $RESULT                                                                                                                                            