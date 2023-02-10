## Redis
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
We publish several terraform modules.
<br>
Terraform Module to create Redis on AWS Cloud.

## Uses Example

```hcl

module "redis" {
  source = "gitlab.com/sq-ia/aws/redis.git"  
  environment = "production"
  name        = "SKAF"
  engine_version  = "6.x"
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
  vpc_id                     = "vpc-06e37f0786b7eskaf"
  subnets                    = ["subnet-0bfc23c64ea3eskaf","subnet-0140024df275bskaf"]
  allowed_cidr_blocks        = []
  allowed_security_groups    = [sg-0132a41b5cd18skaf]
  maintenance_window         = "sun:09:00-sun:10:00"
  snapshot_window            = "07:00-08:00"
  kms_key_arn = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
}

```

## Important Note
1. This module creates RDS security group.
2. By default, the variable `create_random_password` is set to true. Therefore, even if the user provides a password, it will not be read. The `create_random_password` variable should be set to false and the `password` variable should have a non-null value to be read and used.

## Security & Compliance [<img src="	https://prowler.pro/wp-content/themes/prowler-pro/assets/img/logo.svg" width="250" align="right" />](https://prowler.pro/)

Security scanning is graciously provided by Prowler. Proowler is the leading fully hosted, cloud-native solution providing continuous cluster security and compliance.

