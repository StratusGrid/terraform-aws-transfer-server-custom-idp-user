terraform {
  required_providers {
    aws = {
      version = ">= 4.30"
      source = "hashicorp/aws"
    }
  }

  required_version = ">= 1.0.0"
}
