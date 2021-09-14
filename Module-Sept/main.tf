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

module "security_group_module_1" {

    source = "./security_group_module"
}

/*module "security_group_module_2" {

    source = "./security_group_module"
}*/

module "ec2_module_1" {
    //security_id = "${module.security_group_module.security_group_id_output}"
    ec2_name = "EC2 1 from Module"
    source = "./ec2_module"
}

module "ec2_module_2" {
    //security_id = "${module.security_group_module.security_group_id_output}"
    ec2_name = "EC2 2 from Module"
    source = "./ec2_module"
}

module "ec2_module_3" {
    //security_id = "${module.security_group_module.security_group_id_output}"
    ec2_name = "EC2 3 from Module"
    source = "./ec2_module"
}

module "s3_bucket_module" {

    source = "./s3_bucket_module"
  
}