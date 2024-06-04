<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | A map containing additional tags | `map(any)` | `{}` | no |
| <a name="input_application"></a> [application](#input\_application) | The application that owns the resource | `string` | n/a | yes |
| <a name="input_aws_object"></a> [aws\_object](#input\_aws\_object) | he resource identifier, ex: ec2, s3, rds, etc... | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The resource's environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the resource | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | The squad that owns the resource | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_name"></a> [default\_name](#output\_default\_name) | Represents the resource's parsed name |
| <a name="output_default_tags"></a> [default\_tags](#output\_default\_tags) | Represents all the tags within the project |
<!-- END_TF_DOCS -->