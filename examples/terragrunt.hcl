remote_state {
  backend = "s3"
  config = {
    bucket         = "sanbox-development-environment-state"
    key            = "terraform-aws-modules/${path_relative_to_include()}"
    region         = "us-east-1"
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}