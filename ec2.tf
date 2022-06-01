resource "aws_instance" "first" {
  ami                         = "ami-02c3627b04781eada"
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
