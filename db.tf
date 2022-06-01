resource "aws_db_subnet_group" "main" {
  name        = "db-subnet-${local.name}"
  description = "RDS for MySQL"

  subnet_ids = [
    aws_subnet.private_az_a.id,
    aws_subnet.private_az_c.id,
  ]
}

resource "aws_db_instance" "first" {
  identifier     = "db-${local.name}"
  engine         = "mysql"
  engine_version = "8.0.20"

  instance_class        = "db.t3.micro"
  storage_type          = "gp2"
  allocated_storage     = "20"
  max_allocated_storage = "1000"

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  publicly_accessible    = false
  availability_zone      = "ap-northeast-1a"

  username = "admin"
  password = var.db_password
  db_name  = "wordpress"

  iam_database_authentication_enabled = false

  storage_encrypted   = false
  skip_final_snapshot = true
}
