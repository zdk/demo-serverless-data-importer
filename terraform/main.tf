provider "aws" {}

variable "lambda_version" {
  default = "1.0.0"
}

variable "s3_bucket" {
  default = "students-importer-bucket"
}
