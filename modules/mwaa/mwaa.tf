resource "aws_mwaa_environment" "distill_mwaa" {
  dag_s3_path        = "dags/"
  execution_role_arn = var.mwaa_role_1arn
  name               = "distill_mwaa_${var.Environment1}"
  environment_class  = var.environment_class
  max_workers       = var.max_workers
  min_workers       = var.min_workers
  #kms_key            = var.KMS_Key #the same bucket ARN
  airflow_version    = "2.2.2"
  schedulers = var.schedulers
 logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "WARNING"
    }

    scheduler_logs {
      enabled   = true
      log_level = "WARNING"
    }

    task_logs {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs {
      enabled   = true
      log_level = "WARNING"
    }

    worker_logs {
      enabled   = true
      log_level = "WARNING"
    }
  }

  network_configuration {
    security_group_ids =  [var.distill-mwaa-sgid]
    subnet_ids         = var.private_subnet_ids #2 private subnet is mandatory
  }
#provide MWAA S3 bucket details
  source_bucket_arn = var.distillmwaaBucketarn

   tags = {
    Project        = "Distill"
    Environment = "${var.Environment1}"
  }
}


