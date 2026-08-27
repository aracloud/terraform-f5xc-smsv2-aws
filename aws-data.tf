data "aws_ami" "debian" {
  most_recent = true

  owners = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-13-amd64-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
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

data "aws_ssm_parameter" "f5xc_ce_ami" {
  name = "/aws/service/marketplace/prod-wrwzhcymymama/latest"
}