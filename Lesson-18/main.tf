


provider "aws" {
  region = "ca-central-1"
}


variable "name" {
  default = "Arthur"
}

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "~!@#$%&"
  keepers = {
    keeper1 = var.name
    #keeper2 = var.something
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master Password for RDS MySql"
  type        = "SecureString"
  value       = random_string.rds_password.result

}


data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}



resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 10
  db_name              = "prod"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  apply_immediately    = true
}



output "rds_password" {
  value     = data.aws_ssm_parameter.my_rds_password.value
  sensitive = true
}
