# Remote backend configuration
remote_state {
  backend = "s3"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket         = "terragrunt-remote-state"
    region         = "us-east-1"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
  }
}

# Generate AWS provider config
generate "my_config" {
  path      = "_config.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.iam_role
  }
}

variable "aws_region" {}
variable "iam_role" {}
EOF
}

# Extra arguments (load common vars)
terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    required_var_files = [
      find_in_parent_folders("common.tfvars"),
    ]
  }
}
