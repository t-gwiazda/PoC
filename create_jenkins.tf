#For testing creation
resource "aws_instance" "http_server_with_ssh_icmp_from_jenkins" {
  ami           = "ami-0badcc5b522737046"
  instance_type = "t2.micro"
  tags = {
    Name = "jenkins_machine"
  }
  subnet_id                   = data.aws_subnet.subnet1.id
  vpc_security_group_ids      = [data.aws_security_group.linux-tg.id]
  associate_public_ip_address = true
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
