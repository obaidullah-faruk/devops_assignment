terraform {
  backend "s3" {
    bucket       = "goldkinen-devops-assignment-terraform-state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
