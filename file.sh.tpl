#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable --now docker
sudo usermod -a -G docker ec2-user
docker run -e WORDPRESS_DB_HOST=${hostname} -e WORDPRESS_DB_USER='gamirjan'  -e WORDPRESS_DB_PASSWORD='gamirjan123' -e WORDPRESS_DB_NAME='mydb' -d -p 80:80 wordpress
