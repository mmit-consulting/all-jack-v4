variable "name" {
  description = "DocumentDB cluster identifier (e.g., dnet_feedfiles-staging)"
  type        = string
}

variable "engine" {
  description = "DocumentDB engine"
  type        = string
  default     = "docdb"
}

variable "engine_version" {
  description = "DocumentDB engine version (e.g., 8.0.0)"
  type        = string
  default     = "8.0.0"
}

variable "instance_class" {
  description = "DocumentDB instance class (e.g., db.t3.medium)"
  type        = string
  default     = "db.t3.medium"
}

variable "replica_count" {
  description = "Number of read replicas. Total instances = 1 writer + replica_count."
  type        = number
  default     = 1

  validation {
    condition     = var.replica_count >= 0
    error_message = "replica_count must be >= 0."
  }
}

variable "port" {
  description = "DocumentDB port"
  type        = number
  default     = 27017
}

variable "master_username" {
  description = "Master username (used if not present in the secret JSON)."
  type        = string
  default     = "appservice"
}

variable "existing_secret_arn" {
  description = <<EOT
ARN of an existing AWS Secrets Manager secret (created manually) containing SecretString JSON with at least:
  { "password": "..." }
Optionally includes:
  { "username": "appservice", "password": "..." }
EOT
  type = string

  validation {
    condition     = length(var.existing_secret_arn) > 0
    error_message = "existing_secret_arn must be provided (non-empty)."
  }
}

# Networking
variable "subnet_ids" {
  description = "Subnet IDs used for the DocumentDB subnet group (typically private subnets)."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "subnet_ids must include at least one subnet (recommended: 2+ across AZs)."
  }
}

variable "security_group_ids" {
  description = "Security group IDs attached to the DocumentDB cluster."
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) >= 1
    error_message = "security_group_ids must include at least one security group."
  }
}

# Encryption / lifecycle
variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Optional KMS key for storage encryption (null uses AWS-managed key)"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier (required if skip_final_snapshot=false)"
  type        = string
  default     = null
}

# Backup / maintenance
variable "backup_retention_period" {
  description = "Backup retention in days"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window (UTC), e.g. 03:00-04:00"
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window (UTC), e.g. sun:05:00-sun:06:00"
  type        = string
  default     = null
}

# Logs
variable "cloudwatch_logs_exports" {
  description = "CloudWatch logs exports to enable (e.g., [\"audit\",\"profiler\"])"
  type        = list(string)
  default     = ["audit", "profiler"]
}

# Performance Insights
variable "performance_insights_enabled" {
  description = "Enable Performance Insights on instances."
  type        = bool
  default     = true
}

variable "performance_insights_kms_key_id" {
  description = "Optional KMS key for Performance Insights (null uses AWS-managed)."
  type        = string
  default     = null
}


variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
