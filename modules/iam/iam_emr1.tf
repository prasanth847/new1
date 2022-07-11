#Creating Roche-Distill-EMR-service-role-<ENV> and Policies
#Role Trust relationship part
data "aws_iam_policy_document" "emr1_role_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "elasticmapreduce.amazonaws.com"
      ]
    }
  }
}

#Creating the role
resource "aws_iam_role" "emr_role_1" {
  name               = "Roche-Distill-EMR-service-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.emr1_role_trust.json
}

##Policy 1 managed policy
data "aws_iam_policy" "Emr1Mgd" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_role_policy_attachment" "emr_policy_1_attachment" {
  role       = aws_iam_role.emr_role_1.id
  policy_arn = data.aws_iam_policy.Emr1Mgd.arn
}


#policy2

#Creating the  policy2  -Amazon-EMR-service-distill-dev-policy - renaming it to distill-emr-service-policy-dev
resource "aws_iam_policy" "emrsvc1" {
  name   = "distill-emr-service-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.emr1_policy_svc.json
}

#attaching the policy1 to the role
resource "aws_iam_role_policy_attachment" "emr1_policy_1_attachment" {
  role       = aws_iam_role.emr_role_1.id
  policy_arn = aws_iam_policy.emrsvc1.arn
}

#policy1 permission statements
data "aws_iam_policy_document" "emr1_policy_svc" {

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AttachNetworkInterface",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CancelSpotInstanceRequests",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteTags",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:Get*",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePrefixLists",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcEndpointServices",
      "ec2:DescribeVpcs",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:RequestSpotInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:TerminateInstances",
      "ec2:*",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:ModifyNetworkInterfaceAttribute",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListInstanceProfiles",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "s3:CreateBucket",
      "s3:Get*",
      "autoscaling:*",
      "s3:List*",
      "sdb:BatchPutAttributes",
      "sdb:Select",
      "sqs:CreateQueue",
      "sqs:Delete*",
      "sqs:GetQueue*",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms",
      "application-autoscaling:RegisterScalableTarget",
      "application-autoscaling:DeregisterScalableTarget",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:DeleteScalingPolicy",
      "application-autoscaling:Describe*"
    ]
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
    sid       = "EC2RunInstances"
    effect    = "Allow"
    actions   = ["ec2:RunInstances"]
    resources = ["arn:aws:ec2:us-east-1:${var.AWS_ACC_ID}:instance/*"]
    condition {
      test     = "ForAllValues:StringEquals"
      variable   = "ec2:InstanceProfile"
      values = ["arn:aws:iam::${var.AWS_ACC_ID}:role/${aws_iam_role.emr_role_2.name}"]
    }
  }

statement {
  sid     = "EC2RunInstancesSubnet"
  effect  = "Allow"
  actions = ["ec2:RunInstances"]
  resources = [
    "arn:aws:ec2:us-east-1:${var.AWS_ACC_ID}:subnet/*"
  ]
  condition {
    test     = "ForAllValues:StringEquals"
    variable   = "ec2:vpc"
    values = ["arn:aws:ec2:us-east-1:${var.AWS_ACC_ID}:vpc/${var.VPC_ID}"]
  }
}

statement {
  sid     = "RemainingRunInstancePermissions"
  effect  = "Allow"
  actions = ["ec2:RunInstances"]
  resources = [
    "arn:aws:ec2:us-east-1:${var.AWS_ACC_ID}:key-pair/*distill*",
    "arn:aws:ec2:us-east-1:${var.AWS_ACC_ID}:volume/*",
    "arn:aws:ec2:us-east-1:${var.AWS_ACC_ID}:network-interface/*",
    "arn:aws:ec2:us-east-1:${var.AWS_ACC_ID}:security-group/*",
    "arn:aws:ec2:us-east-1::image/*",
    "arn:aws:ec2:us-east-1::snapshot/*"
  ]
}
statement {
  effect    = "Allow"
  actions   = ["iam:CreateServiceLinkedRole"]
  resources = ["arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot*"]
  condition {
    test   = "ForAllValues:StringEquals"
    variable = "iam:AWSServiceName"
    values = [
      "autoscaling.amazonaws.com",
      "ec2scheduled.amazonaws.com",
      "elasticloadbalancing.amazonaws.com",
      "spot.amazonaws.com",
      "spotfleet.amazonaws.com",
      "transitgateway.amazonaws.com"
    ]

  }
}

statement {
  sid     = "SecretsManager"
  effect  = "Allow"
  actions = ["secretsmanager:GetSecretValue"]
  resources = [
    "arn:aws:secretsmanager:us-east-1:${var.AWS_ACC_ID}:secret:*secret*",
    "arn:aws:secretsmanager:us-east-1:${var.AWS_ACC_ID}:secret:*secret*dev*"
  ]
}
}