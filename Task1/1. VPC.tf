resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "My VPC"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My Internet Gateway"
  }
}

resource "aws_eip" "my_eip" {
  vpc = true
  tags = {
    Name = "My EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.my_eip.id
  depends_on    = [aws_internet_gateway.my_igw]

  tags = {
    Name = "NAT Gateway"
  }
}