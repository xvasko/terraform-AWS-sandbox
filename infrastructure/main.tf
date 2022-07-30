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
