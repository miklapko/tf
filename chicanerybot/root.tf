terraform {
  backend "s3" {
    bucket                  = "lapko-tfstate"
    key                     = "tfstate-chicanerybot"
    region                  = "us-east-1"
    shared_credentials_file = "~/personal/creds/aws"
    profile                 = "personal"
    encrypt                 = true
    dynamodb_table          = "lapko-tfstate-lock"
  }

  required_version = ">= 1.1.7"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
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

provider "github" {
  token = local.github["token"]
}
