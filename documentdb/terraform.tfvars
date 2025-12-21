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

# S3 buckets requested in the ticket (internal account)
# (Only include if your root module has variables for these)
s3_buckets = [
  "mwt.feedwork",
  "mwt.feedwork-staging"
]

# IAM role requested in the ticket (internal account)
# (Only include if your root module has variables for these)
iam_roles = {
  dnet_FeedworkRole = {
    name = "dnet_FeedworkRole"

    managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess",
      "arn:aws:iam::aws:policy/AWSLambdaRole",
      "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
    ]

    # Custom policy name mentioned in the ticket (attach if you manage it in TF)
    custom_policy_names = [
      "dnet_OracleSecretsPolicy"
    ]

    # Additional access requested:
    # - Full access on buckets mwt.feedwork and mwt.feedwork-staging
    # - Access to the secret referenced in the cluster
    s3_full_access_buckets = [
      "mwt.feedwork",
      "mwt.feedwork-staging"
    ]

    secret_arns = [
      "arn:aws:secretsmanager:<region>:<account_id>:secret:dnet_FeedworkDocumentDB-<suffix>"
    ]
  }
}

# User access requested (mwtdotnet) to the same secret
# (Only include if your root module has variables for this)
secret_read_principals = [
  {
    principal_type = "user"
    principal_name = "mwtdotnet"
    secret_arns = [
      "arn:aws:secretsmanager:<region>:<account_id>:secret:dnet_FeedworkDocumentDB-<suffix>"
    ]
  }
]
