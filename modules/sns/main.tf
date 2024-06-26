locals {
  name = var.fifo_topic ? "${module.tags.default_name}.fifo" : "${module.tags.default_name}"
}

module "tags" {
  source = "git@github.com:luizandrends/terraform-aws-modules.git//modules/tags?ref=v1.1.0"

  name            = var.name
  environment     = var.environment
  application     = var.application
  team            = var.team
  aws_object      = "sns"
  additional_tags = var.additional_tags
}

resource "aws_sns_topic" "this" {
  count = var.create_topic ? 1 : 0

  name = local.name

  content_based_deduplication = var.content_based_deduplication
  delivery_policy             = var.delivery_policy
  fifo_topic                  = var.fifo_topic
  tracing_config              = var.tracing_config

  tags = module.tags.default_tags
}

resource "aws_sns_topic_policy" "default_topic_policy" {
  count = length(var.policy) > 0 && var.create_topic == true ? 1 : 0

  arn = aws_sns_topic.this[0].arn

  policy = data.aws_iam_policy_document.default_topic_policy.json
}
