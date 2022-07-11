#Creating roles and policies for Roche-Distill-lambda-APIgateway-role-<ENV>
#Role Trust relationship part
data "aws_iam_policy_document" "lambda3_role_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}


#Creating the role
resource "aws_iam_role" "lambda_role_3" {
  name               = "Roche-Distill-lambda-APIgateway-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda3_role_trust.json
}

##Policy 1 managed policy
data "aws_iam_policy" "Lambda3Mgd1" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_01_attachment" {
  role       = aws_iam_role.lambda_role_3.id
  policy_arn = data.aws_iam_policy.Lambda3Mgd1.arn
}

##Policy 2 managed policy
data "aws_iam_policy" "Lambda3Mgd2" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_02_attachment" {
  role       = aws_iam_role.lambda_role_3.id
  policy_arn = data.aws_iam_policy.Lambda3Mgd2.arn
}

##Policy 3 managed policy
data "aws_iam_policy" "Lambda3Mgd3" {
  arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_03_attachment" {
  role       = aws_iam_role.lambda_role_3.id
  policy_arn = data.aws_iam_policy.Lambda3Mgd3.arn
}

##policy4 KMS full access
resource "aws_iam_policy" "kmspolicy" {
  name   = "distill-lambda-KMS-full-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.kms1_policy.json
}

#attaching the KMSpolicy1 to the role
resource "aws_iam_role_policy_attachment" "kms1_policy_1_attachment" {
  role       = aws_iam_role.lambda_role_3.id
  policy_arn = aws_iam_policy.kmspolicy.arn
}

#KMSpolicy1 permission statements
data "aws_iam_policy_document" "kms1_policy" {

statement  {
            sid ="KMS"
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

#Creating the S3RW policy5 -distill-lambda-S3-read-write-policy-<<env>>
resource "aws_iam_policy" "s3_rwpolicy_5" {
  name   = "distill-lambda-S3-read-write-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.s3_rwpolicy_lambda3.json
}

#attaching the policy5 to the role
resource "aws_iam_role_policy_attachment" "s3_policy_5_attachment" {
  role       = aws_iam_role.lambda_role_3.id
  policy_arn = aws_iam_policy.s3_rwpolicy_5.arn
}


data "aws_iam_policy_document" "s3_rwpolicy_lambda3" {
 statement {
            sid =  "VisualEditor0"
            effect =  "Allow"
            actions = ["s3:List*"]
            resources = [ "*" ]
        }
       statement {
            sid =  "VisualEditor1"
           effect =  "Allow"
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
        statement{
            sid =  "VisualEditor2"
           effect =  "Deny"
           actions = ["s3:DeleteBucket"]
            resources = ["*"]
        }

}


#attaching the already created SMread policy6 distill-lambda-SecretManager-read-access-policy-<<env>> to the role
resource "aws_iam_role_policy_attachment" "smr_policy_1_attachment" {
  role       = aws_iam_role.lambda_role_3.id
  policy_arn = aws_iam_policy.smrw_policy_1.arn
}