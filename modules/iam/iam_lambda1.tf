#Creating roles and policies for Roche-Distill-lambda-transfer-role-<ENV>
#Role Trust relationship part
data "aws_iam_policy_document" "lambda1_role_trust" {
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
resource "aws_iam_role" "lambda_role_1" {
  name               = "Roche-Distill-lambda-transfer-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda1_role_trust.json
}

##Policy 1 managed policy
data "aws_iam_policy" "Lambda1Mgd" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_1_attachment" {
  role       = aws_iam_role.lambda_role_1.id
  policy_arn = data.aws_iam_policy.Lambda1Mgd.arn
}

#Creating the S3RW policy5 -distill-lambda-SecretManager-sftp-access-policy-<<env>>
resource "aws_iam_policy" "sm_sftppolicy_1" {
  name   = "distill-lambda-SecretManager-sftp-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.sm_sftp_policy.json
}

#attaching the policy5 to the role
resource "aws_iam_role_policy_attachment" "smsftp_policy_01_attachment" {
  role = aws_iam_role.lambda_role_1.id
  policy_arn = aws_iam_policy.sm_sftppolicy_1.arn
}

data "aws_iam_policy_document" "sm_sftp_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = ["arn:aws:secretsmanager:us-east-1:${var.AWS_ACC_ID}:secret:SFTP/*"]

  }
}