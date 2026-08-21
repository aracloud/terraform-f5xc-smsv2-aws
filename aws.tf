####################################
# AWS resource definitions

resource "aws_vpc" "aws_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name   = "${var.prefix}-network"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}

resource "aws_subnet" "aws_sn" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.aws_availability_zone

  tags = {
    Name   = "${var.prefix}-sn-internal"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}

resource "aws_security_group" "aws_sg" {
  name        = "${var.prefix}-sg"
  description = "Security Group for F5XC CE"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    description = "Allow SSH"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow TCP 65500"
    protocol    = "tcp"
    from_port   = 65500
    to_port     = 65500
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${var.prefix}-sg"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}

resource "aws_route_table" "aws_rt" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "${var.prefix}-rt"
  }
}

resource "aws_route_table_association" "aws_rta" {
  subnet_id      = aws_subnet.aws_sn.id
  route_table_id = aws_route_table.aws_rt.id
}

