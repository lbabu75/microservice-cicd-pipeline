# terraform/variables.tf

variable "cluster_name" {
  description = "cluster name"
  type        = string
  default     = "microservice-cluster"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "microservice-app"
}
