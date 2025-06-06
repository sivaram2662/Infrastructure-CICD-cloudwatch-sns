resource "aws_launch_template" "ASG-template" {
  name_prefix   = "web-lt"
  image_id      = var.ami
  instance_type = var.type
#  user_data = base64encode(file("scripts/deploy_flask.sh"))
user_data = base64encode(file("${path.module}/scripts/deploy_flask.sh"))
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm.name
  }

  vpc_security_group_ids = [aws_security_group.alb_sg.id]
}

resource "aws_autoscaling_group" "autoscaling" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = aws_subnet.privatesubnet[*].id
  launch_template {
    id      = aws_launch_template.ASG-template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.alb-target.arn]
}

resource "aws_lb" "alb-loadbancer" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.publicsubnet[*].id
}

resource "aws_lb_target_group" "alb-target" {
  name     = "web-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stage-vpc.id
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb-loadbancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "web-sg"
  vpc_id = aws_vpc.stage-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
