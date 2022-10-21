resource "aws_iam_role" "sftp_transfer_server_user" {
  name = "${var.name_prefix}-sftp-transfer-server-user-${var.user_name}-iam-role${var.name_suffix}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "transfer.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-user-${var.user_name}-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "sftp_transfer_server_user" {
  name = "${var.name_prefix}-sftp-transfer-server-user-${var.user_name}-iam-policy${var.name_suffix}"
  role = aws_iam_role.sftp_transfer_server_user.id

  policy = var.read_only ? templatefile("${path.module}/templates/policy/read-only.tftpl",
    {
      s3_bucket = var.s3_bucket_name
      user_home = var.user_home
      }) : templatefile("${path.module}/templates/policy/read-write.tftpl", {
      s3_bucket = var.s3_bucket_name
      user_home = var.user_home
  })
}

resource "aws_kms_key" "secrets_encryption" {
  enable_key_rotation = true
}

resource "aws_secretsmanager_secret" "secret" {
  name       = "${var.secrets_prefix}/${var.name_prefix}-sftp-${var.user_name}${var.name_suffix}"
  kms_key_id = aws_kms_key.secrets_encryption.arn

  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-user-${var.user_name}${var.name_suffix}"
    },
  )
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = <<EOF
{
  "Password": "ChangeMe",
  "PublicKey": "${var.ssh_key}",
  "Role": "${aws_iam_role.sftp_transfer_server_user.arn}",
  "HomeDirectory": "/${var.s3_bucket_name}/${var.user_home}"
}
EOF
}
