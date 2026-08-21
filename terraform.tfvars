prefix = "ara-swiss"

aws-location = "us-west-1"
# aws-location = "us-west-2"
# aws-location = "eu-central-1"
# aws-location = "eu-central-2" # Zurich
# aws-location = "westeurope"
# aws-location = "switzerlandnorth"

tag_source_git = "terraform-f5xc-smsv2-aws"
tag_owner = "ara@f5.com"
#tag_source_host = "dkr01"


####################################
# Docker host

docker-instance-type = "t3.medium"
docker-storage-size  = 30
docker-node-user = "adminuser"
docker-pub-key = "/home/ndee/.ssh/id_rsa.pub"


####################################
# F5XC CE

f5xc-sms-instance-type = "m5.2xlarge"
f5xc-sms-storage-size  = 80
ce-node-user           = "volterra-admin"


####################################
# XC

xc_tenant = "f5-emea-ent-bceuutam"
xc_namespace = "a-arquint"
xc_origin_ip1 = "10.0.2.5"
xc_pub_app_port = "8080"
xc_pub_app_no_tls = "true"
xc_app_domain = "adn.f5demo.io"
