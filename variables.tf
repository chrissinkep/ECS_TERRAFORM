# AWS region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Name of the ECS cluster
variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
  default     = "web-cluster"
}

# EC2 Key Pair name
variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "ecs_workshop"
}

# Public subnet IDs for ECS instances and ALB
variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["subnet-11111111","subnet-22222222","subnet-33333333"]
}

# ECR image URI
variable "ecr_image_uri" {
  description = "ECR image URI for the container"
  type        = string
  default     = "863218674815.dkr.ecr.us-east-1.amazonaws.com/workshop:latest"
}
