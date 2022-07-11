resource "aws_db_instance" "default" {
allocated_storage = var.allocated_storage
identifier = var.identifier
storage_type = var.storage_type
engine = "aurora-mysql"
engine_version = "5.7.mysql_aurora.2.03.2"
instance_class = var.instance_class
name = var.name
username = var.username
password = var.password
parameter_group_name = var.parameter_group_name
db_subnet_group_name = var.rds_subnetname
#rds_subnet_groupid = var.subnet_grp_id
vpc_security_group_ids = [var.rds_security_group_id]
}

