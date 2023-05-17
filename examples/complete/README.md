<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_redis"></a> [redis](#module\_redis) | git@github.com:sq-ia/terraform-aws-elasticache-redis.git | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_token_password"></a> [auth\_token\_password](#output\_auth\_token\_password) | Elasticache-redis auth token password(this password may be old, because Terraform doesn't track it after initial creation) |
| <a name="output_elastic_cache_redis_endpoint"></a> [elastic\_cache\_redis\_endpoint](#output\_elastic\_cache\_redis\_endpoint) | Elasticache-redis cluster primary endpoint address |
| <a name="output_elastic_cache_redis_security_group"></a> [elastic\_cache\_redis\_security\_group](#output\_elastic\_cache\_redis\_security\_group) | The security group ID of the cluster |
| <a name="output_id_of_redis_cluster"></a> [id\_of\_redis\_cluster](#output\_id\_of\_redis\_cluster) | ID of the elasticache-redis cluster |
| <a name="output_port_no"></a> [port\_no](#output\_port\_no) | Port number of Redis |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Primary endpoint address of redis |
| <a name="output_redis_subnet_group_name"></a> [redis\_subnet\_group\_name](#output\_redis\_subnet\_group\_name) | Subnet group name of the elasticache-redis cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
