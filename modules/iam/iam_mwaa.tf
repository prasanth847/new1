#Role Trust relationship part
data "aws_iam_policy_document" "mwaa_role_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "airflow-env.amazonaws.com",
        "airflow.amazonaws.com"
      ]
    }
  }
}
#Creating the role
resource "aws_iam_role" "mwaa_role_1" {
  name               = "Roche-Distill-mwaa-execution-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.mwaa_role_trust.json
}
#Creating the  policy1
resource "aws_iam_policy" "mwaa_policy_1" {
  name   = "distill-mwaa-service-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.mwaa_policy_svc.json
}

#attaching the policy1 to the role
resource "aws_iam_role_policy_attachment" "mwaa_policy_1_attachment" {
  role       = aws_iam_role.mwaa_role_1.id
  policy_arn = aws_iam_policy.mwaa_policy_1.arn
}

#policy1 permission statements
data "aws_iam_policy_document" "mwaa_policy_svc" {
  statement {
    sid    = "VisualEditor0"
    effect = "Allow"
    actions = [
      "cloudwatch:Put*",
      "cloudwatch:Get*",
      "cloudwatch:StartMetricStreams",
      "cloudwatch:Describe*",
      "cloudwatch:StopMetricStreams",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:SetAlarmState",
      "cloudwatch:DescribeInsightRules",
      "cloudwatch:DisableInsightRules",
      "cloudwatch:EnableInsightRules",
      "cloudwatch:EnableAlarmActions",
      "logs:DescribeLogStreams",
      "logs:Get*",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "elasticmapreduce:RunJobFlow",
      "rds:Describe*",
      "sns:*",
      "ses:*",
      "sqs:*",

    ]
    resources = ["*"]
  }
  statement {
    sid    = "VisualEditor1"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"

    ]
    resources = [
      "arn:aws:secretsmanager:us-east-1:${var.AWS_ACC_ID}:secret:secret_*",
      "arn:aws:kms:us-east-1:${var.AWS_ACC_ID}:key/*"
    ]
  }

  statement {
    sid     = "PassRoleForElasticMapReduce"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::*:role/Roche-Distill-*",
      "arn:aws:iam::*:role/*"
    ]
  }

}


##Policy 2 managed policy
#data we are calling the managed policy ARN
#another option create data.tf file and add these statements abd in 73 call data.<<location>>
data "aws_iam_policy" "CWlogsMgd" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "mwaa_policy_2_attachment" {
  role       = aws_iam_role.mwaa_role_1.id
  policy_arn = data.aws_iam_policy.CWlogsMgd.arn
}

##Policy 3 -Manged EMRfullaccessPolicy
data "aws_iam_policy" "EmrfullMgd" {
  arn = "arn:aws:iam::aws:policy/AmazonEMRFullAccessPolicy_v2"
}

resource "aws_iam_role_policy_attachment" "mwaa_policy_3_attachment" {
  role       = aws_iam_role.mwaa_role_1.id
  policy_arn = data.aws_iam_policy.EmrfullMgd.arn
}

#Creating the  policy4
resource "aws_iam_policy" "mwaa_policy_4" {
  name   = "distill-superDAG-execution-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.mwaa_policy_dag.json
}

#attaching the policy1 to the role
resource "aws_iam_role_policy_attachment" "mwaa_policy_4_attachment" {
  role       = aws_iam_role.mwaa_role_1.id
  policy_arn = aws_iam_policy.mwaa_policy_4.arn
}

data "aws_iam_policy_document" "mwaa_policy_dag" {
  statement {
    sid    = "VisualEditor3"
    effect = "Allow"
    actions = [
      "airflow:CreateCliToken"
    ]
    resources = ["*"]
  }
}



#Creating the SSM policy5
resource "aws_iam_policy" "mwaa_policy_5" {
  name   = "distill-mwaa-ssm-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.mwaa_policy_ssm.json
}

#attaching the policy to the role
resource "aws_iam_role_policy_attachment" "mwaa_policy_5_attachment" {
  role       = aws_iam_role.mwaa_role_1.id
  policy_arn = aws_iam_policy.mwaa_policy_5.arn
}
data "aws_iam_policy_document" "mwaa_policy_ssm" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:ListDocuments",
      "ssm:ListDocumentVersions",
      "ssm:DescribeDocument",
      "ssm:GetDocument",
      "ssm:DescribeInstanceInformation",
      "ssm:DescribeDocumentParameters",
      "ssm:DescribeInstanceProperties",
      "ssm:CancelCommand",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations",
      "ec2:DescribeInstanceStatus",
      "ssm:DescribeAutomationExecutions",
      "ssm:StopAutomationExecution",
      "ssm:GetAutomationExecution"
    ]

    resources = ["*"]
  }
  statement {
    actions = ["ssm:SendCommand"]
    effect  = "Allow"
    resources = [
      "arn:aws:ssm:eu-central-1:*:instance/*",
      "arn:aws:ssm:eu-central-1:${var.AWS_ACC_ID}:document/Distill-CCF-Document"
    ]
  }

  statement {
    actions = ["ssm:StartAutomationExecution"]
    effect  = "Allow"
    resources = [
      "arn:aws:ssm:eu-central-1:${var.AWS_ACC_ID}:automation-definition/*"
    ]
  }
}


#Creating the S3RW policy6
resource "aws_iam_policy" "mwaa_policy_6" {
  name   = "distill-mwaa-s3-read-write-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.mwaa_policy_s3rw.json
}

#attaching the policy to the role
resource "aws_iam_role_policy_attachment" "mwaa_policy_6_attachment" {
  role       = aws_iam_role.mwaa_role_1.id
  policy_arn = aws_iam_policy.mwaa_policy_6.arn
}


data "aws_iam_policy_document" "mwaa_policy_s3rw" {
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