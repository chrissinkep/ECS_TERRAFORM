##################################################
# Variables
##################################################

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
  default     = "web-cluster"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ECS instances and ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where ECS instances will be launched"
  type        = string
}

variable "ecr_image_uri" {
  description = "ECR image URI for the container"
  type        = string
}

##################################################
# Optional variables for ASG
##################################################

variable "asg_min_size" {
  description = "Minimum number of ECS instances in ASG"
  type        = number
  default     = 3
}

variable "asg_max_size" {
  description = "Maximum number of ECS instances in ASG"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of ECS instances in ASG"
  type        = number
  default     = 3
}
