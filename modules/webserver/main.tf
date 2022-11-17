resource "aws_instance" "myapp-ec2" {
  ami  = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_default_security_group.myapp-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.mykey_pair.key_name
   user_data = file("entry-script.sh")

  tags = {
    Name = "${var.enviroment}-myapp-ec2"
  }
}


resource "aws_default_security_group" "myapp-sg" {
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port   = 8080
  }
  
  ingress {
    protocol  = "tcp"
    cidr_blocks = [var.my_ip]
    from_port = 22
    to_port   = 22
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

resource "aws_key_pair" "mykey_pair" {
  key_name   = "myapp-key"
  public_key = var.public_keypair
}
