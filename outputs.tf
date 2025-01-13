output "elastic_cache_redis_primary_endpoint_address" {
  description = "Primary endpoint address of redis"
  value       = var.cluster_mode_enabled ? join("", aws_elasticache_replication_group.redis[*].configuration_endpoint_address) : join("", aws_elasticache_replication_group.redis[*].primary_endpoint_address)

}
output "elastic_cache_redis_subnet_group_name" {
  description = "Subnet group name of the elasticache_redis cluster"
  value = var.num_cache_nodes > 1 ? aws_elasticache_replication_group.redis[0].id : aws_elasticache_cluster.redis[0].id
}

output "elastic_cache_redis_cluster_id" {
  description = "ID of the elasticache-redis cluster"
  value       = var.num_cache_nodes > 1 ? aws_elasticache_replication_group.redis[0].id : aws_elasticache_cluster.redis[0].id
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
  description = "Elasticache-redis auth token password(this password may be old, because Terraform doesn't track it after initial creation)"
  value       = var.transit_encryption_enabled ? nonsensitive(random_password.password[0].result) : null
}

output "elastic_cache_redis_member_clusters" {
  description = "ID of the elasticache-redis cluster"
  value       = (var.num_cache_nodes > 1 ? flatten(aws_elasticache_replication_group.redis[0].member_clusters) : aws_elasticache_cluster.redis[0].id)
}