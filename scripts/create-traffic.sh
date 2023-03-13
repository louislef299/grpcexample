#!/bin/bash

for i in {1..100}; do
    grpcurl -plaintext -proto api/v1/service.proto ping.dev2.mlife:80 proto.ExampleService/Ping
    sleep 1
done