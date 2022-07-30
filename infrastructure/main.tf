terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id

  // 256 available IPs
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.main.id

  // 256 available IPs
  cidr_block        = "10.0.101.0/24"
  availability_zone = "ap-southeast-2b"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.main.id

  // 256 available IPs
  cidr_block        = "10.0.102.0/24"
  availability_zone = "ap-southeast-2c"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "web_security_group" {
  name        = "Web security group"
  description = "Security group for the ec2 instance"

  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow all HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound trafic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "Datbase security group"
  description = "Security group for the rds instance"

  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow posgresql traffic from web server only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_security_group.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "database_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_db_instance" "default" {
  allocated_storage      = 8
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = "db.t3.micro"
  db_name                = "postgresDatabase"
  username               = "postgres"
  password               = "changeme"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  skip_final_snapshot    = true
}


