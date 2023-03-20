locals {
  function_name  = "${var.environment}-${var.function_name}"
  queue_name     = "${var.environment}-${var.queue_name}"
  lambda_runtime = "python3.8"
}

################ SQS QUEUE ########################

resource "aws_sqs_queue" "queue" {
  name = local.queue_name
  tags = var.tags
}

################ SQS QUEUE ########################


################ LAMBDA ########################

data "archive_file" "lambda_zip_inline" {
  type        = "zip"
  output_path = "/tmp/lambda_zip_inline.zip"
  source {
    content  = <<EOF
def lambda_handler(event, context):
    print('Hello, world!')
EOF
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "function" {
  function_name    = local.function_name
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = local.lambda_runtime
  tags             = var.tags
  filename         = data.archive_file.lambda_zip_inline.output_path
  source_code_hash = data.archive_file.lambda_zip_inline.output_base64sha256
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${local.function_name}-role"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_for_lambda.name
}

data "aws_iam_policy_document" "lambda_sqs_policy" {
  statement {
    sid       = "AllowSQSPermissions"
    effect    = "Allow"
    resources = [aws_sqs_queue.queue.arn]

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = [aws_cloudwatch_log_group.lambda_log_group.arn]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  policy = data.aws_iam_policy_document.lambda_sqs_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attach" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.iam_for_lambda.name
}

################ LAMBDA ########################


########### SQS - LAMBDA TRIGGER ###############

resource "aws_sqs_queue_policy" "example_policy" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLambdaToConsumeFromQueue"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_lambda_function.function.arn
          }
        }
      }
    ]
  })
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_mapping" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.function.function_name
  enabled          = true
  batch_size       = 10
  depends_on = [
    aws_iam_role_policy_attachment.lambda_role_policy_attach
  ]
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.queue.arn
}

########### SQS - LAMBDA TRIGGER ###############

