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

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ]
        "Effect" = "Allow"
        "Resource" = [
          "arn:aws:s3:::${var.s3_bucket_name}",
        ]
        "Sid" = "AllowListingOfUserFolder"
      },
      {
        "Action" = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
        ]
        "Effect"   = "Allow"
        "Resource" = "arn:aws:s3:::${var.s3_bucket_name}${var.user_home}*"
        "Sid"      = "HomeDirObjectAccess"
      },
    ]
  })
}


resource "aws_secretsmanager_secret" "secret" {
  name = "${var.secrets_prefix}/${var.name_prefix}-sftp-${var.user_name}${var.name_suffix}"
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
  "HomeDirectory": "/${var.s3_bucket_name}${var.user_home}"
}
EOF
}
