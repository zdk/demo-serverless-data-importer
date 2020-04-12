.PHONY: help terraform

.EXPORT_ALL_VARIABLES:

S3_BUCKET ?= students-importer-bucket
AWS_REGION ?= ap-southeast-1

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := all

all: bucket lambda deploy ## Execute all steps

bucket: ## Create pre-requsite s3 bucket
	@ aws s3api create-bucket --bucket ${S3_BUCKET} --region ${AWS_REGION} --create-bucket-configuration LocationConstraint=${AWS_REGION}

lambda: ## Upload lambda functions code to S3
	@ S3_BUCKET=${S3_BUCKET} ./upload-lambda.sh

deploy: ## Deploy the API stack (API Gateway, Lambda, DynamoDB and IAM)
	@ cd terraform && AWS_REGION=${AWS_REGION} terraform apply -var s3_buckt="${S3_BUCKET}"

url: ## Get API URL
	@ cd terraform && AWS_REGION=${AWS_REGION} terraform output url

test: ## Test the deployed API
	@ ./test.sh $(shell cd terraform && terraform output url)

destroy: ## Destroy the stack
	@ cd terraform && AWS_REGION=${AWS_REGION} terraform destroy
