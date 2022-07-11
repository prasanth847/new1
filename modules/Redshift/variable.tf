variable "rs_cluster_identifier" {
  type = string
  default = "sample-cluster"
}

variable "rs_database_name"{
  type = string
  default = "samplecluster"
}

variable "rs_master_username" {
  type =string
  default = "sampleuser"
}

variable "rs_master_pass" {
  type = string
  default = "Prasanth1903"
}
variable "rs_nodetype" {
  type = string
  default = "dc2.large"
}

variable "rs_cluster_type" {
  type = string
  default = "single-node"
}

variable "redshift_subnet_groupid"{
  type =string
}

variable "redshift_rolearn"{
  type = string
}