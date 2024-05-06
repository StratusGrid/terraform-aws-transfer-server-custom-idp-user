resource "aws_iam_role_policy" "sftp_lambda_role_policy" {
  name = "KmsAccess-${var.user_name}"
  role = var.secret_access_lambda_role

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "${aws_kms_key.secrets_encryption.arn}",
            "Effect": "Allow"
        }
    ]
}
EOF
}