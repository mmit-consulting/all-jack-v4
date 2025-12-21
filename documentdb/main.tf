module "documentdb" {
  source = "./modules/documentdb"

  for_each = var.documentdb_clusters

  name           = each.value.name
  engine_version = each.value.engine_version
  instance_class = each.value.instance_class
  replica_count  = each.value.replica_count

  existing_secret_arn = each.value.existing_secret_arn

  subnet_ids         = each.value.subnet_ids
  security_group_ids = each.value.security_group_ids

  performance_insights_enabled = lookup(each.value, "performance_insights", true)
  cloudwatch_logs_exports      = lookup(each.value, "cloudwatch_logs_exports", ["audit", "profiler"])

  tags = each.value.tags
}
