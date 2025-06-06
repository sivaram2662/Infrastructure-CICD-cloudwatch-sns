resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ec2/app"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This alarm monitors high CPU"
  alarm_actions       = [aws_sns_topic.sns-alerts.arn]
  dimensions = {
    InstanceId = aws_instance.bastion.id
  }
}
