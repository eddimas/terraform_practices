resource "aws_lambda_function" "check_ec2_tags" {
  function_name    = "check_ec2_tags"
  runtime          = "python3.8"
  handler          = "lambda_function.lambda_handler"
  role             = aws_iam_role.check_ec2_tags_role.arn
  source_code_hash = data.archive_file.check_ec2_tags_zip.output_base64sha256
  filename         = "${path.module}/python/check_ec2_tags.zip"
  timeout          = 60
  memory_size      = 128
}

resource "aws_lambda_function_event_invoke_config" "check_ec2_tags" {
  function_name = aws_lambda_function.check_ec2_tags.function_name
  destination_config {
    on_success {
      destination = aws_sns_topic.aws_ec2_tags.arn
    }
    on_failure {
      destination = aws_sns_topic.aws_ec2_tags.arn
    }
  }
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_iam_role" "check_ec2_tags_role" {
  name               = "check_ec2_tags_role"
  assume_role_policy = file(var.my_iam_role)
}

resource "aws_iam_policy" "publish_sns_policy" {
  name        = "publish_sns_policy"
  description = "Policy for publish_sns"
  policy      = file(var.publish_sns_policy)
}

resource "aws_iam_role_policy_attachment" "my_role_policy_attachment2" {
  role       = aws_iam_role.check_ec2_tags_role.name
  policy_arn = aws_iam_policy.publish_sns_policy.arn
}

data "aws_iam_policy_document" "check_ec2_tags_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeTags"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ses:SendEmail"]
    resources = ["*"]
  }
}

data "archive_file" "check_ec2_tags_zip" {
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/check_ec2_tags.zip"
  type        = "zip"
}

resource "aws_cloudwatch_event_target" "check_ec2_tags_target" {
  arn       = aws_lambda_function.check_ec2_tags.arn
  rule      = aws_cloudwatch_event_rule.check_ec2_tags_rule.name
  target_id = "check_ec2_tags"
}

resource "aws_lambda_permission" "check_ec2_tags_permission" {
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = aws_lambda_function.check_ec2_tags.function_name
}

resource "aws_cloudwatch_event_rule" "check_ec2_tags_rule" {
  name                = "check_ec2_tags_rule"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.check_ec2_tags_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.aws_ec2_tags.arn
}

resource "aws_sns_topic" "aws_ec2_tags" {
  name = "aws-ec2-tags"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.aws_ec2_tags.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.aws_ec2_tags.arn]
  }
}