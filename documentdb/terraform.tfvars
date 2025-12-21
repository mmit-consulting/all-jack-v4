# terraform.tfvars
# Values filled from ticket ITINF-1955 / ITINF-17 screenshots.

documentdb_clusters = {
  dnet_feedfiles_staging = {
    # DocumentDB cluster settings
    name           = "dnet_feedfiles-staging"
    engine_version = "8.0.0"
    instance_class = "db.t3.medium"
    replica_count  = 1

    # Secret is created manually in the UI (preferred name: dnet_FeedworkDocumentDB)
    # Replace the ARN below with the real one once the secret exists.
    existing_secret_arn = "arn:aws:secretsmanager:<region>:<account_id>:secret:dnet_FeedworkDocumentDB-<suffix>"

    # Network (Advanced Settings)
    # VPC: mwt-internal-serverless
    subnet_ids = [
      "subnet-0667308d29752355c"
      # Recommended: add a 2nd private subnet in another AZ if available
      # "subnet-xxxxxxxxxxxxxxxxx"
    ]

    security_group_ids = [
      "sg-0184cc00d133fdb0c"
    ]

    # Monitoring / logs
    performance_insights    = true
    cloudwatch_logs_exports = ["audit", "profiler"]

    # Tags (from ticket table)
    tags = {
      application  = "feedwork"
      businessunit = "hoopla"
      department   = "itdv"
      environment  = "staging"
      owner        = "vgwilson"
    }
  }
}
