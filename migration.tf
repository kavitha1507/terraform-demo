provider "aws" {
  region = "us-east-2"
}
resource "aws_security_group" "nginx_sg" {
    name = "nginx-sg"
    description = "Allow HTTP traffic"

     ingress {
      from_port =80
      to_port=80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
    egress {

      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name="nginx-sg"
  }
  
}
resource "aws_instance" "my_instance" {
  ami = "ami-0862be96e41dcbf74"
  instance_type = "t2.micro"
    user_data = <<-EOF
   #!/bin/bash
   apt-get update -y
   apt-get install nginx -y
   systemctl start nginx
   systemctl enable nginx
   EOF
  tags ={
    name="nginx-server"
  }
vpc_security_group_ids = [aws_security_group.nginx_sg.id]
}

