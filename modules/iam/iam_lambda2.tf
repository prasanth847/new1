#Creating roles and policies for Roche-Distill-lambda-TokenAuthorizer-role-<ENV>
#Role Trust relationship part
data "aws_iam_policy_document" "lambda2_role_trust" {
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
resource "aws_iam_role" "lambda_role_2" {
  name               = "Roche-Distill-lambda-TokenAuthorizer-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda2_role_trust.json
}

##Policy 1 managed policy
data "aws_iam_policy" "Lambda2Mgd" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_001_attachment" {
  role       = aws_iam_role.lambda_role_2.id
  policy_arn = data.aws_iam_policy.Lambda2Mgd.arn
}

#Creating the SMRW policy2 -distill-lambda-SecretManager-read-access-policy-<<env>>
resource "aws_iam_policy" "smrw_policy_1" {
  name   = "distill-lambda-SecretManager-read-access-policy-${var.Environment1}"
  policy = data.aws_iam_policy_document.sm_policy_r.json
}

#attaching the policy to the role
resource "aws_iam_role_policy_attachment" "sm_policy_2_attachment" {
  role       = aws_iam_role.lambda_role_2.id
  policy_arn = aws_iam_policy.smrw_policy_1.arn
}


data "aws_iam_policy_document" "sm_policy_r" {

  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}