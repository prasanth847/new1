output "lambda_role1"{
  value = aws_iam_role.lambda_role_1.arn
}

output "lambda_role2"{
  value = aws_iam_role.lambda_role_2.arn
}

output "lambda_role3"{
  value = aws_iam_role.lambda_role_3.arn
}

output "mwaa_role_1"{
  value = aws_iam_role.mwaa_role_1.arn
}

output "tf_role_1"{
  value = aws_iam_role.tf_role_1.arn
}

output "aws_iam_role_redshift_role_arn"{
  value = aws_iam_role.redshift_role.arn
}