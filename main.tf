terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "enviroment" {}
variable "cd_block-2" {}
variable "avail_zone" {}




resource "aws_vpc" "myapp-2" {
  cidr_block  = var.cd_block-2
  

  tags = {
    Name = "${var.enviroment}-vpc"
  }
}


resource "aws_subnet" "my-subnet-2" {
  vpc_id     = aws_vpc.myapp-2.id
  cidr_block = var.cd_block-2
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.enviroment}-subnet"
  }
}

output "vpc-id" {
    value = aws_vpc.myapp-2.id
  
}

output "subnet-id" {
    value = aws_subnet.my-subnet-2.id
  
}

