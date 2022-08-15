data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket = "lapko-tfstate"
    key    = "tfstate"
    region = "us-east-1"
  }
}
