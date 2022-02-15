#!/bin/bash
sudo yum install httpd -y
sudo amazon-linux-extras install lamp-mariadb10.2-php7.2 php7.2 -y
sudo systemctl start httpd
cd /var/www/html
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
cd wordpress
sudo cp wp-config-sample.php wp-config.php
sudo sed -i 's/database_name_here/mydb/g' wp-config.php
sudo sed -i 's/username_here/gamirjan/g' wp-config.php
sudo sed -i 's/password_here/gamirjan123/g' wp-config.php
sudo sed -i 's/localhost/${hostname}/g' wp-config.php     
sudo mv * .. 
sudo systemctl restart httpd
