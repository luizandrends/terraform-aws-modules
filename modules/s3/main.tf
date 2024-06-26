locals {
  lifecycle_rules = try(jsondecode(var.lifecycle_rule), var.lifecycle_rule)
}

module "tags" {
  source = "git@github.com:luizandrends/terraform-aws-modules.git//modules/tags?ref=v1.1.0"

  name            = var.name
  environment     = var.environment
  application     = var.application
  team            = var.team
  aws_object      = "s3"
  additional_tags = var.additional_tags
}

resource "random_string" "this" {
  length    = 7
  special   = false
  lower     = true
  min_lower = 7
}

resource "aws_s3_bucket" "this" {
  count = var.create_bucket ? 1 : 0

  bucket = "${module.tags.default_name}-${random_string.this.result}"

  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = module.tags.default_tags
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.create_bucket && length(keys(var.versioning)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  versioning_configuration {
    # Valid values: "Enabled" or "Suspended"
    status = try(var.versioning["enabled"] ? "Enabled" : "Suspended", tobool(var.versioning["status"]) ? "Enabled" : "Suspended", title(lower(var.versioning["status"])))
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.create_bucket && length(local.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  dynamic "rule" {
    for_each = local.lifecycle_rules
    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.enabled ? "Enabled" : "Disabled", tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)))

      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.days, noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.days, noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {
          #          prefix = ""
        }
      }


      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }
}

resource "aws_s3_bucket_policy" "default_bucket_policy" {
  count = var.create_bucket && length(var.policy) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.default_bucket_policy.json
}
