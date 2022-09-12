terraform {
  required_providers {
    aws = {
      version = ">= 3.26.0"
      source = "hashicorp/aws"
    }
  }

  required_version = ">= 1.0.0"
}
