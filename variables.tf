variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "ecs-web-cluster"
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
  default     = "ecs_workshop"
}

variable "ecr_image_uri" {
  description = "ECR image URI for the container"
  type        = string
  default     = "863218674815.dkr.ecr.us-east-1.amazonaws.com/workshop"
}

# No need for public_subnets input — we will get it from the VPC module
