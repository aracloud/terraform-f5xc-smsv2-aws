####################################
# xc resource definitions

# xc smsv2 site
resource "volterra_securemesh_site_v2" "xc-mcn-smsv2-appstack" {
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

# xc ce initialization token 
resource "volterra_token" "xc-mcn-sitetoken" {
  name       = "${var.prefix}-token-${random_id.xc-mcn-random-id.hex}"
  namespace  = "system"
  type       = "1"
  site_name  = local.smsv2-site-name
  depends_on = [volterra_securemesh_site_v2.xc-mcn-smsv2-appstack]
}

resource "aws_network_interface" "f5xc_slo" {
  subnet_id = aws_subnet.slo.id

  security_groups = [
    aws_security_group.f5xc_slo.id
  ]

  tags = {
    Name   = "${var.prefix}-f5xc-slo"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}

resource "aws_network_interface" "f5xc_sli" {
  subnet_id = aws_subnet.sli.id

  security_groups = [
    aws_security_group.f5xc_sli.id
  ]

  tags = {
    Name   = "${var.prefix}-f5xc-sli"
    source = var.tag_source_git
    owner  = var.tag_owner
  }
}

resource "aws_instance" "f5xc_nodes" {
  ami           = var.f5xc_ce_ami_id
  instance_type = var.f5xc-sms-instance-type

  source_dest_check = false

  key_name = aws_key_pair.f5xc.key_name

  network_interface {
    network_interface_id = aws_network_interface.f5xc_slo.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.f5xc_sli.id
    device_index         = 1
  }

  user_data = templatefile("${path.module}/xc-ce-data.tpl", {
    cluster_name = local.smsv2-site-name
    token        = volterra_token.xc-mcn-sitetoken.id
  })

  root_block_device {
    volume_size = var.f5xc-sms-storage-size
    volume_type = "gp3"
  }

  tags = {
    Name   = local.smsv2-site-name
    source = var.tag_source_git
    owner  = var.tag_owner
  }

  depends_on = [
    volterra_securemesh_site_v2.xc-mcn-smsv2-appstack
  ]
}

resource "aws_eip" "f5xc_ce" {
  domain = "vpc"

  tags = {
    Name = "${var.prefix}-eip-ce"
  }
}

resource "aws_eip_association" "f5xc_ce" {
  network_interface_id = aws_network_interface.f5xc_slo.id
  allocation_id        = aws_eip.f5xc_ce.id
}

resource "aws_key_pair" "f5xc" {
  key_name   = "${var.prefix}-f5xc"
  public_key = file(var.docker-pub-key)
}