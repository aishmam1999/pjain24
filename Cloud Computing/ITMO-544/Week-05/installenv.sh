sudo apt-get -y update
sudo apt-get -y install apache2

sudo systemctl enable apache2
sudo systemctl start apache2