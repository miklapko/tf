resource "aws_dynamodb_table" "lapko_tfstate_lock" {
  name           = "lapko-tfstate-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "lapko_tfstate" {
  bucket = "lapko-tfstate"

  tags = {
    Name = "lapko-tfstate"
  }
}

resource "aws_cloudwatch_metric_alarm" "account_billing_alarm" {
  alarm_name          = "Billing alarm"
  alarm_description   = "Spending huh?"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "28800"
  statistic           = "Maximum"
  threshold           = 20
  alarm_actions       = [aws_sns_topic.sns_alert_topic.arn]

  dimensions = {
    Currency      = "USD"
    LinkedAccount = data.aws_caller_identity.current.account_id
  }
}

resource "aws_sns_topic" "sns_alert_topic" {
  name  = "billing-alarm-notification"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.sns_alert_topic.arn
  protocol  = "email"
  endpoint  = "calibrono@gmail.com"
}
