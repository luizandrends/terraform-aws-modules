data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "default_queue_policy" {
  dynamic "statement" {
    for_each = { for k, v in var.policy : k => v if var.create_queue == true && length(var.policy) > 0 }

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = try(statement.value.resources, [aws_sqs_queue.this[0].arn])

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", null) != null ? statement.value.principals : {}
        content {
          type        = principals.key
          identifiers = principals.value
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", null) != null ? statement.value.condition : {}
        content {
          test     = condition.key
          variable = keys(condition.value)[0]
          values   = values(condition.value)[0]
        }
      }
    }
  }
}
