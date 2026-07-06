#!/usr/bin/env python3
import os

print("⚡ Starting automated configuration code injection...")

# 1. Define the code contents
variables_code = """variable "vpc_cidr" {
  type        = string
  description = "The base IP range (CIDR) for the entire VPC network"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The IP segment allocated for public-facing assets"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "The isolated IP segment allocated for backend compute workloads"
  default     = "10.0.2.0/24"
}

variable "environment" {
  type        = string
  description = "Deployment environment name tag"
  default     = "dev"
}
"""

main_module_code = """resource "aws_vpc" "main" {
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
    Name        = "${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-private-subnet"
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
"""

outputs_code = """output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_id" {
  value = aws_subnet.public.id
}
output "private_subnet_id" {
  value = aws_subnet.private.id
}
output "security_group_id" {
  value = aws_security_group.compute_sg.id
}
"""

root_main_code = """terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "dev_network" {
  source              = "./modules/network"
  environment         = "development"
  vpc_cidr            = "10.10.0.0/16"
  public_subnet_cidr  = "10.10.1.0/24"
  private_subnet_cidr = "10.10.2.0/24"
}
"""

# 2. Write mappings
file_mappings = {
    os.path.join("modules", "network", "variables.tf"): variables_code,
    os.path.join("modules", "network", "main.tf"): main_module_code,
    os.path.join("modules", "network", "outputs.tf"): outputs_code,
    "main.tf": root_main_code
}

# 3. Execute write loop
for path, content in file_mappings.items():
    with open(path, "w") as target_file:
        target_file.write(content)
    print(f"✍️  Successfully populated parameters inside: {path}")

print("✨ All configurations systematically injected by automation!")
