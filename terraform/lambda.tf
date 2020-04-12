resource "aws_lambda_function" "post-students-lambda" {
  function_name = "students-post"

  # Required S3 bucket
  s3_bucket = "${var.s3_bucket}"
  s3_key    = "v${var.lambda_version}/postStudentsLambda.zip"

  handler = "index.handler"

  runtime     = "nodejs8.10"
  memory_size = 128

  role = "${aws_iam_role.lambda-iam-role.arn}"
}

resource "aws_lambda_permission" "api-gateway-invoke-post-students-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.post-students-lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.students-api-gateway-deployment.execution_arn}/*/*"
}
