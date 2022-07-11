resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = var.private_subnet_ids
tags = {
    environment = "dev"
    Name = "redshift-subnet-group"
  }
}