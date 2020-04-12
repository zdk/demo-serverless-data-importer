const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient({
    region: 'ap-southeast-1'
})

exports.handler = function(event, context, callback) {
    console.log('Processing event body: ' + JSON.stringify(event.body, null, 2))

    let data = JSON.parse(event.body)
    let students = [];

    if (data.hasOwnProperty('Students')) {
        data['Students'].forEach(student => {
            students.push({
                PutRequest: {
                    Item: {
                        firstName: student.firstName,
                        lastName: student.lastName,
                        age: student.age,
                        email: student.email
                    }
                }
            });
        });
    }

    let params = {
        RequestItems: {
            'Students': students
        }
    };

    console.log('Storing students in database' + JSON.stringify(students))

    docClient.batchWrite(params, function(err, data) {
        let resp_body = {
            "Records": 0,
            "Status": 400
        }
        if (err) {
            callback(null, {
                "statusCode": resp_body["Status"],
                "headers": {
                    "Content-Type": "application/json"
                },
                "body": JSON.stringify(resp_body)
            })
        } else {
            resp_body["Records"] = students.length;
            resp_body["Status"] = 200;
            callback(null, {
                "statusCode": resp_body["Status"],
                "headers": {
                    "Content-Type": "application/json"
                },
                "body": JSON.stringify(resp_body)
            })
        }
    });
}
