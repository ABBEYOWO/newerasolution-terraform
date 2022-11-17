terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.39.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}





resource "aws_vpc" "myapp-vpc" {
  cidr_block   = var.vpc-cd_block

  tags = {
    Name = "${var.enviroment}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  enviroment = var.enviroment
vpc-cd_block = var.vpc-cd_block
avail_zone = var.avail_zone
vpc_id =aws_vpc.myapp-vpc.id 
default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  
}

module "myapp-server" {
  source = "./modules/webserver"
  enviroment = var.enviroment
  avail_zone = var.avail_zone
  my_ip = var.my_ip
  instance_type = var.instance_type
  public_keypair = var.public_keypair
  vpc_id = aws_vpc.myapp-vpc.id
  subnet_id = module.myapp-subnet.subnet-output.id
    
  }

  










