output "function_name"{
  value = aws_lambda_function.api_lambda_func.arn
}

output "vender_transfer_lambda"{
  value = aws_lambda_function.vender_transfer_lambda.arn
}