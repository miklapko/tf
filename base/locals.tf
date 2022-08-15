locals {
  tags = {
    "Terraform" = "true"
    "Owner"     = "Mikalai Lapko"
  }

  cloudflare = {
    api_token  = chomp(file("~/personal/creds/cloudflare"))
    account_id = split("\n", file("~/personal/creds/cloudflare_data"))[1]
  }
}
