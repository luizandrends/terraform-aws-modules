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
  name = "subscription"

  subscriptions = {
    "my-sub" = {
      topic_arn = "topic-arn-here"
      filter_policy = {
        "MyFilter1": ["value1"],
        "MyFilter2": ["value2"]
      }
      raw_message_delivery = true
    }
    "another-sub" = {
      topic_arn = "topic-arn-here"
    }
  }
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate