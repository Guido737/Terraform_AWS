#--------------------------------------------------
# Environment variable: dev, prod, staging, etc.
#--------------------------------------------------
variable "env" {
  default = "dev"
}

#--------------------------------------------------
# Owner name for production environment
#--------------------------------------------------
variable "prod_owner" {
  default = "Creator Eversor"
}

#--------------------------------------------------
# Owner name for non-production environments
#--------------------------------------------------
variable "not_prod_owner" {
  default = "Tadeush"
}

#--------------------------------------------------
# EC2 instance sizes mapped by environment
#--------------------------------------------------
variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t3.small"
  }
}

#--------------------------------------------------
# Allowed ports for ingress per environment (used in security group)
#--------------------------------------------------
variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}
