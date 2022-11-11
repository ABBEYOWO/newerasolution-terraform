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

variable "enviroment" {}
variable "cidr_block" {}
variable "avail_zone" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}
variable "private_key" {}

resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.enviroment}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet" {
  vpc_id     = aws_vpc.myapp_vpc.id
  availability_zone = var.avail_zone
  cidr_block = var.cidr_block

  tags = {
    Name = "${var.enviroment}-sub"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myyapp-gw.id
  }

  tags = {
    Name = "${var.enviroment}-main-rtb"
  }
}

resource "aws_internet_gateway" "myyapp-gw" {
  vpc_id = aws_vpc.myapp_vpc.id

  tags = {
    Name = "${var.enviroment}-igw"
  }
}

resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.myapp_vpc.id

  ingress {
    protocol  = "tcp"
    cidr_blocks = [var.my_ip]
    from_port = 22
    to_port   = 22
  }

  ingress {
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port   = 8080
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] 
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-subnet.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address  = true
  key_name = aws_key_pair.ssh-key.key_name
  # user_data = file("entry-script.sh")

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key)
  }

  provisioner "file" {
    source = "entry-script.sh"
    destination = "/home/ec2-user/entry-script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash entry-script.sh "
    ]
  }
          
 tags = {
    Name = "${var.enviroment}-Tf-ec2"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)
  }

  output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
    }


   output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
  }