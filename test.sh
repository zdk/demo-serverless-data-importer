#!/bin/bash

if [ -z "$1" ]; then echo "./test.sh <url>; url is required to run this script"; exit; fi

API_URL=$1
echo "API URL: $API_URL"
RESULT=$(curl -s -X POST $API_URL -H "accept: application/json" --data @tests/data/students.json)
[ $(echo $RESULT | jq '.Records') == "3" ] && echo "ok 1 - Got 3 records" || echo "not ok - Expected 3 records"
[ $(echo $RESULT | jq '.Status') == "200" ] && echo "ok 2 - Got Status code 200" || echo "not ok - Expected Status code 200"

RESULT2=$(curl -s -X POST $API_URL -H "accept: application/json" --data @tests/data/students2.json)
[ $(echo $RESULT2 | jq '.Records') == "4" ] && echo "ok 3 - Got 4 records" || echo "not ok - Expected 4 records"
[ $(echo $RESULT2 | jq '.Status') == "200" ] && echo "ok 4 - Got Status code 200" || echo "not ok - Expected Status code 200"


INVALID_RESULT=$(curl -s -X POST $API_URL -H "accept: application/json" --data @tests/data/student-invalid.json)
[ $(echo $INVALID_RESULT | jq '.Records') == "0" ] && echo "ok 5 - Got 0 records" || echo "not ok - Expected 0 record, got $INVALID_RESULT"
[ $(echo $INVALID_RESULT | jq '.Status') == "400" ] && echo "ok 6 - Got Status code 400" || echo "not ok - Expected Status code 400, got $INVALID_RESULT"

