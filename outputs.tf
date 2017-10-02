output "sns_arn" {
  value = "${aws_sns_topic.notify.arn}"
}

output "lambda_arn" {
  value = "${aws_lambda_function.notify.arn}"
}

output "lambda_version" {
  value = "${aws_lambda_function.notify.version}"
}

output "lambda_publish_status" {
  value = "${aws_lambda_function.notify.publish}"
}