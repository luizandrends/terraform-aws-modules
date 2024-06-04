locals {
  aws_regions = {
    us-east-2      = "use2",
    us-east-1      = "use1",
    us-west-1      = "usw1",
    us-west-2      = "usw2",
    af-south-1     = "afa1",
    ap-east-1      = "ape1",
    ap-south-1     = "aps1",
    ap-northeast-3 = "apn3",
    ap-northeast-2 = "apn2",
    ap-southeast-1 = "apse1",
    ap-southeast-2 = "apse2",
    ap-northeast-1 = "apn1",
    ca-central-1   = "cac1",
    eu-central-1   = "euc1",
    eu-west-1      = "euw1",
    eu-west-2      = "euw2",
    eu-south-1     = "eus1",
    eu-west-3      = "euw3",
    eu-north-1     = "eun1",
    me-south-1     = "mes1",
    sa-east-1      = "sae1",
  }

  environment_options = {
    dev = "dev"
    hml = "hml"
    prd = "prd"
  }

  aws_region = local.aws_regions[data.aws_region.current.name]

  environment = lower(trimspace(var.environment))
  application = lower(trimspace(var.application))
  team        = lower(trimspace(var.team))
  aws_object  = lower(trimspace(var.aws_object))


  default_name = "aws-${local.aws_object}-${var.name}-${local.aws_region}-${local.environment_options[local.environment]}"

  tags = {
    environment = local.environment_options[local.environment]
    application = local.application
    team        = local.team
    Name        = local.default_name
    managed_by  = "terraform"
  }

  default_tags = merge(local.tags, var.additional_tags)
}
