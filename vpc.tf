resource "aws_vpc" "vpc1" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "terraform-vpc"
    Env  = "Dev"
    Team = "DevOps"
  }
}
resource "aws_internet_gateway" "gwy1" {
  vpc_id = aws_vpc.vpc1.id
}
# Public Subnet 
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "192.168.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet1"
    Env  = "DevOps"

  }

}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = " public-subnet2"
    Env  = "DevOps"
  }

}
# Private Subnet

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet1"
    Env  = "DevOps"
  }

}
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet1"
    Env  = "DevOps"
  }
}
# Elastic Ip And Gateway
resource "aws_eip" "eip" {

}
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id
}

#Public Route Table

resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwy1.id
  }

}
# Private Route 

resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}


## Subnet And Route Table Association 

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpublic.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpublic.id
}
