resource "github_repository" "chicanerybot" {
  name        = "chicanerybot"
  description = "Reddit bot that responds with \"Yup!\" and variants to comments containing \"fuck\" in /r/okbuddychicanery"

  visibility = "public"
}

# Yup

resource "github_repository_file" "this" {
  for_each            = fileset("../../chicanerybot", "*")
  repository          = github_repository.chicanerybot.name
  branch              = "main"
  file                = each.key
  content             = file("../../chicanerybot/${each.key}")
  commit_message      = "Managed by Terraform"
  commit_author       = "Mikalai Lapko"
  commit_email        = "calibrono@gmail.com"
  overwrite_on_create = true
}

resource "github_repository_file" "workflow" {
  repository          = github_repository.chicanerybot.name
  branch              = "main"
  file                = ".github/workflows/main.yml"
  content             = file("../../chicanerybot/.github/workflows/main.yml")
  commit_message      = "Managed by Terraform"
  commit_author       = "Mikalai Lapko"
  commit_email        = "calibrono@gmail.com"
  overwrite_on_create = true
}

resource "github_actions_secret" "aws_access_key_id" {
  repository = github_repository.chicanerybot.name
  secret_name = "AWS_ACCESS_KEY_ID"
  plaintext_value = local.aws[0]
}

resource "github_actions_secret" "aws_secret_access_key" {
  repository = github_repository.chicanerybot.name
  secret_name = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = local.aws[1]
}
