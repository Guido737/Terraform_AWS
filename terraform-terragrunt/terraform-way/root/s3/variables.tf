variable "bucket_name" {
  default = "Creator-Everdor-terraform-test-bucket-dev"
}


variable "tags" {
  default = {
    Owner       = "Creator Eversor"
    Environment = "root"
  }
}
