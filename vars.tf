####################################
# define local variables

locals {
  smsv2-site-name = "${var.prefix}-ce-aws-${random_id.xc-mcn-random-id.hex}"
  today-timestamp = timestamp()
}


####################################
# define planet wide vars :-)

variable "prefix" {
  description = "prefix for created objects"
  type        = string
}


####################################
# define AWS wide vars

variable "aws_region" {
  description = "AWS region to run the deployment"
  type        = string
}

variable "aws_availability_zone" {
  description = "AWS availability zone to run the deployment"
  type        = string
}


####################################
# AWS tags

variable "tag_source_git" {
  type = string
}

variable "tag_owner" {
  type = string
}


####################################
# AWS Docker node

variable "docker-instance-type" {
  description = "AWS EC2 instance type for Docker node"
  type        = string
}

variable "docker-storage-size" {
  description = "Docker node root disk size in GB"
  type        = number
}

variable "docker-node-user" {
  description = "Docker node user"
  type        = string
}

variable "docker-pub-key" {
  description = "SSH public key"
  type        = string
}

####################################
# AWS F5XC CE node

variable "f5xc-sms-instance-type" {
  description = "AWS EC2 instance type for F5XC CE"
  type        = string
}

variable "f5xc-sms-storage-size" {
  description = "F5XC CE root disk size in GB"
  type        = number
}

variable "ce-node-user" {
  description = "F5XC CE node user"
  type        = string
}


####################################
# XC LB related vars

# tenant
variable "xc_tenant" {
  type = string
}

# namespace
variable "xc_namespace" {
  type = string
}

# pool member backend IP address
variable "xc_origin_ip1" {
  type = string
}

# origin pool service port
variable "xc_pub_app_port" {
  type = string
}

# origin pool no TLS
variable "xc_pub_app_no_tls" {
  type = string
}

# application domain
variable "xc_app_domain" {
  type = string
}