terraform {
  backend "s3" {
    bucket                  = "lapko-tfstate"
    key                     = "tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "~/personal/creds/aws"
    profile                 = "personal"
  }

  required_version = ">= 1.2.5"

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/personal/creds/aws"]
  profile                  = "personal"

  default_tags {
    tags = {
      Terraform = "true"
      Owner     = "Mikalai Lapko"
    }
  }
}

provider "cloudflare" {
  api_token = local.cloudflare["api_token"]
}

resource "aws_s3_bucket" "lapko_tfstate" {
  bucket = "lapko-tfstate"

  tags = {
    Name = "lapko-tfstate"
  }
}
