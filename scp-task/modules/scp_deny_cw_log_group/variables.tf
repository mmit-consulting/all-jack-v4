variable "name" {
  type        = string
  default     = "DenyCloudWatchLogGroupCreation"
  description = "Name of the SCP."
}

variable "description" {
  type        = string
  default     = "Block creation of new CloudWatch log groups in selected accounts."
  description = "Description of the SCP."
}

variable "enabled_account_ids" {
  type        = set(string)
  default     = []
  description = <<EOT
Set of AWS account IDs where the SCP should be attached.
Only these accounts are affected. If empty, the policy is created but not attached anywhere.
EOT
}
