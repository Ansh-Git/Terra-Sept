terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  

}

# VPC Delcaration ->
resource "aws_vpc" "Test-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Terra-Test-VPC"
  }
}

# Internet Gateway Declaration ->

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Test-VPC.id

  tags = {
    Name = "Test-Gateway"
  }
}

# Private Subnet 
resource "aws_subnet" "Private-subnet" {
  vpc_id     = aws_vpc.Test-VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Terra-Private-Subnet"
  }
}

resource "aws_subnet" "Public-subnet" {
  vpc_id     = aws_vpc.Test-VPC.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Terra-Public-Subnet"
  }
}

resource "aws_security_group" "Test_allow_web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Test-VPC.id

  
  
  ingress {
    description      = "HTTP Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   
  ingress {
    description      = "SSH Traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #-1 means Any Protocol
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Test_allow_Web_access"
  }
}

# Create interface with an ip in the subnet 

resource "aws_network_interface" "Test-server-nic" {
  subnet_id       = aws_subnet.Private-subnet.id
  private_ips     = ["10.0.1.40"]
  security_groups = [aws_security_group.Test_allow_web.id]

   }


# Create AWS Elastic IP

resource "aws_eip" "elastic-ip-1" {
  vpc                       = true
  network_interface         = aws_network_interface.Test-server-nic.id
  associate_with_private_ip = "10.0.1.40"
  depends_on                = [aws_internet_gateway.gw]
}

# Ec2 Resource for Private
resource "aws_instance" "Test-instance-1" {
  ami               = "ami-0c1a7f89451184c8b"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "VPC-Sep-Key"
  

  tags = {
    Name = "Terra-Test-instance-1"
  }
}

# Ec2 Resource for Hosting Connection
resource "aws_instance" "Test-instance-2" {
  ami               = "ami-0c1a7f89451184c8b"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "VPC-Sep-Key"
  

  tags = {
    Name = "Terra-Test-instance-2"
  }
}