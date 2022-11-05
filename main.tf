terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc-deploy-1" {
  cidr_block = var.vpc_cirdir_block
  tags ={
    Name = "vpc-deploy-1 new"
    terraform: "true"
  }
}

variable "vpc_cirdir_block" {
    description = "vpc cirdr deploy-1 block"
  
}

variable "enviroment" {
    description = "name of enviroment"
    
  
}

  


resource "aws_subnet" "vpc-subnet-1" {
  vpc_id     = aws_vpc.vpc-deploy-1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-deploy-1new"
    terraform: "true"
  }
}


  


output "vpc-subnet-1-id" {
    value = aws_vpc.vpc-deploy-1.id

  }

data "aws_vpc" "vpc-data" {
  default = true
}