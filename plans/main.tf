variable "server_port" {
  description = "The port the server will use for HTTP requests"
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami = "ami-2d39803a"
  key_name = "terraformtest"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
#  user_data = <<-EOF
#              #!/bin/bash
#              echo "Hello again, World" > /tmp/index.html
#	      EOF
  user_data = "${file("userdata.sh")}"
  tags {
    Name = "terraform-example"
    Purpose = "tagging fun"
  }
} 
resource "aws_security_group" "instance" {
  name = "terraform-example-instance" 

  ingress { 
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { 
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}
