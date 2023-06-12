locals {
  tags = {
    Environment = var.environment
  }
  slow_log   = var.slow_log_destination == null ? [] : [1]
  engine_log = var.engine_log_destination == null ? [] : [1]
}

data "aws_availability_zones" "available" {}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_elasticache_parameter_group" "default" {
  name        = "${var.environment}-${var.name}-redis-parameter-group"
  family      = var.family
  description = var.parameter_group_description != null ? var.parameter_group_description : "Elasticache parameter group for ${var.environment}-${var.name}"
  tags = {
    Name        = "${var.environment}-${var.name}-redis-parameter-group"
    Environment = var.environment
  }
  # Ignore changes to the description since it will try to recreate the resource
  lifecycle {
    ignore_changes = [
      description,
    ]
  }
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id        = "${var.environment}-${var.name}-redis"
  port                        = var.port
  engine                      = "redis"
  node_type                   = var.node_type
  description                 = "Redis cluster for ${var.environment}-${var.name}-redis"
  engine_version              = var.engine_version
  num_cache_clusters          = var.num_cache_nodes
  parameter_group_name        = join("", aws_elasticache_parameter_group.default.*.name) #var.parameter_group_name
  security_group_ids          = [module.security_group_redis.security_group_id]
  subnet_group_name           = aws_elasticache_subnet_group.elasticache.id
  preferred_cache_cluster_azs = [for n in range(0, var.availability_zones) : data.aws_availability_zones.available.names[n]]
  snapshot_arns               = var.snapshot_arns
  snapshot_window             = var.snapshot_window
  snapshot_retention_limit    = var.snapshot_retention_limit
  automatic_failover_enabled  = var.automatic_failover_enabled
  multi_az_enabled            = var.multi_az_enabled
  kms_key_id                  = var.kms_key_arn
  auth_token                  = var.transit_encryption_enabled ? random_password.password.result : null
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  transit_encryption_enabled  = var.transit_encryption_enabled
  notification_topic_arn      = var.notification_topic_arn
  maintenance_window          = var.maintenance_window
  final_snapshot_identifier   = var.final_snapshot_identifier

  dynamic "log_delivery_configuration" {
    for_each = local.slow_log
    content {
      log_type         = "slow-log"
      log_format       = var.slow_log_format
      destination      = var.slow_log_destination
      destination_type = var.slow_log_destination_type
    }
  }

  dynamic "log_delivery_configuration" {
    for_each = local.engine_log
    content {
      log_type         = "engine-log"
      log_format       = var.engine_log_format
      destination      = var.engine_log_destination
      destination_type = var.engine_log_destination_type
    }
  }

  tags = {
    Name        = "${var.environment}-${var.name}"
    Environment = var.environment
  }
}

resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${var.environment}-${var.name}-redis"
  subnet_ids  = var.subnets
  description = "Elastic-cache Redis subnet-group"
  tags = {
    Name        = "${var.environment}-${var.name}-redis"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "default_ingress" {
  count = length(var.allowed_security_groups) > 0 ? length(var.allowed_security_groups) : 0

  description = "From allowed SGs"

  type                     = "ingress"
  to_port                  = var.port
  from_port                = var.port
  protocol                 = "tcp"
  security_group_id        = module.security_group_redis.security_group_id
  source_security_group_id = element(var.allowed_security_groups, count.index)
}

resource "aws_security_group_rule" "cidr_ingress" {
  count             = length(var.allowed_cidr_blocks) > 0 ? length(var.allowed_cidr_blocks) : 0
  description       = "From allowed CIDRs"
  type              = "ingress"
  to_port           = var.port
  from_port         = var.port
  protocol          = "tcp"
  cidr_blocks       = element(var.allowed_cidr_blocks, count.index)
  security_group_id = module.security_group_redis.security_group_id
}

module "security_group_redis" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.13.0"
  name        = format("%s-%s-%s", var.environment, var.name, "redis-sg")
  create      = true
  vpc_id      = var.vpc_id
  description = "Elastic-cache Redis security group"

  egress_with_cidr_blocks = [
    {
      to_port     = 0
      from_port   = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "redis-sg") },
    local.tags,
  )
}

resource "aws_secretsmanager_secret" "secret_redis" {
  count = var.transit_encryption_enabled ? 1 : 0
  name  = format("%s/%s/%s", var.environment, var.name, "redis-auth-token")
  tags = merge(
    { "Name" = format("%s/%s/%s", var.environment, var.name, "redis-auth-token") },
    local.tags,
  )
  recovery_window_in_days = var.recovery_window_aws_secret
}
