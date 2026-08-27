####################################
# F5XC SLO / Outside

resource "aws_security_group" "f5xc_slo" {
  name        = "${var.prefix}-f5xc-slo"
  description = "F5XC CE outside / SLO interface"
  vpc_id      = aws_vpc.main.id

  ##################################
  # SSH

  ingress {
    description = "SSH"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ##################################
  # F5XC management

  ingress {
    description = "F5XC management 65500"
    protocol    = "tcp"
    from_port   = 65500
    to_port     = 65500
    cidr_blocks = ["0.0.0.0/0"]
  }

  ##################################
  # IPsec IKE

  ingress {
    description = "IPsec IKE"
    protocol    = "udp"
    from_port   = 500
    to_port     = 500
    cidr_blocks = ["0.0.0.0/0"]
  }

  ##################################
  # IPsec NAT-T

  ingress {
    description = "IPsec NAT-T"
    protocol    = "udp"
    from_port   = 4500
    to_port     = 4500
    cidr_blocks = ["0.0.0.0/0"]
  }

  ##################################
  # ICMP

  ingress {
    description = "ICMP"
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ##################################
  # Egress

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${var.prefix}-f5xc-slo-sg"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# F5XC SLI / Inside

resource "aws_security_group" "f5xc_sli" {
  name        = "${var.prefix}-f5xc-sli"
  description = "F5XC CE inside / SLI interface"
  vpc_id      = aws_vpc.main.id

  ##################################
  # Internal VPC traffic

  ingress {
    description = "Internal VPC traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["10.0.0.0/16"]
  }

  ##################################
  # Egress

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${var.prefix}-f5xc-sli-sg"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# Docker backend

resource "aws_security_group" "docker" {
  name        = "${var.prefix}-docker"
  description = "Docker backend"
  vpc_id      = aws_vpc.main.id

  ##################################
  # SSH

  ingress {
    description = "SSH"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ##################################
  # Application
  #
  # Restrict this later to the F5XC SLI subnet.

  ingress {
    description = "Application HTTP"
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["10.0.102.0/24"]
  }

  ##################################
  # ICMP from VPC

  ingress {
    description = "ICMP"
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["10.0.0.0/16"]
  }

  ##################################
  # Egress

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${var.prefix}-docker-sg"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}