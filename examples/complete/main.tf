locals {
  name                    = "redis"
  region                  = "us-east-2"
  family                  = "redis6.x"
  node_type               = "cache.t3.small"
  vpc_id                  = "vpc-0220830b5260698db"
  subnet_ids              = ["subnet-0d4dee4a7ea31a96d", "subnet-07fdc14616382f833"]
  kms_key_arn             = ""
  environment             = "prod"
  redis_engine_version    = "6.0"
  allowed_security_groups = ["sg-02c3f55874f6e0c64"]
  additional_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "redis" {
  source                           = "squareops/elasticache-redis/aws"
  name                             = local.name
  family                           = local.family
  node_type                        = local.node_type
  environment                      = local.environment
  engine_version                   = local.redis_engine_version
  num_cache_nodes                  = 2
  vpc_id                           = local.vpc_id
  subnets                          = local.subnet_ids
  kms_key_arn                      = local.kms_key_arn
  multi_az_enabled                 = false
  availability_zones               = 2
  snapshot_window                  = "07:00-08:00"
  maintenance_window               = "sun:09:00-sun:10:00"
  allowed_security_groups          = local.allowed_security_groups
  cloudwatch_metric_alarms_enabled = true
  alarm_cpu_threshold_percent      = 70
  alarm_memory_threshold_bytes     = "10000000" # in bytes
  slack_username                   = ""
  slack_channel                    = ""
  slack_webhook_url                = ""
}
