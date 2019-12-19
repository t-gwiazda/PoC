#resource "aws_security_group" "sg_web" {
#  name        = "sg_web"
#  description = "Web security group"
#
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "TCP"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

resource "aws_security_group" "sg_elb" {
  name        = "sg_elb"
  description = "ELB Security Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "elb" {
  name               = "Terraform-elb"
  security_groups    = [aws_security_group.sg_elb.id]
  availability_zones = "${data.aws_availability_zones.all.names}"
  instances       = [aws_instance.server1.id,aws_instance.server2.id]
  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}


