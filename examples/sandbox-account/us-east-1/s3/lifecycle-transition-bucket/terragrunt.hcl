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
  name = "transition"

  versioning = {
    status = true
  }

  lifecycle_rule = [
    {
      id = "my-transition-rule"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
        },
        {
          days = 60
          storage_class = "GLACIER"
        }
      ]

      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
      ]
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate