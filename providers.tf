terraform {
  required_version = ">=1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    external = {
      source = "hashicorp/external"
    }

    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.0.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "volterra" {
  // api_p12_file = var.f5xc_api_p12_file
  // url          = var.f5xc_api_url
}