| Benchmark | Description |
|--------|---------------|
| Ensure that encryption is enabled for RDS instances | Enabled for RDS created using this module. |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.23 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group_redis"></a> [security\_group\_redis](#module\_security\_group\_redis) | terraform-aws-modules/security-group/aws | 4.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_secretsmanager_secret.secret_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_security_group_rule.cidr_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.default_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of CIDR blocks which are allowed to access the database | `list(any)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | A list of Security Group ID's to allow access to | `list(any)` | `[]` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | (Optional) Whether to enable encryption at rest | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Enable automatic failover | `bool` | `false` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The list of AZs | `list(string)` | `[]` | no |
| <a name="input_engine_log_destination"></a> [engine\_log\_destination](#input\_engine\_log\_destination) | The destination for engine logs(eg. Cloudwatch log-group name or kinesis firehose stream name) | `string` | `null` | no |
| <a name="input_engine_log_destination_type"></a> [engine\_log\_destination\_type](#input\_engine\_log\_destination\_type) | The type of destination for engine logs(eg . cloudwatch-logs or kinesis-firehose) | `string` | `""` | no |
| <a name="input_engine_log_format"></a> [engine\_log\_format](#input\_engine\_log\_format) | the format for logs eg. json/text | `string` | `"json"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The redis engine version | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of environment | `string` | `""` | no |
| <a name="input_family"></a> [family](#input\_family) | Redis family | `string` | `"redis4.0"` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at\_rest\_encryption\_enabled = true | `string` | `""` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period | `string` | `"fri:08:00-fri:09:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Enable multi az | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the redis cluster | `string` | `""` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The instance size of the redis cluster | `string` | `"cache.t3.micro"` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | (Optional) ARN of an SNS topic to send ElastiCache notifications | `string` | `null` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | The number of cache nodes | `number` | `1` | no |
| <a name="input_parameter_group_description"></a> [parameter\_group\_description](#input\_parameter\_group\_description) | Parameter group | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | The redis port | `number` | `6379` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `0` | no |
| <a name="input_slow_log_destination"></a> [slow\_log\_destination](#input\_slow\_log\_destination) | The destination for slow logs(eg. Cloudwatch log-group name or kinesis firehose stream name.) | `string` | `null` | no |
| <a name="input_slow_log_destination_type"></a> [slow\_log\_destination\_type](#input\_slow\_log\_destination\_type) | The type of destination for slow logs(eg . cloudwatch-logs or kinesis-firehose) | `string` | `""` | no |
| <a name="input_slow_log_format"></a> [slow\_log\_format](#input\_slow\_log\_format) | the format for logs eg. json/text | `string` | `"json"` | no |
| <a name="input_snapshot_arns"></a> [snapshot\_arns](#input\_snapshot\_arns) | (Optional) A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my\_bucket/snapshot1.rdb . This will be used to add data to a fresh new instance. | `list(string)` | `[]` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.* cache nodes | `number` | `0` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum maintenance window is a 60 minute period. Example: 05:00-09:00 | `string` | `"03:00-05:00"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets where the redis cluster is deployed | `list(string)` | `[]` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | (Optional) Whether to enable encryption in transit | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc where we will put the redis cluster | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_token_password"></a> [auth\_token\_password](#output\_auth\_token\_password) | Elasticache-redis auth token password(this password may be old, because Terraform doesn't track it after initial creation) |
| <a name="output_elastic_cache_redis_cluster_id"></a> [elastic\_cache\_redis\_cluster\_id](#output\_elastic\_cache\_redis\_cluster\_id) | ID of the elasticache-redis cluster |
| <a name="output_elastic_cache_redis_endpoint"></a> [elastic\_cache\_redis\_endpoint](#output\_elastic\_cache\_redis\_endpoint) | Elasticache-redis cluster primary endpoint address |
| <a name="output_elastic_cache_redis_port"></a> [elastic\_cache\_redis\_port](#output\_elastic\_cache\_redis\_port) | Port number of Redis |
| <a name="output_elastic_cache_redis_primary_endpoint_address"></a> [elastic\_cache\_redis\_primary\_endpoint\_address](#output\_elastic\_cache\_redis\_primary\_endpoint\_address) | Primary endpoint address of redis |
| <a name="output_elastic_cache_redis_security_group"></a> [elastic\_cache\_redis\_security\_group](#output\_elastic\_cache\_redis\_security\_group) | The security group ID of the cluster |
| <a name="output_elastic_cache_redis_subnet_group_name"></a> [elastic\_cache\_redis\_subnet\_group\_name](#output\_elastic\_cache\_redis\_subnet\_group\_name) | Subnet group name of the elasticache\_redis cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribution & Issue Reporting

To contribute to a project, you can typically:

  1. Find the repository on a platform like GitHub
  2. Fork the repository to your own account
  3. Make changes to the code
  4. Submit a pull request to the original repository

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-aws-vpc/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.
  4. Contributing to the project can be a great way to get involved and get help. The maintainers and other contributors may be more likely to help you if you're already making contributions to the project.

## Our Other Projects

We have a number of other projects that you might be interested in:

  1. [terraform-aws-vpc](https://github.com/squareops/terraform-aws-vpc): Terraform module to create Networking resources for workload deployment on AWS Cloud.

  2. [terraform-aws-keypair](https://github.com/squareops/terraform-aws-keypair): Terraform module which creates EC2 key pair on AWS. The private key will be stored on SSM.

     Follow Us:

     To stay updated on our projects and future release, follow us on
     [GitHub](https://github.com/squareops/),
     [LinkedIn](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/)

     By joining our both the [email](https://github.com/squareops) and [Slack community](https://github.com/squareops), you can benefit from the different ways in which we provide support. You can receive timely notifications and updates through email and engage in real-time conversations and discussions with other members through Slack. This combination of resources can help you stay informed, get help when you need it, and contribute to the project in a meaningful way.  

## Security, Validation and pull-requests
we have offered here high standard, quality code. Hence we are using several [pre-commit hooks](.pre-commit-config.yaml) and [GitHub Actions](https://gitlab.com/sq-ia/aws/eks/-/tree/v1.0.0#security-validation-and-pull-requests) as a workflow. So here we will create pull-requests to any branch and validate the request automatically using pre-commit tool.

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the GitHub repository.

  2. Click the "Star" [button](https://github.com/squareops/terraform-aws-vpc): On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 4 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

You can find more information about our company on this [squareops.com](https://squareops.com/), follow us on [linkdin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).

