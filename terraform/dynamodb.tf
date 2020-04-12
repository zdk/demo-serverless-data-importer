resource "aws_dynamodb_table" "students-dynamodb-table" {
  name           = "Students"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "firstName"
  range_key      = "Date"

  attribute = [
    {
      name = "firstName"
      type = "S"
    },
  ]

  name           = "Students"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "firstName"
  range_key      = "lastName"

  attribute {
    name = "firstName"
    type = "S"
  }

  attribute {
    name = "lastName"
    type = "S"
  }

  attribute {
    name = "age"
    type = "N"
  }

  global_secondary_index {
    name               = "firstNameIndex"
    hash_key           = "firstName"
    range_key          = "age"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["firstName"]
  }

  tags = {
    Name        = "students-table"
    Environment = "test"
  }
}
