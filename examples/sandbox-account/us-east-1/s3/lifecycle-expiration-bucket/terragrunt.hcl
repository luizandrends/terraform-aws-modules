locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    environment     = "dev"
    team            = "my-awesome-team"
    application     = "some-sandbox-bucket"
  }
}

terraform {
  source = "../../../../../modules/s3"
}

inputs = merge(local.application_tags, {
  name = "expiration"

  versioning = {
    status = true
  }

  lifecycle_rule = [
    {
      id = "my-expiration-rule"
      enabled = true

      expiration = {
        days = 90
        expired_object_delete_marker = true
      }
    },
    {
      id = "my-non-current-expiration-rule"
      enabled = true

      noncurrent_version_expiration = {
        days = 60
        newer_noncurrent_versions = 3
      }
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate