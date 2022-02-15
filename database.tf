/* MYSQL DATABASE IN RDS */

resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  username               = "gamirjan"
  password               = "gamirjan123"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rdssg.id]
}

