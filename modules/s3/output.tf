output "distillcodeBucketAccess"{
  value = aws_s3_bucket.distillcodeBucket.id
}

output "distillmwaaBucketAccess"{
  value = aws_s3_bucket.distillmwaaBucket.id
}

output "distillstgBucketAccess"{
  value = aws_s3_bucket.distillstgBucket.id
}

output "distilldataBucketAccess"{
  value = aws_s3_bucket.distilldataBucket.id
}

output "s3_bucket"{
  value = aws_s3_bucket.distillmwaaBucket.arn
}