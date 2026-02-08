
resource "aws_vpc" "main" {
  cidr_block = var.vpc.cidr_block
  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_subnet" "public" {
  count = var.vpc.public_subnets # 0 to 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc.cidr_block, 2, count.index) # VPC: 10.0.0.0/22 -> New Bits: 2 -> 10.0.0.0/24 -> 10.0.0.0/24
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment}-public-${count.index}"
  }
}


resource "aws_subnet" "private" {
  count = var.vpc.private_subnets # 0 to 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc.cidr_block, 2, var.vpc.public_subnets + count.index) # VPC: 10.0.0.0/22 -> New Bits: 2 -> 10.0.0.0/24 -> 10.0.0.0/24
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment}-private-${count.index}"
  }
}

# snakecase write_something_with_underscore_and_all_lowercase # Python & Terraform
# camelCase writeSomethingWithCamelCase # NodeJS & Golang
# TitleCase WriteSomethingWithTitleCase
resource "aws_eip" "nat_ip" {
  tags = {
    Name = "${var.environment}-nat-ip"
  }
  lifecycle {
    prevent_destroy = false
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.environment}-natgw"
  }
}

# What's the route for public?
# 0.0.0.0/0 -> IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route" "igw_out" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route" "natgw_out" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "public" {
  count = var.vpc.public_subnets
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = var.vpc.private_subnets
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

