resource "cloudflare_zone" "dontevenaskme" {
  zone       = "dontevenask.me"
  account_id = local.cloudflare["account_id"]
}

resource "cloudflare_record" "dontevenaskme" {
  zone_id         = cloudflare_zone.dontevenaskme.id
  name            = "dontevenask.me"
  value           = aws_cloudfront_distribution.dontevenaskme.domain_name
  type            = "CNAME"
  proxied         = true
  allow_overwrite = false
}

resource "cloudflare_record" "wwwdontevenaskme" {
  zone_id         = cloudflare_zone.dontevenaskme.id
  name            = "www"
  value           = aws_cloudfront_distribution.dontevenaskme.domain_name
  type            = "CNAME"
  proxied         = true
  allow_overwrite = false
}

resource "cloudflare_record" "domainconnectdontevenaskme" {
  zone_id         = cloudflare_zone.dontevenaskme.id
  name            = "_domainconnect"
  value           = "_domainconnect.gd.domaincontrol.com"
  type            = "CNAME"
  proxied         = true
  allow_overwrite = false
}

resource "aws_s3_bucket" "dontevenaskme" {
  bucket = "dontevenask.me"

  tags = {
    Name = "dontevenask.me"
  }
}

resource "aws_s3_bucket_policy" "dontevenaskme" {
  bucket = aws_s3_bucket.dontevenaskme.id
  policy = templatefile("${path.root}/files/cloudfront_s3_policy.tpl", { bucketname = aws_s3_bucket.dontevenaskme.bucket, identity = aws_cloudfront_origin_access_identity.dontevenaskme.id })
}

resource "aws_s3_object" "dontevenaskme" {
  for_each = fileset("${path.root}/files/dontevenask.me/", "*")

  bucket = aws_s3_bucket.dontevenaskme.bucket
  key    = each.value
  source = "${path.root}/files/dontevenask.me/${each.value}"
  etag   = filemd5("${path.root}/files/dontevenask.me/${each.value}")
}

resource "aws_acm_certificate" "dontevenaskme" {
  domain_name       = "dontevenask.me"
  validation_method = "DNS"

  tags = {
    "Name" = "dontevenask.me"
  }
}

resource "aws_cloudfront_distribution" "dontevenaskme" {
  origin {
    # Fuck you AWS fix bucket_regional_domain_name!
    domain_name = "${aws_s3_bucket.dontevenaskme.bucket}.s3.${aws_s3_bucket.dontevenaskme.region}.amazonaws.com"
    origin_id   = "${aws_s3_bucket.dontevenaskme.bucket}.s3.${aws_s3_bucket.dontevenaskme.region}.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.dontevenaskme.cloudfront_access_identity_path
    }
  }

  aliases = [
    "dontevenask.me",
    "www.dontevenask.me",
  ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.dontevenaskme.bucket}.s3.${aws_s3_bucket.dontevenaskme.region}.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  price_class = "PriceClass_100"

  tags = {
    Name = "dontevenask.me"
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.dontevenaskme.arn
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

resource "aws_cloudfront_origin_access_identity" "dontevenaskme" {}
