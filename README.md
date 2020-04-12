# Serverless Data Import System Demo

Demo on building a simple serverless data import system.
This import system take in the data structure as given, but should be able to import any number of students with the properties as given. 

# Demo

[![asciicast](https://asciinema.org/a/f1TwoMiQGeltswXdHKAqnHlxG.svg)](https://asciinema.org/a/f1TwoMiQGeltswXdHKAqnHlxG)

The project does following:

* Create the Infrastructure as Code using Terraform.
* Store AWS Lambda code on AWS S3
* Automate the deployment
* AWS API Gateway that accepts only application/json in its endpoint “/import”
* AWS Lambda NodeJS function that receives the JSON object and calls the DynamoDB service to store the data and return records written successfully.
* Return a response (success: 200 with records written, or failure 400 client error) to the client.

Http request body data structure 
```
{
   "Students":[
      {
         "firstName":"John",
         "lastName":"Doe",
         "age":21,
         "email":"john@myuni.com"
      },
      {
         "firstName":"David",
         "lastName":"Lee",
         "age":23,
         "email":"david@youruni.com"
      },
      {
         "firstName":"Tom",
         "lastName":"Hanks",
         "age":25,
         "email":"tom@cambridge.com"
      }
   ]
}
```

Http response data structure
```
{
   "Records":3,
   "Status":200
}
```

## Prerequisites

* AWS CLI and AWS API access credentials.
* S3 bucket to store lambda functions code.
* Terraform.
* Installed `jq` and `curl`.


### Create S3 bucket

Specify S3 bucket name and aws region in `Makefile`

Default values are the following:

```
S3_BUCKET ?= students-importer-bucket
AWS_REGION ?= ap-southeast-1
```

Then, run `make bucket` to create the defined s3 bucket.

### Upload lamba functions code to S3

```
make lambda
```

### Deploy using terraform

```
make deploy
```

### Test importing students

```
make test
```

### Destroy using terraform

```
make destroy
```

### Create Custom Domain

Update the following values in file `./create-custom-domain.sh` to match your domain info:

```
DOMAIN_NAME="api.yourdomain.com"
DOMAIN_ZONE_ID="Z55THXXXXXX"
CERT_ARN="arn:aws:acm:ap-southeast-1:1234:certificate/xxxx-xxx-xxx"
API_ID=12345
```

And, run:

```
./create-custom-domain.sh
```

### Get Help

```
make help
```
