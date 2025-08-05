

provider "aws" {
  region = "eu-central-1"
}



resource "null_resource" "command_1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}



resource "null_resource" "command_2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
  #   depends_on = [null_resource.command_1]
}



resource "null_resource" "command_3" {
  provisioner "local-exec" {
    command     = "print('Hello World!')"
    interpreter = ["python", "-c"]
  }
}

resource "null_resource" "command_4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Peter"
      NAME2 = "Jack"
      NAME3 = "Walter"
    }
  }
}


resource "aws_instance" "my_server" {
  ami           = "ami-0a72753edf3e631b7"
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS Instance Creations!"
  }
}





resource "null_resource" "command_6" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [null_resource.command_1, null_resource.command_2, null_resource.command_3, null_resource.command_4, aws_instance.my_server]
}
