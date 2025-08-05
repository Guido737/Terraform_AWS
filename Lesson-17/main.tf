
provider "aws" {
  region = "ca-central-1"
}

# ---------------------------------------
# Generate a random secure password
# ------------------------------------------------------
resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "~!@#$%&"
}

# ------------------------------------------------------
# Store the password securely in AWS SSM Parameter Store
# -------------------------------------------------------------
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master Password for RDS MySql"
  type        = "SecureString"
  value       = random_string.rds_password.result
  overwrite   = true
}

# -------------------------------------------------------------
# Define an IAM policy that allows writing to the SSM parameter
# ------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "allow_ssm_parameter_write" {
  name        = "AllowSSMPutParameterProdMysql"
  description = "Allow eb-user to put parameter into /prod/mysql"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:PutParameter"
        ]
        Resource = "arn:aws:ssm:ca-central-1:${data.aws_caller_identity.current.account_id}:parameter/prod/mysql"
      }
    ]
  })
}

# ------------------------------------------------------------------------------------------------------------------
# Attach the policy to an existing IAM user (eb-user)
# ---------------------------------------------------------------------
resource "aws_iam_user_policy_attachment" "attach_ssm_policy_to_user" {
  user       = "eb-user"
  policy_arn = aws_iam_policy.allow_ssm_parameter_write.arn
}

# ---------------------------------------------------------------------
# Fetch the current AWS account ID dynamically
# -------------------------------------
data "aws_caller_identity" "current" {}
