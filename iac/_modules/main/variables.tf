variable "aws_region" {
  description = "The AWS region to deploy the application to"
  type        = string
  default     = "eu-central-1"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "cloud-wenwave"
}

variable "allow_local_development" {
  description = "Whether to allow local development"
  type        = bool
  default     = false
}
