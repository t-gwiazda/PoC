provider "aws" {
  region = "eu-central-1"
}


##
#variable "instance_flavor" {
#  default     = "t2.micro"
#  description = "Size of instance"
#}

data "aws_ami" "latest-amazon-linux2" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#select aws_security_group for sec_group_for_http_and_ssh_icmp
data "aws_security_group" "tg-sg" {
  tags = {
    Name = "tg-sg"
  }
}

resource "aws_instance" "server1" {
  #ami = "ami-0c6b1d09930fac512"
  #ami = "${data.aws_ami.latest-amazon-linux2.id}"
  ami = data.aws_ami.latest-amazon-linux2.id
  instance_type = "t2.micro"
#  instance_type = "${var.instance_flavor}"
  vpc_security_group_ids      = [data.aws_security_group.tg-sg.id]

  tags = {
    Name = "server1"
  }
  key_name                    = "linux-tg-key"
  user_data                   = <<-EOF
                #! /bin/bash
                yum update -y
                yum install httpd -y
                echo "Server is running" >>  /var/www/html/index.html
                service httpd start
                chkconfig httpd on
  EOF
}

output "server1_public_hostname" {
  value = "${aws_instance.server1.public_dns}"
}

