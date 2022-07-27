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

resource "aws_s3_object" "certificate" {
  for_each = fileset("${path.root}/files/mikalailapkocerts/", "*")

  bucket = aws_s3_bucket.mikalailapkocerts.bucket
  key    = each.value
  source = "${path.root}/files/mikalailapkocerts/${each.value}"
  etag   = filemd5("${path.root}/files/mikalailapkocerts/${each.value}")
}
