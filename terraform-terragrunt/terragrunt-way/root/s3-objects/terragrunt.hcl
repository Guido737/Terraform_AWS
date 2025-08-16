include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-object.git//"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  bucket  = dependency.s3.outputs.s3_bucket_id
  key     = "test_file.txt"
  content = "This is test text inside the file"

  tags = {
    Owner       = "Creator Eversor"
    Environment = "root"
  }
}

dependencies {
  paths = ["../s3"]
}
