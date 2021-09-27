# variable "example_instance_type" {
#   default = "t3.micro"
# }

# locals {
#   example_instance_type = "t3.nano"
# }

resource "aws_instance" "example" {
  ami           = "ami-0c3fd0f5d33134a76"
  instance_type = "t3.micro"

  tags = {
    member = "noda",
    usercase = "studying for terraform"
  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
  EOF
}

output "example_instance_id" {
  value = aws_instance.example.id
}
