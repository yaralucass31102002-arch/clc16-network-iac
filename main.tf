resource "aws_vpc" "clc_vpc" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-terraform_tf"
  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.clc_vpc.id
  cidr_block       = "172.16.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public_subnet_1a_tf"
  }
}

resource "aws_subnet" "private_subnet_1a_tf" {
  vpc_id = aws_vpc.clc_vpc.id
  cidr_block       = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private_subnet_1a_tf"
  }
}

resource "aws_internet_gateway" "gw_clc_vpc_tf" {
  vpc_id = aws_vpc.clc_vpc.id

  tags = {
    Name = "igw_clc_vpc_tf"
  }
}

resource "aws_route_table" "public_rt_tf" {
  vpc_id = aws_vpc.clc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_clc_vpc_tf.id
  }

  tags = {
    Name = "public_rt_tf"
  }
}

resource "aws_route_table_association" "public_rt" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt_tf.id
}

resource "aws_eip" "eip_nat_gw_1a" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.eip_nat_gw_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "nat_gw_1a_tf"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw_clc_vpc_tf]
}

resource "aws_route_table" "private_rt_1a_tf" {
  vpc_id = aws_vpc.clc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1a.id
  }

  tags = {
    Name = "private_rt_1a_tf"
  }
}

resource "aws_route_table_association" "private_rt_1a_tf" {
  subnet_id      = aws_subnet.private_subnet_1a_tf.id
  route_table_id = aws_route_table.private_rt_1a_tf.id
}