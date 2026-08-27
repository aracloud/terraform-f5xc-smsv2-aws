####################################
# AWS Docker host running workloads

resource "aws_network_interface" "aws_nic_dkr" {
  subnet_id = aws_subnet.aws_sn.id

  private_ips = [
    var.xc_origin_ip1
  ]

  security_groups = [
    aws_security_group.aws_sg.id
  ]

  tags = {
    Name   = "${var.prefix}-nic-dkr"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}


resource "aws_instance" "aws_dkr" {
  ami           = data.aws_ami.debian.id
  instance_type = var.docker-instance-type

  network_interface {
    network_interface_id = aws_network_interface.aws_nic_dkr.id
    device_index         = 0
  }

  key_name = aws_key_pair.docker.key_name

  root_block_device {
    volume_size = var.docker-storage-size
    volume_type = "gp3"
  }

  user_data = file("${path.module}/docker-data.tpl")

  tags = {
    Name   = "${var.prefix}-dkr-node"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}


resource "aws_eip" "aws_pip_dkr" {
  domain = "vpc"

  tags = {
    Name   = "${var.prefix}-eip-dkr"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}


resource "aws_eip_association" "aws_pip_dkr" {
  network_interface_id = aws_network_interface.aws_nic_dkr.id
  allocation_id        = aws_eip.aws_pip_dkr.id
}

resource "aws_key_pair" "docker" {
  key_name   = "${var.prefix}-docker"
  public_key = file(var.docker-pub-key)
}