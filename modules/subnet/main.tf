resource "aws_subnet" "myapp-subnet" {
  vpc_id  = var.vpc_id
  cidr_block = var.vpc-cd_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.enviroment}-subnet"
  }
}


resource "aws_default_route_table" "myapp-rtb" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }


  tags = {
    Name = "${var.enviroment}-default rtb"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.enviroment}-igw"
  }
}

