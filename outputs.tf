output "hostname" {
  value = local.hostname
}

output "sitename" {
  value = local.smsv2-site-name
}

output "f5xc_slo_nic" {
  description = "F5 XC Node SLO (Outside) Interface Details"
  value = {
    id         = aws_network_interface.f5xc_slo.id
    private_ip = aws_network_interface.f5xc_slo.private_ip
    public_ip  = aws_eip_association.f5xc_slo.public_ip
    subnet_id  = aws_network_interface.f5xc_slo.subnet_id
  }
}

output "f5xc_sli_nic" {
  description = "F5 XC Node SLI (Inside) Interface Details"
  value = {
    id         = aws_network_interface.f5xc_sli.id
    private_ip = aws_network_interface.f5xc_sli.private_ip
    subnet_id  = aws_network_interface.f5xc_sli.subnet_id
  }
}
