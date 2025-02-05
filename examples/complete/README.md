## Redis Example
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>

This example will be very useful for users who are new to a module and want to quickly learn how to use it. By reviewing the examples, users can gain a better understanding of how the module works, what features it supports, and how to customize it to their specific needs.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.63 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | squareops/vpc/aws | 3.3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_token_password"></a> [auth\_token\_password](#output\_auth\_token\_password) | Elasticache-redis auth token password(this password may be old, because Terraform doesn't track it after initial creation) |
| <a name="output_elastic_cache_redis_reader_endpoint"></a> [elastic\_cache\_redis\_reader\_endpoint](#output\_elastic\_cache\_redis\_reader\_endpoint) | Elasticache-redis cluster primary endpoint address |
| <a name="output_elastic_cache_redis_security_group"></a> [elastic\_cache\_redis\_security\_group](#output\_elastic\_cache\_redis\_security\_group) | The security group ID of the cluster |
| <a name="output_id_of_redis_cluster"></a> [id\_of\_redis\_cluster](#output\_id\_of\_redis\_cluster) | ID of the elasticache-redis cluster |
| <a name="output_port_no"></a> [port\_no](#output\_port\_no) | Port number of Redis |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Primary endpoint address of redis |
| <a name="output_redis_member_clusters"></a> [redis\_member\_clusters](#output\_redis\_member\_clusters) | Subnet group name of the elasticache-redis cluster |
| <a name="output_redis_subnet_group_name"></a> [redis\_subnet\_group\_name](#output\_redis\_subnet\_group\_name) | Subnet group name of the elasticache-redis cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
