resource "aws_vpc" "Module-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Module-Practise-VPC"
  }
}

resource "aws_security_group" "Module_allow_web" {
  name        = "Module_allow_web"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Module-VPC.id

  ingress {
    description      = "HTTPS Traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
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
    Name = "allow_module_Web_access"
  }
}

output "security_group_id_output" {

  value = "${aws_security_group.Module_allow_web.id}"
  
}

/*output "vpc_id_output" {

  value = "${aws_vpc.Module-VPC}"
  
}*/