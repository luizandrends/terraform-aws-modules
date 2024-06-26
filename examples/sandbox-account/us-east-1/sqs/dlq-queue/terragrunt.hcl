locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    environment     = "dev"
    team            = "my-awesome-team"
    application     = "some-sandbox-queue"
  }
}

terraform {
  source = "../../../../../modules/sqs"
}

inputs = merge(local.application_tags, {
  name = "dlq"

  create_dlq = true
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate