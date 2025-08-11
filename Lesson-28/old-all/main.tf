
data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazone_linux" {
  owners      = ["amazone"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
