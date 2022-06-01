# ~~ VPC ~~
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = local.name
  }
}

# ~~ Subnets ~~
resource "aws_subnet" "public_az_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-az-a"
  }
}

resource "aws_subnet" "public_az_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-az-c"
  }
}

# ~~ Subnets ~~
resource "aws_subnet" "private_az_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name}-private-az-a"
  }
}

resource "aws_subnet" "private_az_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name}-private-az-c"
  }
}

# ~~ Internet Gateway ~~
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.name
  }
}

# ~~ Route Table ~~
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = local.name
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_az_a" {
  subnet_id      = aws_subnet.public_az_a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_az_c" {
  subnet_id      = aws_subnet.public_az_c.id
  route_table_id = aws_route_table.main.id
}
