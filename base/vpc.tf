resource "aws_vpc" "personal" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Personal"
  }
}

resource "aws_internet_gateway" "personal" {}

resource "aws_internet_gateway_attachment" "personal" {
  internet_gateway_id = aws_internet_gateway.personal.id
  vpc_id              = aws_vpc.personal.id
}

resource "aws_subnet" "personal" {
  vpc_id                  = aws_vpc.personal.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 0"
  }
}

resource "aws_route_table" "personal" {
  vpc_id = aws_vpc.personal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.personal.id
  }
}

resource "aws_route_table_association" "personal" {
  subnet_id      = aws_subnet.personal.id
  route_table_id = aws_route_table.personal.id
}

resource "aws_subnet" "personal_private" {
  vpc_id            = aws_vpc.personal.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet 0"
  }
}

resource "aws_subnet" "personal_private_1" {
  vpc_id            = aws_vpc.personal.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet 1"
  }
}
