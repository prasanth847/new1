locals {
inbound_ports = [3306, 3306]
}


#Creating security group
#SG 1 -EMR master
resource "aws_security_group" "distill-emr-sg" {
  name        = "distill-emr-sg-${var.Environment}"
  description = "Group applied to all EC2 instances (master and slave) launched through EMR"
  vpc_id      = var.VPC_ID
}
#SG 2 -MWAA
resource "aws_security_group" "distill-mwaa-sg" {
  name        = "distill-mwaa-sg-${var.Environment}"
  description = "Security group for MWAA"
  vpc_id      = var.VPC_ID
}
#SG 3 -MySQL
resource "aws_security_group" "distill-mysql-sg" {
  name        = "distill-mysql-sg-${var.Environment}"
  description = "Security group for MYSQL"
  vpc_id      = var.VPC_ID
}
#SG 4 -EMR Service access
resource "aws_security_group" "distill-EMR-Service-Access-sg" {
  name        = "distill-EMR-Service-Access-sg-${var.Environment}"
  description = "EMR Service SG"
  vpc_id      = var.VPC_ID

}
#adding rules to  SG 1 -EMR master
resource "aws_security_group_rule" "distill-emr-sg-self-MR" {
  security_group_id        = aws_security_group.distill-emr-sg.id

  type                     = "ingress"
  description              = "MapReduce UI"
  from_port                = 19889
  to_port                  = 19889
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-Spark" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "Sparl UI"
  from_port                = 20888
  to_port                  = 20888
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-SparkHS" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "Sparl Histrory server"
  from_port                = 18080
  to_port                  = 18080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-YARN-RM" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "YARN Resource Manager"
  from_port                = 8088
  to_port                  = 8088
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-YARN-NM" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "YARN node Manager"
  from_port                = 8042
  to_port                  = 8042
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-Zeppelin" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "Zeppelin UI"
  from_port                = 8890
  to_port                  = 8890
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-Hue" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "HUE UI"
  from_port                = 8888
  to_port                  = 8888
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-Ganglia" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "Ganglia UI"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-JupyterHub" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "JupyterHub UI"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-ssh" {
  security_group_id = aws_security_group.distill-emr-sg.id
  type              = "ingress"
  description       = "SSH rules"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = var.sg_soruce_cidr
}

resource "aws_security_group_rule" "distill-emr-sg-self" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "Communication between core instances"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}
resource "aws_security_group_rule" "distill-emr-sg-self-mwaa" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "Communication from MWAA server to EMR master node"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.distill-mwaa-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-EMR-SA" {
  security_group_id        = aws_security_group.distill-emr-sg.id
  type                     = "ingress"
  description              = "Communication between core instances"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.distill-EMR-Service-Access-sg.id
}


resource "aws_security_group_rule" "distill-emr-sg-OutBound" {
  security_group_id = aws_security_group.distill-emr-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


#Adding rules for SG 2 -MWAA


resource "aws_security_group_rule" "distill-mwaa-sg-emr" {
  security_group_id        = aws_security_group.distill-mwaa-sg.id
  type                     = "ingress"
  description              = "Communication from MWAA server to EMR master node"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-mwaa2" {
  security_group_id        = aws_security_group.distill-mwaa-sg.id
  type                     = "ingress"
  description              = "Communication from MWAA server to EMR master node"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.distill-mysql-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-mwaa3" {
  security_group_id        = aws_security_group.distill-mwaa-sg.id
  type                     = "ingress"
  description              = "Self refering SG rule"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.distill-mwaa-sg.id
}

resource "aws_security_group_rule" "distill-emr-sg-self-mwaa4" {
  security_group_id        = aws_security_group.distill-mwaa-sg.id
  type                     = "ingress"
  description              = "Access from Roche nw"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
}

resource "aws_security_group_rule" "distill-emr-sg-self-mwaa5" {
  security_group_id        = aws_security_group.distill-mwaa-sg.id
  type                     = "ingress"
  description              = "Access from Roche nw"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
}


resource "aws_security_group_rule" "distill-mwaa-sg-OutBound" {
  security_group_id = aws_security_group.distill-mwaa-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


#Adding rules to SG 3 -MySQL

resource "aws_security_group_rule" "distill-mysql-sg-emr" {
  security_group_id        = aws_security_group.distill-mysql-sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}

resource "aws_security_group_rule" "distill-mysql-sg-mwaa" {
  security_group_id        = aws_security_group.distill-mysql-sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-mwaa-sg.id
}

resource "aws_security_group_rule" "distill-mysql-sg-OutBound" {
  security_group_id = aws_security_group.distill-mysql-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


# Adding rules for SG 4 -EMR Service access
resource "aws_security_group_rule" "distill-emr-sg-self-mwaa-1" {
  security_group_id        = aws_security_group.distill-EMR-Service-Access-sg.id
  type                     = "ingress"
  description              = "For the internal communication"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}


resource "aws_security_group_rule" "distill-EMR-SA-sg-OutBound" {
  security_group_id = aws_security_group.distill-EMR-Service-Access-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "distill-EMR-SA-sg-OutBound2" {
  security_group_id        = aws_security_group.distill-EMR-Service-Access-sg.id
  type                     = "egress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.distill-emr-sg.id
}


#for redshift

resource "aws_default_security_group" "redshift_security_group" {
  vpc_id     = var.VPC_ID
ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "redshift-sg"
  }

}

#for RDS
resource "aws_default_security_group" "RDS_mysql_inbound_access" {
  vpc_id     = var.VPC_ID
  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
//ingress {
//    from_port   = 3306
//    to_port     = 3306
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"] #anyone can connect to the redshift cluster knowing the username and password
//  }

//depends_on = [
//    "aws_vpc.network_vpc"
//  ]
//}