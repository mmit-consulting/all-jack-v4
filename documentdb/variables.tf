variable "documentdb_clusters" {
  description = <<EOT
Map of DocumentDB clusters to create.

Each key is a logical cluster name.
Each value defines cluster + instance configuration.
EOT

  type = map(object({
    name                    = string
    engine_version          = string
    instance_class          = string
    replica_count           = number
    existing_secret_arn     = string
    subnet_ids              = list(string)
    security_group_ids      = list(string)
    performance_insights    = optional(bool, true)
    cloudwatch_logs_exports = optional(list(string), ["audit", "profiler"])
    tags                    = optional(map(string), {})
  }))
}
