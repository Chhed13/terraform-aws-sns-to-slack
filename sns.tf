resource random_id notify {
  byte_length = 2
}

resource aws_sns_topic notify {
  name = "${var.name}_${random_id.notify.hex}"
}

resource aws_sns_topic_subscription notify {
  endpoint  = "${aws_lambda_function.notify.arn}"
  protocol  = "lambda"
  topic_arn = "${aws_sns_topic.notify.arn}"
  depends_on = ["aws_sns_topic_policy.notify", "aws_iam_role_policy_attachment.notify"]
}

resource aws_sns_topic_policy notify {
  arn    = "${aws_sns_topic.notify.arn}"
  policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
}

data aws_iam_policy_document sns-topic-policy {
  policy_id = "__default_policy_ID"
  statement {
    sid       = "__default_statement_ID"
    actions   = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]
    condition {
      test     = "StringEquals"
      values   = [
        "${var.account_number}",
      ]
      variable = "AWS:SourceOwner"
    }
    effect    = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = ["${aws_sns_topic.notify.arn}"]

  }
  statement {
    sid       = "__console_pub_0"
    effect    = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions   = [
      "SNS:Publish"
    ]
    resources = ["${aws_sns_topic.notify.arn}"]
  }
  statement {
    sid       = "__console_sub_0"
    effect    = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions   = [
      "SNS:Subscribe",
      "SNS:Receive"
    ]
    resources = ["${aws_sns_topic.notify.arn}"]
  }
}