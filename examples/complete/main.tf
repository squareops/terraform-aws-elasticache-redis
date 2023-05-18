locals {
  name                    = "skaf"
  region                  = "us-east-1"
  family                  = "redis6.x"
  node_type               = "cache.t3.small"
  vpc_id                  = "vpc-06f1a2f3a7"
  subnet_ids              = ["subnet-0bb128ab", "subnet-0b54928666a"]
  kms_key_arn             = "arn:aws:kms:us-east-1:2222222222:key/bcfdc1c5-1bbbdb467d90"
  environment             = "prod"
  redis_engine_version    = "6.0"
  allowed_security_groups = ["sg-0e8dab08e40"]
}

module "redis" {
  source                  = "git@github.com:sq-ia/terraform-aws-elasticache-redis.git"
  name                    = local.name
  family                  = local.family
  node_type               = local.node_type
  environment             = local.environment
  engine_version          = local.redis_engine_version
  num_cache_nodes         = 2
  vpc_id                  = local.vpc_id
  subnets                 = local.subnet_ids
  kms_key_arn             = local.kms_key_arn
  multi_az_enabled        = false
  availability_zones      = 2
  snapshot_window         = "07:00-08:00"
  maintenance_window      = "sun:09:00-sun:10:00"
  allowed_security_groups = local.allowed_security_groups
}
