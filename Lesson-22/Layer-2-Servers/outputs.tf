#------------------------------------------------------------
# Outputs
#------------------------------------------------------------
output "webserver_sg_id" {
  description = "ID of the web server's security group"
  value       = aws_security_group.webserver.id
}

output "web_server_public_ip" {
  description = "Public IP address of the web server instance"
  value       = aws_instance.web_server.public_ip
}
