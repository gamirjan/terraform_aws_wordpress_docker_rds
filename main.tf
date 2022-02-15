terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.2"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

/* MAIN INSTANCE */

resource "aws_instance" "wordpress" {
  ami                    = "ami-0a8b4cd432b1c3063"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data = file("file.sh")
  #user_data = templatefile("file.sh.tpl", {
  #  hostname = aws_db_instance.mysql_db.endpoint
  #})
  key_name = aws_key_pair.kp.id
  tags = {
    Name = "Wordpress"
  }
  depends_on = [
    aws_key_pair.kp
  ]

}

output "wordpress_ip" {
  value       = aws_instance.wordpress.public_dns
  description = "The public IP address of the main server instance."
}
