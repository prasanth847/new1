#Creating roles and policies for Roche-Distill-vender-transfer-role-<ENV>
#Role Trust relationship part
data "aws_iam_policy_document" "sm01_role_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "transfer.amazonaws.com"
      ]
    }
  }
}

#Creating the role
resource "aws_iam_role" "sm_role_1" {
  name               = "Roche-Distill-vender-transfer-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.sm01_role_trust.json
}

#creating policy 1
resource "aws_iam_policy" "sn01_policy" {
  name   = "distill-SecretManger-KMS-full-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.sm1kms_policy.json
}

#attaching the policy1 to the role
resource "aws_iam_role_policy_attachment" "sm1_policy_1_attachment" {
  role       = aws_iam_role.sm_role_1.id
  policy_arn = aws_iam_policy.sn01_policy.arn
}

#policy1 permission statements
data "aws_iam_policy_document" "sm1kms_policy" {

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
}


#Creating the S3Limited policy2 -distill-s3-limited-access-policy-<<env>>
resource "aws_iam_policy" "s3_sm_policy_1" {
  name   = "distill-s3-limited-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.s3_limited_policy.json
}

#attaching the policy to the role
resource "aws_iam_role_policy_attachment" "s3limited_policy_1_attachment" {
  role       = aws_iam_role.sm_role_1.id
  policy_arn = aws_iam_policy.s3_sm_policy_1.arn
}


data "aws_iam_policy_document" "s3_limited_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:List*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
      "s3:GetObjectACL",
      "s3:PutObjectACL"
    ]
    resources = [
      # "arn:aws:s3:::roche-distill-dev/Proxim/*",
      # "arn:aws:s3:::distill-dev-stg/umotif/*"
      "arn:aws:s3:::${var.stg_bucket_name}-${var.Environment1}/umotif/*",
      "arn:aws:s3:::${var.data_bucket_name}-${var.Environment1}/Proxim/*",

    ]
  }
  statement {
    sid       = "VisualEditor2"
    effect    = "Deny"
    actions   = ["s3:DeleteBucket"]
    resources = ["*"]
  }
}