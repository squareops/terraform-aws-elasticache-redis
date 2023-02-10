locals {
  name        = "skaf"
  region      = "us-east-2"
  environment = "production"
  redis_engine_version = "6.x"
}

data "aws_availability_zones" "available" {}

module "redis" {
  source = "../../"  
  environment = local.environment
  name        = local.name
  engine_version  = local.redis_engine_version
  port            = 6379
  node_type       = "cache.t3.small"
  num_cache_nodes = 2
  family          = "redis6.x"
  availability_zones         = [for n in range(0, 2) : data.aws_availability_zones.available.names[n]]
  automatic_failover_enabled = true
  snapshot_retention_limit   = 7
  multi_az_enabled           = false
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false
  notification_topic_arn     = null
  vpc_id                     = "vpc-06e37f0786b7efaab"
  subnets                    = ["subnet-021320ad57f4ef6bb","subnet-04ec8cb5f9abd4941"]
  allowed_cidr_blocks        = []
  allowed_security_groups    = ["sg-028cc84f7ff452dfd"]
  maintenance_window         = "sun:09:00-sun:10:00"
  snapshot_window            = "07:00-08:00"
  kms_key_arn = "arn:aws:kms:us-east-2:271251951598:key/7fa600be-9c08-4502-a67a-ed7e8bc332cb"
}

