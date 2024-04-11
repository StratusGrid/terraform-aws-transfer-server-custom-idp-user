<!-- BEGIN_TF_DOCS -->
<p align="center">
  <img src="https://github.com/StratusGrid/terraform-readme-template/blob/main/header/stratusgrid-logo-smaller.jpg?raw=true" />
  <p align="center">    
    <a href="https://stratusgrid.com/book-a-consultation">Contact Us</a> |
    <a href="https://stratusgrid.com/cloud-cost-optimization-dashboard">Stratusphere FinOps</a> |
    <a href="https://stratusgrid.com">StratusGrid Home</a> |
    <a href="https://stratusgrid.com/blog">Blog</a>
  </p>
</p>

# terraform-aws-transfer-server-custom-idp-user

GitHub: [StratusGrid/terraform-aws-transfer-server-custom-idp-user](https://github.com/StratusGrid/terraform-aws-transfer-server-custom-idp-user)

This is a Terraform module to create users for the AWS SFTP service based on custom identity provider using AWS Secrets Manager. To create the server and the identity provider, use [this module](https://registry.terraform.io/modules/StratusGrid/transfer-server-custom-idp/aws/latest). 

## Example Usage:
Create one user to login in the AWS Transfer server.
```hcl
# Creation of the AWS Transfer server and the custom IDP provider
module "transfer-server-custom-idp" {
  name_prefix = var.name_prefix
  source  = "StratusGrid/transfer-server-custom-idp/aws"
  version = "1.1.0"

  region = var.region
}

# Creation of one user named firstuser. Don't forget to change its password from the default value in AWS Secret Manager
module "transfer-server-custom-idp-user" {
  name_prefix = var.name_prefix
  source  = "StratusGrid/transfer-server-custom-idp-user/aws"
  version = "1.1.0"

  s3_bucket_name = "bucket-to-store-files-via-sftp"
  transfer_server_id = module.transfer-server-custom-idp.transfer_server_id
  user_name = "firstuser"
  read_only = false
}
```
---

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.sftp_transfer_server_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.sftp_transfer_server_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.secrets_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | String to use as prefix on object names | `string` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | String to append to object names. This is optional, so start with dash if using | `string` | `""` | no |
| <a name="input_read_only"></a> [read\_only](#input\_read\_only) | Define if the user is created with read-only privileges | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Transfer Server S3 bucket name | `string` | n/a | yes |
| <a name="input_secrets_prefix"></a> [secrets\_prefix](#input\_secrets\_prefix) | Prefix used to create AWS Secrets | `string` | `"SFTP"` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Key for transfer server user | `string` | `""` | no |
| <a name="input_user_home"></a> [user\_home](#input\_user\_home) | HOME path for transfer server user. Mustn't start with / | `string` | `""` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | User name for SFTP server | `string` | n/a | yes |

## Outputs

No outputs.

---

<span style="color:red">Note:</span> Manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml .`
<!-- END_TF_DOCS -->