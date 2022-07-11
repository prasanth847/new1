variable "access_key" {
  type    = string
  default = "AKIAT5MSYTCP27DCWTQQ"
}

variable "aws_region" {
  default     = "eu-central-1"
  description = "The current AWS region."
}

variable "Environment1" {
  type    = string
  default = "dev"
}

variable "AWS_ACC_ID" {
  type        = number
  default     = 206922815305
  description = "The current AWS account ID."
}

variable "api_lambda_funcarn"{
  type = string
}