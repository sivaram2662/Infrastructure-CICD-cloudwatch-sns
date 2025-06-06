resource "aws_sns_topic" "sns-alerts" {
  name = "Sns-infra-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.sns-alerts.arn
  protocol  = "email"
  endpoint  = "sivaram98853@gmail.com"
}
