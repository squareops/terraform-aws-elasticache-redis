output "primary_endpoint_address" {
  description = "Primary endpoint address of redis"
  value       = module.redis.elastic_cache_redis_primary_endpoint_address
}

output "redis_subnet_group_name" {
  description = "Subnet group name of the elasticache-redis cluster"
  value       = module.redis.elastic_cache_redis_subnet_group_name

}

output "id_of_redis_cluster" {
  description = "ID of the elasticache-redis cluster"
  value       = module.redis.elastic_cache_redis_cluster_id
}

output "redis_member_clusters" {
  description = "Subnet group name of the elasticache-redis cluster"
  value       = module.redis.elastic_cache_redis_member_clusters

}

output "port_no" {
  description = "Port number of Redis"
  value       = module.redis.elastic_cache_redis_port
}

output "elastic_cache_redis_reader_endpoint" {
  description = "Elasticache-redis cluster primary endpoint address"
  value       = module.redis.reader_endpoint_address
}

output "elastic_cache_redis_security_group" {
  description = "The security group ID of the cluster"
  value       = module.redis.elastic_cache_redis_security_group
}

output "auth_token_password" {
  description = "Elasticache-redis auth token password(this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.redis.auth_token_password
}
