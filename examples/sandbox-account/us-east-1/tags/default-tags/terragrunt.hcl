locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    environment     = "dev"
    team            = "my-awesome-team"
    aws_object      = "lambda"
    application     = "some-sandbox-lambda"
    additional_tags = {
      some-key = "some-value"
    }
  }
}

terraform {
  source = "../../../../../modules/tags"
}

inputs = merge(local.application_tags, {
  name = "sandbox"
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate