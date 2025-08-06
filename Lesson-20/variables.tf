#---------------------------
# Variable: IAM Users List
# Description: List of IAM usernames to create dynamically
#---------------------------
variable "aws_users" {
  description = "List of IAM Users to create"
  default     = ["Milana", "Arnold", "George", "Phillip", "Conan"]
}
