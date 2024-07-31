provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

resource "aws_instance" "web_server_us_east" {
  provider = aws.us_east_1
  ami           = "ami-04a81a99f5ec58529" 
  instance_type = "t2.micro"
   provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "WebServer_US_East"
  }
}


resource "aws_instance" "web_server_us_west" {
  provider = aws.us_west_2
  ami           = "ami-0aff18ec83b712f05" 
  instance_type = "t2.micro"

   provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "WebServer_US_West"
  }
}


output "us_east_instance_public_ip" {
  value = aws_instance.web_server_us_east.public_ip
}

output "us_west_instance_public_ip" {
  value = aws_instance.web_server_us_west.public_ip
}

variable "private_key_path" {
  description = "Path to the private key used for SSH access"
  type        = string
}