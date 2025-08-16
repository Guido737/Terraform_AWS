data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "creator-eversor-project-kgb-terraform-state"
    key    = "dev/s3/terraform.tfstate"
    region = "us-east-1"
  }
}

module "s3_object" {
  source  = "git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//modules/object"
  bucket  = data.terraform_remote_state.s3.outputs.id
  key     = var.file_name
  content = var.file_text
  tags    = var.tags
}
