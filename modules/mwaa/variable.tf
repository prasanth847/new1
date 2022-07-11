variable "environment_class" {
  type        = string
  default     = "mw1.small"
  description = "Environment class for the cluster"
}

variable "max_workers" {
  type        = number
  default     = 5
  description = "The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25."
}

variable "min_workers" {
  type        = number
  default     = 1
  description = "The minimum number of workers that can be automatically scaled up. Value need to be between 1 and 25."
}

variable "schedulers" {
  type        = number
  default     = 2
  description = ""
}

variable "Environment1" {
  type    = string
  default = "dev"
}

#key value hardcoded here needs to be updated , when account creats roche will be creating the KMS key too
//variable "KMS_Key" {
//  type    = string
//  description = "The KMS key used to encrypt aws resources"
//  default = "arn:aws:kms:eu-central-1:206922815305:key/10a979ff-8ca3-49e0-9a2c-840867578f57"
//}

variable "private_subnet_ids" {
  type        = list(any)
  description = "Private Subnet IDs"
  default     = ["subnet-016d89962a3be8f01", "subnet-05814732b5e253d28 "]
}

variable "distillmwaaBucketarn"{
  type = string
}

variable "distill-mwaa-sgid"{
  type = string
}

variable "mwaa_role_1arn"{
  type =string
}