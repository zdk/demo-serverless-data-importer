# ROLES
# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda-iam-role" {
  name = "students_lambda_role"

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

resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name = "dynamodb_lambda_policy"
  role = "${aws_iam_role.lambda-iam-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.students-dynamodb-table.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch-lambda-policy" {
  name   = "cloudwatch-lambda-policy"
  role   = "${aws_iam_role.lambda-iam-role.id}"
  policy = "${data.aws_iam_policy_document.api-gateway-logs-policy-document.json}"
}

data "aws_iam_policy_document" "api-gateway-logs-policy-document" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}
