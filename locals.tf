####################################
# Local variables

data "external" "hostname" {
  program = [
    "bash",
    "-c",
    "echo '{\"hostname\":\"'$(hostname)'\"}'"
  ]
}

locals {
  hostname         = data.external.hostname.result.hostname
  today-timestamp  = timestamp()
  smsv2-site-name  = "${var.prefix}-ce-aws-${random_id.xc-mcn-random-id.hex}"
}