#Creating roles and policies for Roche-Distill-TransferFamily-role-<ENV>
#Role Trust relationship part
data "aws_iam_policy_document" "tf1_role_trust" {
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
resource "aws_iam_role" "tf_role_1" {
  name               = "Roche-Distill-TransferFamily-role-${var.Environment}"
  assume_role_policy = data.aws_iam_policy_document.tf1_role_trust.json
}

##Policy 2 managed policy
data "aws_iam_policy" "tfMgd" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"
}

resource "aws_iam_role_policy_attachment" "tf_policy_1_attachment" {
  role       = aws_iam_role.tf_role_1.id
  policy_arn = data.aws_iam_policy.tfMgd.arn
}