terraform {
  backend "s3" {
    bucket = "production-infra-in"
    key = "eks/terraform.tfstate"
    region = "eu-north-1"
  }
}