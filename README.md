# terraform-aws-transfer-server-custom-idp-user
This is a Terraform module to create users for the AWS SFTP service based on custom identity provider using AWS Secrets Manager. To create the server and the identity provider, use [this module](https://registry.terraform.io/modules/StratusGrid/transfer-server-custom-idp/aws/latest).

### Example usage
Create one user to login in the AWS Transfer server

```
# Creation of the AWS Transfer server and the custom IDP provider
module "transfer-server-custom-idp" {
  name_prefix = var.name_prefix
  source  = "StratusGrid/transfer-server-custom-idp/aws"
  version = "1.0.3"

  region = var.region
}

# Creation of one user named firstuser. Don't forget to change its password from the default value in AWS Secret Manager
module "transfer-server-custom-idp-user" {
  name_prefix = var.name_prefix
  source  = "StratusGrid/transfer-server-custom-idp-user/aws"
  version = "1.0.2"

  s3_bucket_name = "bucket-to-store-files-via-sftp"
  transfer_server_id = module.transfer-server-custom-idp.transfer_server_id
  user_name = "firstuser"
  read_only = false
}
```
