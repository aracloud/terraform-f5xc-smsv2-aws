####################################
# General

variable "prefix" {
  description = "Prefix for created objects"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_availability_zone" {
  description = "AWS availability zone"
  type        = string
}

variable "tag_source_git" {
  description = "Source repository"
  type        = string
}

variable "tag_owner" {
  description = "Owner"
  type        = string
}


####################################
# Docker host

variable "docker-instance-type" {
  description = "AWS instance type for Docker host"
  type        = string
  default     = "t3.medium"
}

variable "docker-storage-size" {
  description = "Docker host root disk size in GB"
  type        = number
  default     = 30
}

variable "docker-node-user" {
  description = "Docker host admin user"
  type        = string
}

variable "docker-pub-key" {
  description = "SSH public key"
  type        = string
}


####################################
# F5XC CE

variable "f5xc-sms-instance-type" {
  description = "AWS instance type for F5XC CE"
  type        = string
  default     = "m5.2xlarge"
}

variable "f5xc-sms-storage-size" {
  description = "F5XC CE root disk size in GB"
  type        = number
  default     = 80
}

variable "ce-node-user" {
  description = "F5XC CE admin user"
  type        = string
}

variable "f5xc_ami" {
  description = "F5XC CE AMI name pattern copied from the F5XC Console"
  type        = string
}


####################################
# F5XC

variable "xc_tenant" {
  description = "F5 Distributed Cloud tenant"
  type        = string
}

variable "xc_namespace" {
  description = "F5 Distributed Cloud namespace"
  type        = string
}

variable "xc_origin_ip1" {
  description = "Backend private IP"
  type        = string
}

variable "xc_pub_app_port" {
  description = "Backend application port"
  type        = string
}

variable "xc_pub_app_no_tls" {
  description = "Backend uses HTTP"
  type        = string
}

variable "xc_app_domain" {
  description = "Application domain"
  type        = string
}
