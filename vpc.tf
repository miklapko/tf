resource "aws_vpc" "personal" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Personal"
  }
}
