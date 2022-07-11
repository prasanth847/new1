output "subnet_ids"{
  value = aws_redshift_subnet_group.redshift_subnet_group.id
}

output "rds_subnrtgroup_name"{
  value = aws_redshift_subnet_group.redshift_subnet_group.name
}