resource "aws_ssm_document" "distill_ssmDoc" {
  name          = "Distill-CCF-Document"
  document_type = "Command"

  content = <<DOC
  {
  "schemaVersion": "2.2",
  "description": "Run Command on EMR",
  "parameters": {
    "cmd": {
      "type": "String",
      "description": "Command to be run on EMR",
      "default": ""
    }
  },
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "run_shell_command",
      "inputs": {
        "runCommand": [
          "runuser -l hadoop -c '{{cmd}}'"
        ],
        "timeoutSeconds": "172800"
      }
    }
  ]
}
DOC
}