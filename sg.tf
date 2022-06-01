resource "aws_security_group" "web" {
  name        = "web-${local.name}"
  description = "web-${local.name}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["3.112.23.0/29"]
  }

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = [
      "${var.current_ip}/32",
      "10.0.0.0/16", // internal
    ]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-${local.name}"
  }
}

resource "aws_security_group" "db" {
  name        = "db-${local.name}"
  description = "db-${local.name}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-${local.name}"
  }
}
