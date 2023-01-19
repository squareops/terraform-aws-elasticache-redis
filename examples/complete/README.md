<!-- BEGIN_TF_DOCS -->
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
| <a name="module_redis"></a> [redis](#module\_redis) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elastic-cache-redis-endpoint"></a> [elastic-cache-redis-endpoint](#output\_elastic-cache-redis-endpoint) | Elasticache-redis cluster primary endpoint address |
| <a name="output_id_of_redis_cluster"></a> [id\_of\_redis\_cluster](#output\_id\_of\_redis\_cluster) | ID of the elasticache-redis cluster |
| <a name="output_port_no"></a> [port\_no](#output\_port\_no) | Port number of Redis |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Primary endpoint address of redis |
| <a name="output_redis_subnet_group_name"></a> [redis\_subnet\_group\_name](#output\_redis\_subnet\_group\_name) | Subnet group name of the elasticache-redis cluster |
<!-- END_TF_DOCS -->
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
| <a name="module_redis"></a> [redis](#module\_redis) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elastic-cache-redis-endpoint"></a> [elastic-cache-redis-endpoint](#output\_elastic-cache-redis-endpoint) | Elasticache-redis cluster primary endpoint address |
| <a name="output_id_of_redis_cluster"></a> [id\_of\_redis\_cluster](#output\_id\_of\_redis\_cluster) | ID of the elasticache-redis cluster |
| <a name="output_port_no"></a> [port\_no](#output\_port\_no) | Port number of Redis |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Primary endpoint address of redis |
| <a name="output_redis_subnet_group_name"></a> [redis\_subnet\_group\_name](#output\_redis\_subnet\_group\_name) | Subnet group name of the elasticache-redis cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Policy required is:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteTags",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "elasticache:AddTagsToResource",
                "elasticache:CreateCacheParameterGroup",
                "elasticache:CreateCacheSubnetGroup",
                "elasticache:CreateReplicationGroup",
                "elasticache:DeleteCacheParameterGroup",
                "elasticache:DeleteCacheSubnetGroup",
                "elasticache:DeleteReplicationGroup",
                "elasticache:DescribeCacheParameterGroups",
                "elasticache:DescribeCacheParameters",
                "elasticache:DescribeCacheSubnetGroups",
                "elasticache:DescribeReplicationGroups",
                "elasticache:ListTagsForResource",
                "elasticache:ModifyCacheParameterGroup",
                "elasticache:ModifyCacheSubnetGroup",
                "elasticache:ModifyReplicationGroup",
                "elasticache:RemoveTagsFromResource"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:CreateSecret",
                "secretsmanager:DeleteSecret",
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:TagResource",
                "secretsmanager:UntagResource"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->
