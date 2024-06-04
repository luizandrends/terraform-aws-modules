locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    environment     = "dev"
    team            = "my-awesome-team"
    application     = "some-sandbox-lambda"
  }
}

terraform {
  source = "../../../../../modules/s3"
}

inputs = merge(local.application_tags, {
  name = "default"
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate