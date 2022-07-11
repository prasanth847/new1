variable "Environment1" {
  type    = string
  default = "dev"
}

#key value hardcoded here needs to be updated , when account creats roche will be creating the KMS key too
//variable "KMS_Key" {
//  type    = string
//  description = "The KMS key used to encrypt aws resources"
//  default = "arn:aws:kms:eu-central-1:206922815305:key/10a979ff-8ca3-49e0-9a2c-840867578f57"
//}

##S3 bucket folder structure
#roche-distill-code-<env> bucket folder structure
variable "s3_code_folders" {
    type = list(string)
    default = [ "CCF/Bootstrap/", "CCF/EMR/emr_logs/", "CCF/dqm/dqm_error_details/","CCF/dqm/dqm_summary/","CCF/sparklogs/sparkapphistory/","CCF/tmp/" ]

}
# roche-distill-mwaa-<env> bucket folder structure
variable "s3_mwaa_folders" {
    type = list(string)
    default = [ "dags", "plugins" ]

}

# roche-distill-stg-<env> bucket folder structure
variable "s3_stg_folders" {
    type = list(string)
    default = [ "bootstrap"]

}
# roche-distill-data-<env> bucket folder structure
variable "s3_data_folders" {
    type = list(string)
     default = [ "XE43505", "tardis/rhone-x", "koneksa/lopac","tardis/velodrome","umotif/beyondabr/","umotif/heminorth2/", ]

}
