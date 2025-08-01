provider "aws" {}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.11.0.0/16"
  tags = {
    Name = "my_custom_vpc"
  }
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "first_vpc" {
  id = aws_vpc.custom_vpc.id
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = data.aws_vpc.first_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.11.1.0/24"
  tags = {
    Name    = "Subnet_1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.id
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = data.aws_vpc.first_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.11.2.0/24"
  tags = {
    Name    = "Subnet_2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.id
  }
}

output "first_vpc_id" {
  value = data.aws_vpc.first_vpc.id
}

output "first_vpc_cidr" {
  value = data.aws_vpc.first_vpc.cidr_block
}

output "availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region_id" {
  value = data.aws_region.current.id
}
