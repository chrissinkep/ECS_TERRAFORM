variable "cluster_name" {
  description = "Name of ECS cluster"
  default     = "web-cluster"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS and ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ecr_image_uri" {
  description = "ECR image URI for the container"
  type        = string
}