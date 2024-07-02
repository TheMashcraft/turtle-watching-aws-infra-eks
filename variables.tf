variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "Test EKS Cluster"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "allowed_ips" {
  description = "List of IPs allowed to access the Flask app"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ecr_repository" {
  description = "The name of the ECR repository"
  type        = string
  default     = "public.ecr.aws/c5j2e5k7/flask-app"
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

variable "replicas" {
  description = "Number of replicas for the Flask app"
  type        = number
  default     = 3
}
