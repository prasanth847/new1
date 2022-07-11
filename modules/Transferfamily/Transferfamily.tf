
#creating the SFTP transferFamily server
resource "aws_transfer_server" "transferFamily1" {
  identity_provider_type = "AWS_LAMBDA"
  function               = var.vender_transfer_lambdaarn
  security_policy_name   = "TransferSecurityPolicy-2018-11"
  protocols              = ["SFTP"]
  logging_role           = var.tf_role_1arn
  domain                 = "S3"

  tags = {
    Project : "Distill"
  }
}