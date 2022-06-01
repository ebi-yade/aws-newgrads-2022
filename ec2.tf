resource "aws_instance" "first" {
  ami                         = "ami-02c3627b04781eada" // Amazon Linux
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_az_a.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = "8"
    volume_type = "gp2"
  }

  user_data = file("user_data.sh")

  tags = {
    Name = "webserver#1-${local.name}"
  }
}

resource "aws_instance" "second" {
  ami                         = "ami-00e10dee6f3a3ec1a" // Created from "first"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_az_c.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = "8"
    volume_type = "gp2"
  }

  // Unnecessary because wordpress already installed by the AMI
  // user_data = file("user_data.sh")

  tags = {
    Name = "webserver#2-${local.name}"
  }
}
