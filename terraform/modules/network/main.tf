resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.environment}-private-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "compute_sg" {
  name        = "${var.environment}-compute-security-group"
  description = "Regulate secure traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow secure SSH ingress routing"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "admin_key" {
  key_name   = "junior-devops-admin-key"
  public_key = file("~/.ssh/junior-devops-admin-key.pub")
}

# (Keep all your existing VPC, Subnet, and Gateway rules in the string, just add this to the bottom)

resource "aws_instance" "backend_server" {
  ami           = "ami-0c7217cdde317cfec" # Predefined baseline Ubuntu Linux Image
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id # Places the VM securely inside your isolated tier

  # Attach your secure traffic controls firewall
  vpc_security_group_ids = [aws_security_group.compute_sg.id]
  key_name               = aws_key_pair.admin_key.key_name

  tags = {
    Name        = "${var.environment}-compute-vm"
    Environment = var.environment
  }
}
