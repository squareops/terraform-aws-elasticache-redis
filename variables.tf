variable "name" {
  description = "The name of the redis cluster"
  default     = ""
  type        = string
}

variable "environment" {
  description = "The name of environment"
  default     = ""
  type        = string
}
variable "family" {
  type        = string
  default     = "redis4.0"
  description = "Redis family"
}
variable "node_type" {
  description = "The instance size of the redis cluster"
  default     = "cache.t3.micro"
  type        = string
}
variable "parameter_group_description" {
  description = "Parameter group"
  default     = null
  type        = string
}

variable "parameter" {
  description = "A list of Redis parameters to apply. It can be different based on mode slection."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "num_cache_nodes" {
  description = "The number of cache nodes"
  default     = 1
  type        = number
}

variable "subnets" {
  description = "The subnets where the redis cluster is deployed"
  default     = []
  type        = list(string)
}

variable "vpc_id" {
  description = "The vpc where we will put the redis cluster"
  default     = ""
  type        = string
}

variable "engine_version" {
  description = "The redis engine version"
  default     = ""
  type        = string
}

variable "port" {
  description = "The redis port"
  default     = 6379
  type        = number
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover "
  default     = false
  type        = bool
}

variable "multi_az_enabled" {
  description = "Enable multi az"
  default     = false
  type        = bool
}


variable "availability_zones" {
  description = "The no. of AZs"
  default     = []
  type        = list(string)
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00"
  default     = "03:00-05:00"
  type        = string
}

variable "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes"
  default     = 7
  type        = number
}

variable "snapshot_arns" {
  description = "(Optional) A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb . This will be used to add data to a fresh new instance."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  default     = []
  type        = list(any)
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to"
  default     = []
  type        = list(any)
}

variable "kms_key_arn" {
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled = true"
  type        = string
  default     = ""
}

variable "at_rest_encryption_enabled" {
  description = "(Optional) Whether to enable encryption at rest"
  default     = true
  type        = bool
}

variable "transit_encryption_enabled" {
  description = "(Optional) Whether to enable encryption in transit"
  default     = true
  type        = bool
}

variable "notification_topic_arn" {
  description = "(Optional) ARN of an SNS topic to send ElastiCache notifications"
  default     = null
  type        = string
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period"
  type        = string
  default     = "fri:08:00-fri:09:00"
}

variable "slow_log_destination" {
  type        = string
  default     = null
  description = "The destination for slow logs(eg. Cloudwatch log-group name or kinesis firehose stream name.)"
}

variable "engine_log_destination" {
  type        = string
  default     = null
  description = "The destination for engine logs(eg. Cloudwatch log-group name or kinesis firehose stream name)"
}

variable "slow_log_destination_type" {
  type        = string
  default     = ""
  description = "The type of destination for slow logs(eg . cloudwatch-logs or kinesis-firehose)"
}

variable "engine_log_destination_type" {
  type        = string
  default     = ""
  description = "The type of destination for engine logs(eg . cloudwatch-logs or kinesis-firehose)"
}
variable "final_snapshot_identifier" {
  type        = string
  description = "The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made."
  default     = null
}

variable "engine_log_format" {
  type        = string
  default     = "json"
  description = "the format for logs eg. json/text"
}

variable "slow_log_format" {
  type        = string
  default     = "json"
  description = "the format for logs eg. json/text"
}

variable "recovery_window_aws_secret" {
  default     = 0
  type        = number
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
}

variable "cloudwatch_metric_alarms_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable CloudWatch metrics alarms"
  default     = false
}

variable "alarm_cpu_threshold_percent" {
  type        = number
  default     = 75
  description = "CPU threshold alarm level"
}

variable "alarm_actions" {
  type        = list(string)
  description = "Alarm action list"
  default     = []
}

variable "ok_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN)"
  default     = []
}

variable "alarm_memory_threshold_bytes" {
  # 10MB
  type        = number
  default     = 10000000
  description = "Ram threshold alarm level in bytes"
}

variable "slack_notification_enabled" {
  type        = bool
  description = "Whether to enable/disable slack notification."
  default     = false
}

variable "slack_webhook_url" {
  description = "The Slack Webhook URL where notifications will be sent."
  default     = ""
  type        = string
}

variable "slack_channel" {
  description = "The Slack channel where notifications will be posted."
  default     = ""
  type        = string
}

variable "slack_username" {
  description = "The username to use when sending notifications to Slack."
  default     = ""
  type        = string
}

variable "cw_sns_topic_arn" {
  description = "The username to use when sending notifications to Slack."
  default     = ""
  type        = string
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Whether to enable/disable creation of a native redis cluster."
  default     = false
}

variable "cluster_mode_replicas_per_node_group" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are between 0 to 5."
  default     = 0
}

variable "cluster_mode_num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group."
  default     = 0
}
