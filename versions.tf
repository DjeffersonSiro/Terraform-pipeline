terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }

  #backend "local" {
  #  path = "terraform/state/local.tfstate"
  #}
}



