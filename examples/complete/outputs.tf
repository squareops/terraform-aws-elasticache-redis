output "primary_endpoint_address" {
  description = "Primary endpoint address of redis"
  value       = module.redis.primary_endpoint_address
}

output "redis_subnet_group_name" {
  description = "Subnet group name of the elasticache-redis cluster"
  value       = module.redis.redis_subnet_group_name
}

output "id_of_redis_cluster" {
  description = "ID of the elasticache-redis cluster"
  value       = module.redis.id_of_redis_cluster
}

output "port_no" {
  description = "Port number of Redis"
  value       = module.redis.port_no
}

output "elastic-cache-redis-endpoint" {
  description = "Elasticache-redis cluster primary endpoint address"
  value       = module.redis.elastic-cache-redis-endpoint
}
