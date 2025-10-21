##########################################
# Outputs for ECS + ALB setup
##########################################

# ALB DNS
output "alb_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

# ALB ARN
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

# Target Group ARN
output "alb_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = aws_lb_target_group.lb_target_group.arn
}

# ECS Cluster
output "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.web-cluster.name
}

# ECS Service
output "ecs_service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.service.name
}

# ECS Task Definition
output "ecs_task_definition_arn" {
  description = "ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.task-definition-test.arn
}

# VPC ID
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# Public Subnets
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}
