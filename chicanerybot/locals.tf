locals {
  tags = {
    "Terraform" = "true"
    "Owner"     = "Mikalai Lapko"
  }

  github = {
    token = chomp(file("~/personal/creds/github"))
  }
}
