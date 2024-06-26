locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    environment     = "dev"
    team            = "my-awesome-team"
    application     = "some-sandbox-topic"
  }
}

terraform {
  source = "../../../../../modules/sns"
}

inputs = merge(local.application_tags, {
  name = "fifo"

  fifo_topic = true
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate