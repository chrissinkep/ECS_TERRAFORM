resource "aws_ecs_cluster" "web_cluster" {
  name = var.cluster_name
  tags = {
    "env"       = "dev"
    "createdBy" = "chrissinkep"
  }
}

# ECS Capacity Provider for EC2
resource "aws_ecs_capacity_provider" "ec2_capacity_provider" {
  name = "capacity-provider-test"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "web_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.web_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ec2_capacity_provider.name]
}