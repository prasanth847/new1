output "security_group_id_MR"{
  value = aws_security_group.distill-emr-sg.id
}


//output "security_group_id_emr"{
//  value = aws_security_group.distill-mwaa-sg.id
//}

output "source_security_group_id_mwaa2"{
  value = aws_security_group.distill-mysql-sg.id
}

output "security_group_id_mwaa-1"{
  value = aws_security_group.distill-EMR-Service-Access-sg.id
}

output "distill-mwaa-sg_id"{
  value = aws_security_group.distill-mwaa-sg.id
}

output  "rds_security_group_id"{
  value = aws_default_security_group.RDS_mysql_inbound_access.id
}
