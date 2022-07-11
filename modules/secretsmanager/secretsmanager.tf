#Recommendation is to crate it manually

// resource "aws_secretsmanager_secret" "distillRDSkms" {
//   name = "roche-distill-rds-key-${var.Environment1}"
//
// }
//
// resource "aws_secretsmanager_secret_version" "smRDS" {
//   secret_id     = aws_secretsmanager_secret.distillRDSkms.id
//   secret_string = jsonencode(var.RDSsecret)
//}