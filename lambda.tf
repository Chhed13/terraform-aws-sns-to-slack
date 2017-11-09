locals {
  func_name = "slackNotify"
}

data archive_file notify {
  type        = "zip"
  source_file = "${path.module}/${local.func_name}.js"
  output_path = "${local.func_name}_${random_id.notify.hex}.zip"
}

resource aws_lambda_function notify {
  function_name    = "${var.name}_${random_id.notify.hex}"
  handler          = "${local.func_name}.handler"
  role             = "${aws_iam_role.notify.arn}"
  runtime          = "nodejs6.10"
  filename         = "${local.func_name}_${random_id.notify.hex}.zip"
  source_code_hash = "${data.archive_file.notify.output_base64sha256}"
  timeout          = 3
  publish          = true
  environment {
    variables = {
      NOTIFY_CHANNEL = "${var.notify_channel}"
      ERROR_CHANNEL  = "${var.error_channel}"
      WEBHOOK_PATH   = "${var.webhook_path}"
      USERNAME       = "${var.username}"
      ICON_EMOJI     = "${var.icon_emoji}"
    }
  }
}

resource aws_lambda_permission notify {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notify.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.notify.arn}"
}

resource aws_iam_role notify {
  name               = "IamRole${var.name}Lambda_${random_id.notify.hex}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource aws_iam_policy notify {
  name   = "IamPolicy${var.name}Lambda_${random_id.notify.hex}"
  path   = "/"
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource aws_iam_role_policy_attachment notify {
  role       = "${aws_iam_role.notify.name}"
  policy_arn = "${aws_iam_policy.notify.arn}"
}