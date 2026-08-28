####################################
# F5XC Secure Mesh Site v2

resource "volterra_securemesh_site_v2" "xc" {
  name      = local.smsv2-site-name
  namespace = "system"

  block_all_services      = true
  logs_streaming_disabled = true
  enable_ha               = false

  labels = {
    "ves.io/provider" = "ves-io-AWS"
  }

  re_select {
    geo_proximity = true
  }

  aws {
    not_managed {}
  }

  lifecycle {
    ignore_changes = [
      labels
    ]
  }
}


####################################
# F5XC CE token

resource "volterra_token" "xc" {
  name      = "${var.prefix}-token-${random_id.xc-mcn-random-id.hex}"
  namespace = "system"
  type      = "1"
  site_name = volterra_securemesh_site_v2.xc.name

  depends_on = [
    volterra_securemesh_site_v2.xc
  ]
}


####################################
# Find current F5XC CE AMI
#
# f5xc_ami is copied from:
# F5XC Console -> Site -> ... -> Copy image name

data "aws_ami" "f5xc" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.f5xc_ami]
  }

  owners = [
    "434481986642",
    "679593333241"
  ]
}


####################################
# F5XC outside / SLO ENI

resource "aws_network_interface" "f5xc_slo" {
  subnet_id = aws_subnet.slo.id
  source_dest_check = false

  security_groups = [
    aws_security_group.f5xc_slo.id
  ]

  tags = {
    Name   = "${var.prefix}-f5xc-slo"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}


####################################
# F5XC inside / SLI ENI

resource "aws_network_interface" "f5xc_sli" {
  subnet_id = aws_subnet.sli.id
  source_dest_check = false

  security_groups = [
    aws_security_group.f5xc_sli.id
  ]

  tags = {
    Name   = "${var.prefix}-f5xc-sli"
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }
}


####################################
# F5XC CE EC2

resource "aws_instance" "f5xc_nodes" {
  ami           = data.aws_ami.f5xc.id
  instance_type = var.f5xc-sms-instance-type

  # source_dest_check = false

  key_name = aws_key_pair.f5xc.key_name

  user_data = templatefile("${path.module}/xc-ce-data.tpl", {
    cluster_name = local.smsv2-site-name
    token        = volterra_token.xc.id
  })

  root_block_device {
    volume_size           = var.f5xc-sms-storage-size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  ##################################
  # SLO / outside

  network_interface {
    network_interface_id = aws_network_interface.f5xc_slo.id
    device_index         = 0
  }

  ##################################
  # SLI / inside

  network_interface {
    network_interface_id = aws_network_interface.f5xc_sli.id
    device_index         = 1
  }

  tags = {
    Name   = local.smsv2-site-name
    source = var.tag_source_git
    owner  = var.tag_owner
    host   = local.hostname
    create = local.today-timestamp
  }

  depends_on = [
    volterra_securemesh_site_v2.xc
  ]
}


####################################
# Public IP for SLO

resource "aws_eip" "f5xc_slo" {
  domain = "vpc"

  tags = {
    Name   = "${var.prefix}-f5xc-slo-eip"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}


resource "aws_eip_association" "f5xc_slo" {
  network_interface_id = aws_network_interface.f5xc_slo.id
  allocation_id        = aws_eip.f5xc_slo.id
}


####################################
# SSH key

resource "aws_key_pair" "f5xc" {
  key_name   = "${var.prefix}-f5xc"
  public_key = file(var.docker-pub-key)
}