provider "aws" {
  region = "eu-central-1"
}


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

data "aws_availability_zones" "all" {
}

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
  vpc_security_group_ids      = [data.aws_security_group.tg-sg.id]

  tags = {
    Name = "server1"
  }

  key_name                    = "linux-tg-key"
  user_data                   = <<-EOF
                #! /bin/bash
                yum update -y
                yum install httpd -y
                echo "Server1 is running" >>  /var/www/html/index.html
                service httpd start
                chkconfig httpd on
  EOF
}

output "server1_public_hostname" {
  value = "${aws_instance.server1.public_dns}"
}


resource "aws_instance" "server2" {
  ami = data.aws_ami.latest-amazon-linux2.id
  instance_type = "t2.micro"
  vpc_security_group_ids      = [data.aws_security_group.tg-sg.id]

  tags = {
    Name = "server2"
  }

  key_name                    = "linux-tg-key"
  user_data                   = <<-EOF
                #! /bin/bash
                yum update -y
                yum install httpd -y
                echo "Server2 is running" >>  /var/www/html/index.html
                service httpd start
                chkconfig httpd on
  EOF
}

output "server2_public_hostname" {
  value = "${aws_instance.server1.public_dns}"
}

