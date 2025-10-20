##########################################
# AMI for ECS EC2 instances
##########################################
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

##########################################
# Security Group
##########################################
resource "aws_security_group" "ec2-sg" {
  name        = "ecs-ec2-sg"
  description = "Allow traffic for ECS EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "chrissinkep"
  }
}

##########################################
# Launch Template (replaces Launch Configuration)
##########################################
resource "aws_launch_template" "lt" {
  name_prefix   = "ecs_lt_"
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_service_role.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-ec2-instance"
    }
  }
}

##########################################
# Auto Scaling Group
##########################################
resource "aws_autoscaling_group" "asg" {
  name                      = "ecs-asg"
  max_size                  = 4
  min_size                  = 3
  desired_capacity           = 3
  vpc_zone_identifier        = module.vpc.public_subnets
  target_group_arns          = [aws_lb_target_group.lb_target_group.arn]
  protect_from_scale_in      = true
  health_check_type          = "ELB"
  health_check_grace_period  = 300

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-ec2-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
