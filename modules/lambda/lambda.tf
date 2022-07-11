#Lambda function1 roche-distill-vendor-transfer-lambda-<env>
resource "aws_lambda_function" "vender_transfer_lambda" {
  filename      = ".\\vender_lambda_function.zip" #this will be used when we are uploading souce code
  function_name = "roche-distill-vendor-transfer-lambda-${var.Environment1}"
  role          =  var.lambda_role_1
  handler       = "lambda_function.lambda_handler" #adding from code
  runtime       = "python3.9"
  package_type  = "Zip"
}

#Lambda function2 roche-distill-token-authorizer-lambda-<env>
resource "aws_lambda_function" "token_auth_lambda" {
  filename      = ".\\token_lambda_function.zip" #this will be used when we are uploading souce code
  function_name = "roche-distill-token-authorizer-lambda-${var.Environment1}"
  role          = var.lambda_role_2
  handler       = "lambda_function.lambda_handler" #adding from code
  runtime       = "python3.9"
  package_type  = "Zip"
}

#Lambda function3 roche-distill-api-lambda-<dev>

resource "aws_lambda_function" "api_lambda_func" {
  filename      = ".\\api_lambda_function.zip" #this will be used when we are uploading souce code
  function_name = "roche-distill-api-lambda-${var.Environment1}"
  role          = var.lambda_role_3
  handler       = "lambda_function.lambda_handler" #adding from code
  runtime       = "python3.9"
  package_type  = "Zip"
}

