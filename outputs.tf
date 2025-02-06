output "elastic_cache_redis_primary_endpoint_address" {
  description = "Primary endpoint address of redis"
  value       = var.cluster_mode_enabled ? join("", aws_elasticache_replication_group.redis[*].configuration_endpoint_address) : join("", aws_elasticache_replication_group.redis[*].primary_endpoint_address)

}
output "elastic_cache_redis_subnet_group_name" {
  description = "Subnet group name of the elasticache_redis cluster"
  value       = aws_elasticache_subnet_group.elasticache.name
}

output "elastic_cache_redis_cluster_id" {
  description = "ID of the elasticache-redis cluster"
  value       = aws_elasticache_replication_group.redis[*].id
}

output "elastic_cache_redis_port" {
  description = "Port number of Redis"
  value       = var.port
}

output "reader_endpoint_address" {
  value       = join("", compact(aws_elasticache_replication_group.redis[*].reader_endpoint_address))
  description = "The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled."
}

output "elastic_cache_redis_security_group" {
  description = "The security group ID of the cluster"
  value       = module.security_group_redis.security_group_id
}

output "auth_token_password" {
  description = "Elasticache-redis auth token password(redis password may be old, because Terraform doesn't track it after initial creation)"
  value       = var.transit_encryption_enabled ? nonsensitive(random_password.password[0].result) : null
}

output "elastic_cache_redis_member_clusters" {
  description = "ID of the elasticache-redis cluster"
  value       = flatten(aws_elasticache_replication_group.redis[*].member_clusters)
}

output "cluster_arn" {
  description = "The ARN of the ElastiCache Cluster"
  value       = try(aws_elasticache_cluster.redis[0].arn, null)
}

output "cluster_engine_version_actual" {
  description = "Because ElastiCache pulls the latest minor or patch for a version, this attribute returns the running version of the cache engine"
  value       = try(aws_elasticache_cluster.redis[0].engine_version_actual, null)
}

output "cluster_cache_nodes" {
  description = "List of node objects including `id`, `address`, `port` and `availability_zone`"
  value       = try(aws_elasticache_cluster.redis[0].cache_nodes, null)
}

output "cluster_address" {
  description = "(Memcached only) DNS name of the cache cluster without the port appended"
  value       = try(aws_elasticache_cluster.redis[0].cluster_address, null)
}

output "cluster_configuration_endpoint" {
  description = "(Memcached only) Configuration endpoint to allow host discovery"
  value       = try(aws_elasticache_cluster.redis[0].configuration_endpoint, null)
}
