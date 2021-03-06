/* MYSQL DATABASE IN RDS */

resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_group.name
  vpc_security_group_ids = [aws_security_group.rdssg.id]
}

resource "aws_db_subnet_group" "db_group" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnets.id, aws_subnet.private_subnet2.id]

  tags = {
    Name = "My DB subnet group"
  }
}
