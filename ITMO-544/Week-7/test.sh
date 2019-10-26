sudo apt-get -y update
sudo apt-get -y install apache2

sudo apt-get -y install php php-gd mysql-server php-mysql php-mysql mysql-server  php7.2.xml simplexml
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
            >&2 echo 'ERROR: Invalid installer signature'
                rm composer-setup.php
                    exit 1
            fi

            php composer-setup.php --quiet
            RESULT=$?
            rm composer-setup.php
            exit $RESULT


php -d memory_limit=-1 composer.phar require aws/aws-sdk-php



sudo systemctl enable apache2
sudo systemctl start apache2
cd ~/.ssh
git clone https://github.com/illinoistech-itm/pjain24
sudo cp pjain24 /
sudo cp /pjain24/ITMO-544/Week-7/index.php /var/www/html