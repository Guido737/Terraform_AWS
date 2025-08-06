#------------------------------------------------------------------------
# Output Block: IAM Users and EC2 Instance Info
#------------------------------------------------------------------------


#------------------------------------------------------------------------
# Output entire IAM user objects created using the loop
#------------------------------------------------------------------------
output "created_iam_users" {
  value = aws_iam_user.users
}

#------------------------------------------------------------------------
# Output only the IDs of the IAM users
#------------------------------------------------------------------------
output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}

#------------------------------------------------------------------------
# Output a custom formatted string for each user with their name and ARN
#------------------------------------------------------------------------
output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Hello Username: ${user.name} has ARN: ${user.arn}"
  ]
}

#------------------------------------------------------------------------
# Output a map where key = unique_id and value = user ID
#------------------------------------------------------------------------
output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id
  }
}

#------------------------------------------------------------------------
# Output only users whose name is exactly 4 characters long
#------------------------------------------------------------------------
output "custom_if_length" {
  value = [
    for x in aws_iam_user.users :
    x.name
    if length(x.name) == 4
  ]
}

#------------------------------------------------------------------------
# Output a map of EC2 instance ID to its public IP address
#------------------------------------------------------------------------
output "sever_all" {
  value = {
    for server in aws_instance.servers :
    server.id => server.public_ip
  }
}
