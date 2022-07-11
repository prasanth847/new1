variable "private_subnet_ids" {
  type        = list(any)
  description = "Private Subnet IDs"
  default     = ["subnet-016d89962a3be8f01", "subnet-05814732b5e253d28 "]
}