output "documentdb_clusters" {
  description = "DocumentDB clusters and endpoints"
  value = {
    for name, mod in module.documentdb : name => {
      cluster_id      = mod.cluster_id
      cluster_arn     = mod.cluster_arn
      endpoint        = mod.endpoint
      reader_endpoint = mod.reader_endpoint
      instance_ids    = mod.instance_ids
      secret_arn      = mod.secret_arn
    }
  }
}
