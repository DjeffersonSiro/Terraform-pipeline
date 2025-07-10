```shell
# Activate SA
#gcloud auth activate-service-account <service-account> --key-file="/key-path"

# Commande Terraform

terraform init
terraform fmt
Terraform validate

terraform plan -var-file="terraform.tfvars" -out="tfplan.out"


```