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
  name = "policy"

  policy = [
    {
      "sid": "GrantS3Access",
      "effect": "Allow",
      "actions": ["s3:GetObject"],
      "principals": {
        "AWS": ["arn:aws:iam::533267446306:role/s3-test-access"]
      }
      "condition": {
        "StringEquals": {
          "AWS:SourceAccount": ["533267446306"]
        }
      }
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate