provider "aws" {
  region = local.region
}

locals {
  name        = "complete-redis"
  region      = "us-east-1"
  environment = "dev"
}

module "redis" {
  source = "../../"

  environment = local.environment
  name        = local.name
  region      = local.region

  engine_version     = "6.x"
  port               = 6379
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 2
  family             = "redis6.x"
  availability_zones = ["us-east-1a", "us-east-1b"]
  vpc_id             = module.vpc.vpc_id
}
