locals {
  name           = var.fifo_queue ? "${module.tags.default_name}.fifo" : "${module.tags.default_name}"
  dlq_name       = var.fifo_queue ? "${module.tags.default_name}-dead.fifo" : "${module.tags.default_name}-dead"
  redrive_policy = var.create_dlq ? "{\"deadLetterTargetArn\": \"arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.dlq_name}\",\"maxReceiveCount\": ${var.max_receive_count}}" : var.redrive_policy != "" ? "{\"deadLetterTargetArn\": \"${var.redrive_policy}\",\"maxReceiveCount\": ${var.max_receive_count}}" : ""
}

module "tags" {
  source = "git@github.com:luizandrends/terraform-aws-modules.git//modules/tags?ref=v1.1.0"

  name            = var.name
  environment     = var.environment
  application     = var.application
  team            = var.team
  aws_object      = "sqs"
  additional_tags = var.additional_tags
}

resource "aws_sqs_queue" "this" {
  count = var.create_queue ? 1 : 0

  content_based_deduplication       = var.content_based_deduplication
  deduplication_scope               = var.deduplication_scope
  delay_seconds                     = var.delay_seconds
  fifo_queue                        = var.fifo_queue
  fifo_throughput_limit             = var.fifo_throughput_limit
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  kms_master_key_id                 = var.kms_master_key_id
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  name                              = local.name
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  redrive_policy                    = local.redrive_policy

  tags = module.tags.default_tags

  depends_on = [aws_sqs_queue.dead_letter_queue]
}

resource "aws_sqs_queue" "dead_letter_queue" {
  count = var.create_queue && var.create_dlq ? 1 : 0

  name                              = local.dlq_name
  content_based_deduplication       = try(coalesce(var.dlq_content_based_deduplication, var.content_based_deduplication), null)
  deduplication_scope               = try(coalesce(var.dlq_deduplication_scope, var.deduplication_scope), null)
  delay_seconds                     = try(coalesce(var.dlq_delay_seconds, var.delay_seconds), null)
  fifo_queue                        = var.fifo_queue
  fifo_throughput_limit             = var.fifo_throughput_limit
  kms_data_key_reuse_period_seconds = try(coalesce(var.dlq_kms_data_key_reuse_period_seconds, var.kms_data_key_reuse_period_seconds), null)
  max_message_size                  = var.max_message_size
  message_retention_seconds         = try(coalesce(var.dlq_message_retention_seconds, var.message_retention_seconds), null)
  receive_wait_time_seconds         = try(coalesce(var.dlq_receive_wait_time_seconds, var.receive_wait_time_seconds), null)
  visibility_timeout_seconds        = try(coalesce(var.dlq_visibility_timeout_seconds, var.visibility_timeout_seconds), null)

  tags = module.tags.default_tags
}

resource "aws_sns_topic_subscription" "sns_topic_subscriber" {
  for_each = { for k, v in var.subscriptions : k => v if length(var.subscriptions) > 0 && var.create_queue == true }

  topic_arn            = each.value.topic_arn
  protocol             = "sqs"
  endpoint             = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.name}"
  raw_message_delivery = try(each.value.raw_message_delivery, false)
  filter_policy        = try(jsonencode(each.value.filter_policy), null)

  depends_on = [
    aws_sqs_queue.this
  ]
}

resource "aws_sqs_queue_policy" "default_queue_policy" {
  count = length(var.policy) > 0 && var.create_queue == true ? 1 : 0

  queue_url = "https://sqs.${data.aws_region.current.name}.amazonaws.com/${data.aws_caller_identity.current.account_id}/${local.name}"

  policy = data.aws_iam_policy_document.default_queue_policy.json

  depends_on = [aws_sqs_queue.this]
}
