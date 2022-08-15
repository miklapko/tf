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
