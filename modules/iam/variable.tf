variable "AWS_ACC_ID" {
  type        = number
  default     = 619115807332
  description = "The current AWS account ID."
}

variable "VPC_ID" {
  type    = string
  default = "vpc-0d399f696946ff126"
}

variable "Environment" {
  type    = string
  default = "Dev"
}

variable "Environment1" {
  type    = string
  default = "dev"
}

##S3 Buckets used for the IAM policy creation
variable "data_bucket_name" {
  type    = string
  default = "roche-distill-data"
}

variable "mwaa_bucket_name" {
  type    = string
  default = "roche-distill-mwaa"
}

variable "code_bucket_name" {
  type    = string
  default = "roche-distill-code"
}

variable "stg_bucket_name" {
  type    = string
  default = "roche-distill-stg"
}