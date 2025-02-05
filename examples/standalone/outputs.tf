# ################################################################################
# # Cluster
# ################################################################################

output "cluster_arn" {
  description = "The ARN of the ElastiCache Cluster"
  value       = module.redis.cluster_arn
}

output "cluster_engine_version_actual" {
  description = "Because ElastiCache pulls the latest minor or patch for a version, this attribute returns the running version of the cache engine"
  value       = module.redis.cluster_engine_version_actual
}

output "cluster_cache_nodes" {
  description = "List of node objects including `id`, `address`, `port` and `availability_zone`"
  value       = module.redis.cluster_cache_nodes
}

output "cluster_address" {
  description = "(Memcached only) DNS name of the cache cluster without the port appended"
  value       = module.redis.cluster_address
}

output "cluster_configuration_endpoint" {
  description = "(Memcached only) Configuration endpoint to allow host discovery"
  value       = module.redis.cluster_configuration_endpoint
}
