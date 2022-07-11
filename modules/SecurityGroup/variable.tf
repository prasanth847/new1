variable "VPC_ID" {
  type    = string
  default = "vpc-0ed6051c1042a834f"
}

variable "Environment" {
  type    = string
  default = "Dev"
}

#used in security groups Inbound rule
variable "sg_soruce_cidr" {
  type        = list(any)
  description = "The CIDR list for distill-emr-sg-ssh"
  default     = ["141.167.0.0/16", "151.120.0.0/16", "128.137.0.0/16", "162.132.0.0/16", "10.0.0.0/8", "145.245.0.0/16"]
}
