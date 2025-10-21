resource "aws_ecs_cluster" "web_cluster" {
  name = var.cluster_name
  tags = {
    "env"       = "dev"
    "createdBy" = "chrissinkep"
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "ecs_lt_"
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_service_role.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.web_cluster.name} >> /etc/ecs/ecs.config
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "ecs-ec2-instance" }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "ecs-asg"
  max_size             = 4
  min_size             = 3
  desired_capacity     = 3
  vpc_zone_identifier  = module.vpc.public_subnets
  target_group_arns    = [aws_lb_target_group.lb_target_group.arn]
  health_check_type    = "ELB"
  health_check_grace_period = 300

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

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "ecs-capacity-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "web_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.web_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "web-family"
  container_definitions    = file("container-definitions/container-def.json")
  network_mode             = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "chrissinkep"
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.web_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 10
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "pink-slon"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_lb_listener.web_listener]
}
