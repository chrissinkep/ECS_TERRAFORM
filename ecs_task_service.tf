resource "aws_ecs_task_definition" "web_task" {
  family                = "web-family"
  container_definitions = jsonencode([{
    name      = "pink-slon",
    image     = var.ecr_image_uri,
    cpu       = 256,
    memory    = 512,
    essential = true,
    portMappings = [{
      containerPort = 80,
      hostPort      = 80
    }],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-group"         = "/ecs/frontend-container",
        "awslogs-region"        = "us-east-1",
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
  network_mode = "bridge"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    env       = "dev"
    createdBy = "chrissinkep"
  }
}

resource "aws_ecs_service" "web_service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.web_cluster.id
  task_definition = aws_ecs_task_definition.web_task.arn
  desired_count   = 2
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "pink-slon"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_lb_listener.alb_listener]
}
