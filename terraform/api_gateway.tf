resource "aws_api_gateway_rest_api" "students-api-gateway" {
  name        = "StudentsAPI"
  description = "API to access students api"
  body        = "${data.template_file.students_api_swagger.rendered}"
}

data "template_file" students_api_swagger {
  template = "${file("templates/swagger.yaml")}"

  vars {
    post_lambda_arn = "${aws_lambda_function.post-students-lambda.invoke_arn}"
  }
}

resource "aws_api_gateway_deployment" "students-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.students-api-gateway.id}"
  stage_name  = "test"
}

output "rest_api_id" {
  value = "${aws_api_gateway_rest_api.students-api-gateway.id}"
}

output "url" {
  value = "${aws_api_gateway_deployment.students-api-gateway-deployment.invoke_url}/import"
}
