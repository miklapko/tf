resource "aws_s3_bucket" "mikalailapkocerts" {
  bucket = "mikalailapkocerts"

  tags = {
    Name = "mikalailapkocerts"
  }
}

resource "aws_s3_bucket_policy" "mikalailapkocerts" {
  bucket = aws_s3_bucket.mikalailapkocerts.id
  policy = templatefile("${path.root}/files/allow_all_access_s3_policy.tpl", { bucketname = aws_s3_bucket.mikalailapkocerts.bucket })
}
