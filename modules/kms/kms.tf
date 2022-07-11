
#if KMS is not provided by ROCHE the below script will create a KMS key
#once it is created needs to update S3 file with the new KMS key details

##If we are using this update proper names and update in variable files too
 resource "aws_kms_key" "distill_kms_key" {
   description             = "KMS key to encrypt distill resources"
  }

 resource "aws_kms_alias" "distill_kms_key1" {
   name          = "alias/ams-distill-key"
   target_key_id = aws_kms_key.distill_kms_key.key_id
 }

