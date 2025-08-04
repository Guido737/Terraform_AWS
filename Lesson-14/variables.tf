
variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "ca-central-1"
}

variable "instance_type" {
  description = "Enter Instance Type"
  type        = string
  default     = "t3.small"
}

variable "allow_ports" {
  description = "List of Ports to open for Server"
  type        = list(number)
  default     = [80, 443, 22, 8080]
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Owner       = "Creator Eversor"
    Project     = "Phoenix"
    CostCenter  = "12345"
    Environment = "development"
  }

}
