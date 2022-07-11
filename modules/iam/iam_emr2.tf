#Creating Roche-Distill-EMR-EC2-role-<ENV> and Policies
#Role Trust relationship part
data "aws_iam_policy_document" "emr2_role_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

#Creating the role
resource "aws_iam_role" "emr_role_2" {
  name               = "Roche-Distill-EMR-EC2-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.emr2_role_trust.json
}

##Policy 1 managed policy
data "aws_iam_policy" "Emr1Mgd01" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "emr_policy_01_attachment" {
  role       = aws_iam_role.emr_role_2.id
  policy_arn = data.aws_iam_policy.Emr1Mgd01.arn
}

##Policy 2 managed policy
data "aws_iam_policy" "Emr1Mgd02" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "emr_policy_02_attachment" {
  role       = aws_iam_role.emr_role_2.id
  policy_arn = data.aws_iam_policy.Emr1Mgd02.arn
}

##Policy 3 managed policy
data "aws_iam_policy" "Emr1Mgd03" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_role_policy_attachment" "emr_policy_03_attachment" {
  role       = aws_iam_role.emr_role_2.id
  policy_arn = data.aws_iam_policy.Emr1Mgd03.arn
}



#Creating the S3RW policy4 -distill-s3-read-write-access-policy-<<env>>
resource "aws_iam_policy" "s3_policy_06" {
  name   = "distill-s3-read-write-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.s3emr_policy_rw.json
}

#attaching the policy to the role
resource "aws_iam_role_policy_attachment" "s3_policy_6_attachment" {
  role       = aws_iam_role.emr_role_2.id
  policy_arn = aws_iam_policy.s3_policy_06.arn
}


data "aws_iam_policy_document" "s3emr_policy_rw" {
  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    actions   = ["s3:List*"]
    resources = ["*"]

  }
  statement {
    sid    = "VisualEditor1"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:DeleteObject",
      "s3:Put*"
    ]
    resources = [

      "arn:aws:s3:::${var.data_bucket_name}-${var.Environment1}/*",
      "arn:aws:s3:::${var.stg_bucket_name}-${var.Environment1}/*",
      "arn:aws:s3:::${var.mwaa_bucket_name}-${var.Environment1}/*",
      "arn:aws:s3:::${var.code_bucket_name}-${var.Environment1}/*",
      "arn:aws:s3:::${var.stg_bucket_name}-${var.Environment1}",
      "arn:aws:s3:::${var.mwaa_bucket_name}-${var.Environment1}",
      "arn:aws:s3:::${var.data_bucket_name}-${var.Environment1}",
      "arn:aws:s3:::${var.code_bucket_name}-${var.Environment1}",
    ]
  }
  statement {
    sid       = "VisualEditor2"
    effect    = "Deny"
    actions   = ["s3:DeleteBucket"]
    resources = ["*"]
  }

}


#Creating the S3RW policy5 -distill-EMR-EC2-Service-policy--<<env>>
resource "aws_iam_policy" "emrsvc_policy_05" {
  name   = "distill-EMR-EC2-Service-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.emrec2_svc.json
}

#attaching the policy to the role
resource "aws_iam_role_policy_attachment" "emrsvc_policy_5_attachment" {
  role       = aws_iam_role.emr_role_2.id
  policy_arn = aws_iam_policy.emrsvc_policy_05.arn
}


data "aws_iam_policy_document" "emrec2_svc" {

  statement {
    sid    = "VisualEditor0"
    effect = "Allow"
    actions = [
      "iam:Get*",
      "iam:List*",
      "elasticmapreduce:ListBootstrapActions",
      "elasticmapreduce:Describe*",
      "elasticmapreduce:ListInstanceGroups",
      "elasticmapreduce:ListInstances",
      "elasticmapreduce:ListClusters",
      "elasticmapreduce:ListSteps",
      "rds:Describe*",
      "sns:*",
      "ses:*",
      "sqs:*",
      "athena:*",
      "ec2:Describe*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "KMS"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "SecretsManager"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:us-east-1:${var.AWS_ACC_ID}:secret:secret_*"]
  }
}