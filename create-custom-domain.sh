#!/bin/bash

DOMAIN_NAME="MY-DOMAIN-NAME"
DOMAIN_ZONE_ID="DOMAIN-ZONE-ID"
CERT_ARN="arn:aws:acm:xxxxxx"
API_ID=$(cd terraform; terraform output rest_api_id)

API_GATEWAY=$(aws apigateway create-domain-name --domain-name $DOMAIN_NAME --regional-certificate-name 'star.zsh.sh' --regional-certificate-arn $CERT_ARN --endpoint-configuration "types=REGIONAL")

aws apigateway create-base-path-mapping --domain-name $DOMAIN_NAME --rest-api-id $API_ID --stage test

_DNSName=$(echo $API_GATEWAY | jq '.regionalDomainName')
_HostedZoneId=$(echo $API_GATEWAY | jq '.regionalHostedZoneId')

_CHANGEDNS=$(cat <<EOT
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "${DOMAIN_NAME}",
        "Type": "A",
        "AliasTarget": {
          "DNSName": ${_DNSName},
          "HostedZoneId": ${_HostedZoneId},
          "EvaluateTargetHealth": false
        }
      }
    }
  ]
}
EOT
)

rm -f changedns.json && echo ${_CHANGEDNS} > changedns.json
aws route53 change-resource-record-sets --hosted-zone-id $DOMAIN_ZONE_ID --change-batch file://changedns.json
