terraform {
  backend "s3" {
    bucket = "terraform-state-yara-clc16-612646556016-us-east-1-an"
    key    = "terraform/state"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}
