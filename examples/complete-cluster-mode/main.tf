locals {
  name                    = "redis"
  region                  = "us-east-2"
  family                  = "redis6.x"
  node_type               = "cache.t3.small"
  vpc_cidr                = "10.0.0.0/16"
  environment             = "prod"
  allowed_security_groups = ["sg-02c3f55874f6e0c64"]
  redis_engine_version    = "6.0"
  additional_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
  current_identity           = data.aws_caller_identity.current.arn
  availability_zones = slice(data.aws_availability_zones.primary.names, 0, 3)
  cluster_mode_enabled = true
}

data "aws_availability_zones" "primary" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "kms" {
  source = "terraform-aws-modules/kms/aws"

  deletion_window_in_days = 7
  description             = "Complete key example showing various configurations available"
  enable_key_rotation     = false
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  # Policy
  enable_default_policy = true
  key_owners            = [local.current_identity]
  key_administrators    = [local.current_identity]
  key_users             = [local.current_identity]
  key_service_users     = [local.current_identity]
  key_statements = [
    {
      sid = "Allow use of the key"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type = "Service"
          identifiers = [
            "elasticache.amazonaws.com"
          ]
        }
      ]
    },
    {
      sid       = "Enable IAM User Permissions"
      actions   = ["kms:*"]
      resources = ["*"]

      principals = [
        {
          type = "AWS"
          identifiers = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn,
          ]
        }
      ]
    }
  ]

  # Aliases
  aliases = ["${local.name}"]

  tags = local.additional_tags
}

module "vpc" {
  source                  = "squareops/vpc/aws"
  version                 = "3.3.1"
  name                    = local.name
  vpc_cidr                = local.vpc_cidr
  environment             = local.environment
  availability_zones      = local.availability_zones
  public_subnet_enabled   = true
  auto_assign_public_ip   = true
  intra_subnet_enabled    = false
  private_subnet_enabled  = true
  one_nat_gateway_per_az  = false
  database_subnet_enabled = true
}

module "redis" {
  source                           = "squareops/elasticache-redis/aws"
  name                             = local.name
  family                           = local.family
  node_type                        = local.node_type
  environment                      = local.environment
  engine_version                   = local.redis_engine_version
  cluster_mode_enabled             = local.cluster_mode_enabled
  cluster_mode_num_node_groups     = 1
  cluster_mode_replicas_per_node_group = 2
  vpc_id                           = module.vpc.vpc_id
  subnets                          = module.vpc.database_subnets
  kms_key_arn                      = module.kms.key_arn
  multi_az_enabled                 = true
  availability_zones               = local.availability_zones
  snapshot_window                  = "07:00-08:00"
  maintenance_window               = "sun:09:00-sun:10:00"
  allowed_security_groups          = local.allowed_security_groups
  cloudwatch_metric_alarms_enabled = false
  alarm_cpu_threshold_percent      = 70
  alarm_memory_threshold_bytes     = "10000000" # in bytes
  slack_notification_enabled       = false
  slack_username                   = ""
  slack_channel                    = ""
  slack_webhook_url                = ""
}
