####################################
# AWS VPC

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name   = "${var.prefix}-vpc"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}


####################################
# Internet Gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name   = "${var.prefix}-igw"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# SLO / Outside subnet

resource "aws_subnet" "slo" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = var.aws_availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name   = "${var.prefix}-slo"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# SLI / Inside subnet

resource "aws_subnet" "sli" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = var.aws_az

  tags = {
    Name   = "${var.prefix}-sli"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# Public route table
# Internet access via IGW

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name   = "${var.prefix}-public-rt"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# SLO -> public route table

resource "aws_route_table_association" "slo" {
  subnet_id      = aws_subnet.slo.id
  route_table_id = aws_route_table.public.id
}


####################################
# SLI route table
#
# No default Internet route here.

resource "aws_route_table" "sli" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name   = "${var.prefix}-sli-rt"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


resource "aws_route_table_association" "sli" {
  subnet_id      = aws_subnet.sli.id
  route_table_id = aws_route_table.public.id
}