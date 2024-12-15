resource "aws_vpc" "test_vpc" {
cidr_block = "172.16.0.0/16"
enable_dns_hostnames = true
tags = { Name = "test_vpc" }
}
resource "aws_subnet" "test_sub_pub" {
  vpc_id = aws_vpc.test_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "172.16.1.0/24"
  tags = { Name = "test_sub_pub" }
}
resource "aws_subnet" "test_sub_pvt" {
  vpc_id = aws_vpc.test_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "172.16.5.0/24"
  tags = { Name = "test_sub_pvt" }
}
resource "aws_internet_gateway" "test_igw" {
    vpc_id = aws_vpc.test_vpc.id
    tags = { Name = "test_igw" }
}
resource "aws_route_table" "test_rt" {
    vpc_id = aws_vpc.test_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test_igw.id
    }
    tags = { Name = "test_rt" }
}
resource "aws_route_table_association" "test_rt_a" {
    subnet_id = aws_subnet.test_sub_pub.id
    route_table_id = aws_route_table.test_rt.id  
}
resource "aws_security_group" "test_sg" {
    vpc_id = aws_vpc.test_vpc.id
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }  
}
