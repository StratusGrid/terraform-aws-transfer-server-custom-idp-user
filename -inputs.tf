variable "s3_bucket_name" {
  description = "Transfer Server S3 bucket name"
  type        = string
}

variable "user_name" {
  description = "User name for SFTP server"
  type        = string
}

variable "user_home" {
  description = "HOME path for transfer server user. Mustn't start with /"
  type        = string
  default     = ""
}

variable "ssh_key" {
  description = "SSH Key for transfer server user"
  type        = string
  default     = ""
}

variable "secrets_prefix" {
  description = "Prefix used to create AWS Secrets"
  default     = "SFTP"
  type        = string
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "String to use as prefix on object names"
  type        = string
}

variable "name_suffix" {
  description = "String to append to object names. This is optional, so start with dash if using"
  type        = string
  default     = ""
}

variable "read_only" {
  description = "Define if the user is created with read-only privileges"
  type        = bool
  default     = false
}
