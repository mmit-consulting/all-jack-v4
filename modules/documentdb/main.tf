locals {
  total_instances = 1 + var.replica_count
}

# Read the manually-created secret (UI-created). We only read it.
data "aws_secretsmanager_secret_version" "docdb" {
  secret_id = var.existing_secret_arn
}

locals {
  secret_json = jsondecode(data.aws_secretsmanager_secret_version.docdb.secret_string)

  # Use username from secret if provided, else fallback to var.master_username
  master_username = try(local.secret_json.username, var.master_username)

  # Password MUST exist in secret JSON
  master_password = local.secret_json.password
}

resource "aws_docdb_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier = var.name
  engine            = var.engine
  engine_version    = var.engine_version

  master_username = local.master_username
  master_password = local.master_password
  port            = var.port

  db_subnet_group_name   = aws_docdb_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  storage_encrypted   = var.storage_encrypted
  kms_key_id          = var.kms_key_id
  deletion_protection = var.deletion_protection
  apply_immediately   = var.apply_immediately

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : var.final_snapshot_identifier

  tags = var.tags
}

resource "aws_docdb_cluster_instance" "this" {
  count              = local.total_instances
  identifier         = "${var.name}-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class

  apply_immediately = var.apply_immediately

  enable_performance_insights          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  tags = var.tags
}
