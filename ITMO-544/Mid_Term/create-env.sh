sudo apt-get -y update
sudo apt-get -y install apache2

sudo systemctl enable apache2
sudo systemctl start apache2

sudo apt-get install php 
# make sure libapache2-mod-php7.2 is there
sudo apt-get install php-gd mysql-server
#library for image processing 
