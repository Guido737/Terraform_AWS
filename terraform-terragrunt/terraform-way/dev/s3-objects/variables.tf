variable "file_name" {
  default = "test_file.txt"
}

variable "file_text" {
  default = "HI My Name is Slim Shady!"
}


variable "tags" {
  default = {
    Owner       = "Creator Eversor"
    Environment = "dev"
  }
}
