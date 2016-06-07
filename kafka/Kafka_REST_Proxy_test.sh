#!/bin/bash
###http://docs.confluent.io/1.0/kafka-rest/docs/intro.html
##本脚本解决的需求是：Kafka http-proxy 的测试


# Get a list of topics
$ curl "http://localhost:8082/topics"
  [{"name":"test","num_partitions":3},{"name":"test2","num_partitions":1}]

# Get info about one partition
$ curl "http://localhost:8082/topics/test"
  {"name":"test","num_partitions":3}

# Produce a message using binary embedded data with value "Kafka" to the topic test
$ curl -X POST -H "Content-Type: application/vnd.kafka.binary.v1+json" \
      --data '{"records":[{"value":"S2Fma2E="}]}' "http://localhost:8082/topics/test"
  {"offsets":[{"partition":0,"offset":0,"error_code":null,"error":null}],"key_schema_id":null,"value_schema_id":null}

# Produce a message using Avro embedded data, including the schema which will
# be registered with the schema registry and used to validate and serialize
# before storing the data in Kafka
$ curl -X POST -H "Content-Type: application/vnd.kafka.avro.v1+json" \
      --data '{"value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"value": {"name": "testUser"}}]}' \
      "http://localhost:8082/topics/avrotest"
  {"offsets":[{"partition":0,"offset":0,"error_code":null,"error":null}],"key_schema_id":null,"value_schema_id":21}

# Create a consumer for binary data, starting at the beginning of the topic's
# log. Then consume some data from a topic.
$ curl -X POST -H "Content-Type: application/vnd.kafka.v1+json" \
      --data '{"id": "my_instance", "format": "binary", "auto.offset.reset": "smallest"}' \
      http://localhost:8082/consumers/my_binary_consumer
  {"instance_id":"my_instance","base_uri":"http://localhost:8082/consumers/my_binary_consumer/instances/my_instance"}
$ curl -X GET -H "Accept: application/vnd.kafka.binary.v1+json" \
      http://localhost:8082/consumers/my_binary_consumer/instances/my_instance/topics/test
  [{"key":null,"value":"S2Fma2E=","partition":0,"offset":0}]

# Create a consumer for Avro data, starting at the beginning of the topic's
# log. Then consume some data from a topic, which is decoded, translated to
# JSON, and included in the response. The schema used for deserialization is
# fetched automatically from the schema registry.
$ curl -X POST -H "Content-Type: application/vnd.kafka.v1+json" \
      --data '{"id": "my_instance", "format": "avro", "auto.offset.reset": "smallest"}' \
      http://localhost:8082/consumers/my_avro_consumer
  {"instance_id":"my_instance","base_uri":"http://localhost:8082/consumers/my_avro_consumer/instances/my_instance"}
$ curl -X GET -H "Accept: application/vnd.kafka.avro.v1+json" \
      http://localhost:8082/consumers/my_avro_consumer/instances/my_instance/topics/avrotest
  [{"key":null,"value":{"name":"testUser"},"partition":0,"offset":0}]