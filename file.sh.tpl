#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable --now docker
sudo usermod -a -G docker ec2-user
docker run -e WORDPRESS_DB_HOST=${hostname} -e WORDPRESS_DB_USER=${username}  -e WORDPRESS_DB_PASSWORD=${password} -e WORDPRESS_DB_NAME=${db_name} -d -p 80:80 wordpress
