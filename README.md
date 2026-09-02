# F5 SaaS (RE-CE) demo with terraform

## Overview
This Terraform project deploys following items:
- Docker host with Demo application (DVWA) in **AWS** 
- CE **dual** NIC Host in **AWS** connected to F5 SaaS platform
- Virtual Server in **F5 Saas** including WAF profile

This repository is for demo or PoC show cases only!

The deployment will create a random id which is 
used for several objects for naming convention.


<p align="center">
  <img src="img/xc-cloud.drawio.png" 
</p>


---

## Getting Started
The modules are available here : https://registry.terraform.io/providers/volterraedge/volterra/latest

## Prerequisites

Before using this Terraform project, ensure you have the following:

- **Terraform CLI** installed on your machine
- An AWS account
- API Certificate (P12 file and URL) for **F5 SaaS** access
- SSH public key for Docker Host VM (admin) authentication
- An third-level-domain in F5 SaaS for service deplyoment (DNS Delegation)
  - In this case we use let's encrypt while configuring Autocert for TLS key material

Doc for API Certificate generation: https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials 

---

```
project-directory/
├── aws-data.tf
├── aws-security-groups.tf
├── aws.tf
├── docker-data.tpl
├── docker-host.tf
├── img
│   └── xc-cloud.drawio.png
├── LICENSE
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── README.md
├── terraform.tfvars.example
├── vars.tf
├── xc-ce-data.tpl
├── xc-lb.tf
└── xc-smsv2.tf
```

---

## Configuration Steps

### 1. Clone the Repository

```bash
git clone <repository_url>
cd <repository_name>
```

### 2. export F5 SaaS variables

"export" the env variables to authenticate via terraform:

```
export VES_P12_PASSWORD=<P12_cert_password>
export VOLT_API_URL=https://f5-emea-ent.console.ves.volterra.io/api
export VOLT_API_P12_FILE=/path/to/the/p12/file_api-creds.p12
```

### 3. export AWS variables

"export" the env variables to authenticate via terraform:

```
export AWS_DEFAULT_REGION=eu-central-1

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
```


### 4. Update Variables

#### Modify `terraform.tfvars`
```bash
cp terraform.tfvars.example terraform.tfvars
```
Update the values in `terraform.tfvars` to match your deployment needs.

Here are the main key variables to configure:

- **Planet wide Variables:**
  ```hcl
  prefix = "your-prefix"
  tag_owner = "your-email"
  ```

- **AWS wide Variables:**
  ```hcl
  aws_region = "eu-central-1"
  aws_availability_zone = "eu-central-1a"
  ```

- **Docker Variables:**
  ```hcl
  docker-pub-key = "path-to-your-machines-ssh-public-key"
  ```

- **XC wide Variables:**
  ```hcl
  xc_tenant = "your-tenant"
  xc_namespace = "your-namespace"
  xc_app_domain = "your-third-level-domain"
  ```

### 5. Initialize Terraform

Run the following command to initialize Terraform and download required providers:

```bash
terraform init
```

### 6. Plan the Deployment

Verify the configuration by running:

```bash
terraform plan
```

This command shows the resources Terraform will create.

### 7. Deploy the Resources

Apply the configuration to create resources:

```bash
terraform apply
```

Type `yes` to confirm the deployment or add the argument `--auto-approve`.

---

### 8. Cleanup

To destroy all resources created by this project, run:

```bash
terraform destroy
```

Type `yes` to confirm the deletion or add the argument `--auto-approve`.

---

