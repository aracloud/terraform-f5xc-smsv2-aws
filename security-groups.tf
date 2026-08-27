####################################
# Security Group - Docker Backend

resource "aws_security_group" "docker" {
  name        = "${var.prefix}-docker-sg"
  description = "Security group for Docker backend"
  vpc_id      = aws_vpc.main.id

  # SSH - temporarily open for administration
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application traffic from F5XC
  ingress {
    description = "Application from F5XC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.102.0/24"]
  }

  # ICMP from F5XC
  ingress {
    description = "ICMP from F5XC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.102.0/24"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${var.prefix}-docker-sg"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# Security Group - F5XC SLO

resource "aws_security_group" "f5xc_slo" {
  name        = "${var.prefix}-f5xc-slo-sg"
  description = "F5XC CE SLO interface"
  vpc_id      = aws_vpc.main.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # F5XC tunnel
  ingress {
    description = "F5XC tunnel"
    from_port   = 6080
    to_port     = 6080
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # F5XC registration / control traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${var.prefix}-f5xc-slo-sg"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


####################################
# Security Group - F5XC SLI

resource "aws_security_group" "f5xc_sli" {
  name        = "${var.prefix}-f5xc-sli-sg"
  description = "F5XC CE SLI interface"
  vpc_id      = aws_vpc.main.id

  # F5XC to backend
  ingress {
    description = "Application traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.103.0/24"]
  }

  # ICMP
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.103.0/24"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "${var.prefix}-f5xc-sli-sg"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}