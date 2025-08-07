#------------------------------------------------------------
# Output: Public IP of EC2 instance
#------------------------------------------------------------
output "web_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}
