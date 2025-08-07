#-----------------------------------------------------------------
# Outputs
#-----------------------------------------------------------------

output "canada_server_public_ip" {
  description = "Public IP of the EC2 instance deployed in Canada (ca-central-1)"
  value       = aws_instance.my_canada_server.public_ip
}

output "usa_server_public_ip" {
  description = "Public IP of the EC2 instance deployed in USA (us-east-1)"
  value       = aws_instance.my_usa_server.public_ip
}

output "deu_server_public_ip" {
  description = "Public IP of the EC2 instance deployed in Germany (eu-central-1)"
  value       = aws_instance.my_deu_server.public_ip
}
