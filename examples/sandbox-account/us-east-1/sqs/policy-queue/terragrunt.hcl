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
  name = "policy"

  policy = [
    {
      "sid": "GrantS3Access",
      "effect": "Allow",
      "actions": ["sqs:SendMessage"],
      "principals": {
        "Service": ["s3.amazonaws.com"]
      }
      "condition": {
        "ArnLike": {
          "AWS:SourceArn": ["arn:aws:s3:::aws-s3-default-use1-dev-unvqvux"]
        }
      }
    },
    {
      "sid": "GrantAnotherS3Access",
      "effect": "Allow",
      "actions": ["sqs:SendMessage"],
      "resources": ["arn:aws:s3:::aws-s3-default-use1-dev-unvqvux"]
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate