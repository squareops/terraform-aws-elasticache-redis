locals {
  tags = {
    Environment = var.environment
  }
  slow_log   = var.slow_log_destination == null ? [] : [1]
  engine_log = var.engine_log_destination == null ? [] : [1]
}

resource "random_password" "password" {
  count   = var.transit_encryption_enabled ? 1 : 0
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
  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }
}

resource "aws_elasticache_cluster" "redis" {
  count               = var.num_cache_nodes == 1 ? 1 : 0  # Only create if num_cache_nodes == 1
  cluster_id          = "${var.environment}-${var.name}-standalone-redis"
  engine              = "redis"
  engine_version      = var.engine_version
  node_type           = var.node_type
  num_cache_nodes     = 1  # Standalone Redis can have only 1 node
  port                = var.port
  parameter_group_name = join("", aws_elasticache_parameter_group.default.*.name)
  security_group_ids  = [module.security_group_redis.security_group_id]
  subnet_group_name   = aws_elasticache_subnet_group.elasticache.id
  snapshot_window     = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit


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

resource "aws_elasticache_replication_group" "redis" {
  count                       = var.num_cache_nodes > 1 ? 1 : 0  # Only create if num_cache_nodes > 1
  replication_group_id        = "${var.environment}-${var.name}-cluster"
  port                        = var.port
  engine                      = "redis"
  node_type                   = var.node_type
  description                 = "Redis cluster for ${var.environment}-${var.name}-redis"
  engine_version              = var.engine_version
  num_cache_clusters          = var.num_cache_nodes # Standalone Redis has 1 node
  parameter_group_name        = join("", aws_elasticache_parameter_group.default.*.name) #var.parameter_group_name
  security_group_ids          = [module.security_group_redis.security_group_id]
  subnet_group_name           = aws_elasticache_subnet_group.elasticache.id
  preferred_cache_cluster_azs = length(var.availability_zones) == 0 ? null : [for n in range(0, var.num_cache_nodes) : element(var.availability_zones, n)]
  snapshot_arns               = var.snapshot_arns
  snapshot_window             = var.snapshot_window
  snapshot_retention_limit    = var.snapshot_retention_limit
  automatic_failover_enabled  = var.multi_az_enabled ? true : false
  multi_az_enabled            = var.multi_az_enabled
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  kms_key_id                  = var.at_rest_encryption_enabled ? var.kms_key_arn : null
  auth_token                  = var.transit_encryption_enabled ? random_password.password[0].result : null
  transit_encryption_enabled  = var.transit_encryption_enabled ? var.transit_encryption_enabled || random_password.password[0].result != null : false
  notification_topic_arn      = var.notification_topic_arn
  maintenance_window          = var.maintenance_window
  final_snapshot_identifier   = var.final_snapshot_identifier
  num_node_groups             = var.cluster_mode_enabled ? var.cluster_mode_num_node_groups : null
  replicas_per_node_group     = var.cluster_mode_enabled ? var.cluster_mode_replicas_per_node_group : null

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

resource "aws_secretsmanager_secret_version" "redis_credentials" {
  count         = var.transit_encryption_enabled ? 1 : 0
  secret_id     = aws_secretsmanager_secret.secret_redis[0].id
  secret_string = <<EOF
{
  "password": "${random_password.password[0].result}"
}
EOF
}

# Cloudwatch alarms
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = var.cloudwatch_metric_alarms_enabled ? 1 : 0
  alarm_name          = format("%s-%s-%s", var.environment, var.name, "cpu-utilization")
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = var.num_cache_nodes > 1 ? aws_elasticache_replication_group.redis[count.index].id : aws_elasticache_cluster.redis[0].id
  }

  alarm_actions = [aws_sns_topic.slack_topic[0].arn]
  ok_actions    = [aws_sns_topic.slack_topic[0].arn]
  depends_on    = [aws_sns_topic.slack_topic]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "cpu_metric") },
    local.tags,
  )
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count               = var.cloudwatch_metric_alarms_enabled ? 1 : 0
  alarm_name          = format("%s-%s-%s", var.environment, var.name, "used-memory")
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_memory_threshold_bytes

  dimensions = {
    CacheClusterId = var.num_cache_nodes > 1 ? aws_elasticache_replication_group.redis[count.index].id : aws_elasticache_cluster.redis[0].id
  }

  alarm_actions = [aws_sns_topic.slack_topic[0].arn]
  ok_actions    = [aws_sns_topic.slack_topic[0].arn]
  depends_on    = [aws_sns_topic.slack_topic]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "memory-metric") },
    local.tags,
  )
}

resource "aws_kms_key" "this" {
  count       = var.slack_notification_enabled ? 1 : 0
  description = "KMS key for notify-slack test"
}

resource "aws_kms_ciphertext" "slack_url" {
  count     = var.slack_notification_enabled ? 1 : 0
  plaintext = var.slack_webhook_url
  key_id    = aws_kms_key.this[0].arn
}

resource "aws_sns_topic" "slack_topic" {
  count           = var.cloudwatch_metric_alarms_enabled ? 1 : 0
  depends_on      = [aws_elasticache_replication_group.redis]
  name            = format("%s-%s-%s", var.environment, var.name, "slack-topic")
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

data "archive_file" "lambdazip" {
  count       = var.slack_notification_enabled ? 1 : 0
  type        = "zip"
  output_path = "${path.module}/lambda/sns_slack.zip"

  source_dir = "${path.module}/lambda/"
}


module "cw_sns_slack" {
  source        = "./lambda"
  count         = var.slack_notification_enabled ? 1 : 0
  name          = format("%s-%s-%s", var.environment, var.name, "sns-slack")
  description   = "notify slack channel on sns topic"
  artifact_file = "${path.module}/lambda/sns_slack.zip"
  handler       = "sns_slack.lambda_handler"
  runtime       = "python3.8"
  memory_size   = 128
  timeout       = 30
  environment = {
    "SLACK_URL"     = var.slack_webhook_url
    "SLACK_CHANNEL" = var.slack_channel
    "SLACK_USER"    = var.slack_username
  }
  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.name, "lambda") },
    local.tags,
  )
}

resource "aws_sns_topic_subscription" "slack-endpoint" {
  count                  = var.slack_notification_enabled ? 1 : 0
  endpoint               = module.cw_sns_slack[0].arn
  protocol               = "lambda"
  endpoint_auto_confirms = true
  topic_arn              = aws_sns_topic.slack_topic[0].arn
}

resource "aws_lambda_permission" "sns_lambda_slack_invoke" {
  count         = var.slack_notification_enabled ? 1 : 0
  statement_id  = "sns_slackAllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.cw_sns_slack[0].arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.slack_topic[0].arn
}
