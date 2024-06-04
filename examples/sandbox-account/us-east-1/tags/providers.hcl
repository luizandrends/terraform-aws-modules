generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
provider "aws" {
  region = "us-east-1"
}
  EOF
}