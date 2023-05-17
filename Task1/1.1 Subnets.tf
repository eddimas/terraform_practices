# Public Subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}


# Private Subnets

resource "aws_subnet" "private_subnet" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}
