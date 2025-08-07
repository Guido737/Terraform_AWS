#-----------------------------------------------------------------
# Variables
#-----------------------------------------------------------------

variable "instance_type" {
  description = "EC2 instance type to use"
  type        = string
  default     = "t3.micro"
}
