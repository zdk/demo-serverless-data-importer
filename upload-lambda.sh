#!/usr/bin/env bash

# Zip the lambda functions
cd post-lambda-fn
zip -r ../postStudentsLambda.zip index.js
cd ..

aws s3 cp postStudentsLambda.zip s3://$S3_BUCKET/v1.0.0/postStudentsLambda.zip
