
//variable "security_id" {}

variable "ec2_name" {}

resource "aws_instance" "Module-Sep" {
  ami               = "ami-0c1a7f89451184c8b"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "Module_Key_Sep"
  //vpc_security_group_ids = ["${var.security_id}"]
  
  tags = {
      Name = "${var.ec2_name}"
  }

}