resource "aws_lb" "main" {
  name               = "${var.app_name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = formatlist(aws_security_group.alb.id)
 # subnets            = local.public_subnet_ids
  subnets            = var.subnets
  enable_deletion_protection = false
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_alb_target_group" "main" {
  name        = "${var.app_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200-305"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}
### To be used with the manually imported certificates at ACM
# data "aws_acm_certificate" "albcrt" {
#   domain   = "planaecsdemo.com"
#   types       = ["IMPORTED"]
#   most_recent = true
# }
resource "aws_acm_certificate" "albcrt" {
  private_key       = file("planaecsdemo.com.key")
  certificate_body  = file("planaecsdemo.com.crt")
  certificate_chain = file("ca.crt")
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}
### To be used with the fully qualified domain name
# resource "aws_acm_certificate" "albcrt" {
#   domain_name       = "planaecsdemo.com"
#   validation_method = "DNS"

#   tags = {
#     Terraform   = "true"
#     Environment = "${var.environment}"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.albcrt.arn

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}


resource "aws_security_group" "alb" {
  name   = "${var.app_name}-sg-alb-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  #   egress {
  #    protocol         = "-1"
  #    from_port        = 0
  #    to_port          = 0
  #    cidr_blocks      = ["0.0.0.0/0"]
  #    ipv6_cidr_blocks = ["::/0"]
  #   }
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}


# data "aws_availability_zones" "available" {
#   state = "available"
# }

# data "aws_subnets" "filtered_public" {
#   for_each = toset(slice(sort(data.aws_availability_zones.available.zone_ids), 0, 3))
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }

#   filter {
#     name   = "tag:snet-type"
#     values = ["Public"]
#   }

#   filter {
#     name   = "availability-zone-id"
#     values = ["${each.value}"]
#   }
# }
# locals {
#   public_subnet_ids = [for k, v in data.aws_subnets.filtered_public : v.ids[0]]
# }
