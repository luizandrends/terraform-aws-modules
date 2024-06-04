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
