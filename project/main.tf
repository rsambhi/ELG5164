# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Providers
provider "aws" {
  region = var.region
}

# RESOURCES

# VPC
resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
}

# SUBNET
resource "aws_subnet" "subnet1" {
  cidr_block              = var.subnet1_cidr
  vpc_id                  = aws_vpc.vpc1.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]
}

# Internet gateway
resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.vpc1.id
}

# Route table
resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }
}

# Route table association
resource "aws_route_table_association" "route-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
}

# AWS key pair
resource "aws_key_pair" "tf_key" {
  key_name   = "tf_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Private key file
resource "local_file" "tf_key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "tf_key.pem"
  file_permission = "0400"
}


# Security group
resource "aws_security_group" "sg-ecnode-instance" {
  name   = "ecnode_sg"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

# AWS instance
resource "aws_instance" "ecnode1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg-ecnode-instance.id]
  key_name               = var.ssh_key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }
}

# Ansible inventory file
resource "local_file" "inventory" {
  filename = "./hosts"
  content  = <<EOF
[webserver]
${aws_instance.ecnode1.public_ip} ansible_connection=ssh   ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${var.private_key_path}
EOF
}

# Data
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
