output "sns_arn" {
  value = "${aws_sns_topic.notify.arn}"
  description = "ARN of SNS topic to post messages"
}

output "lambda_arn" {
  value = "${aws_lambda_function.notify.arn}"
  description = "ARN of lambda that will implement Slack posts"
}

output "lambda_version" {
  value = "${aws_lambda_function.notify.version}"
  description = "Version of lambda. Just for help purposes"
}

output "lambda_publish_status" {
  value = "${aws_lambda_function.notify.publish}"
  description = "Public status of lambda. Just for help purposes"
}