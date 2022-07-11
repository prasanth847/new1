//variable "rds_subnet_groupid"{
//  type = string
//}
//
//variable "vpc_security_group_ids"{
//  type = string
//}

variable "rds_security_group_id"{
  type = string
}

variable "rds_subnetname"{
  type = string

}

variable "subnet_grp_id"{
  type = string

}


variable "allocated_storage"{
  description = "allocated storage"
  default = "20"
}

variable "identifier"{
  description = "identifier"
  default = "testinstance"
}

variable "storage_type"{
  description = "storage type"
  default = "gp2"
}



variable "instance_class"{
  description = "instance class"
  default = "db.m4.large"
}

variable "name"{
  description = "db name"
  default = "test"
}

variable "username"{
  description = "db user name"
  default = "admin"
}

variable "password"{
  description = "db password"
  default = "Admin@54132"
}

variable "parameter_group_name"{
  description = "parameter group name"
  default = "default.mysql5.7"
}
