resource "aws_api_gateway_rest_api" "rest_api" {
 name = "roche-distill-high-payload-api-${var.Environment1}"
 description = "Proxy to handle requests to our API"
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = "upload"
}
resource "aws_api_gateway_method" "rest_api_put_method"{
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = "PUT"
  authorization = "NONE"
}
//  Creating a lambda resource based policy to allow API gateway to invoke the lambda function:
resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambda_funcarn
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.AWS_ACC_ID}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.rest_api_put_method.http_method}${aws_api_gateway_resource.rest_api_resource.path}"
}