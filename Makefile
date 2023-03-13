.DEFAULT_GOAL := default

.PHONY: clean server client

SRC_DIR = "api/v1"

default:
	go build -o server
	
proto:
	protoc --go_out=. --go_opt=paths=source_relative \
	--go-grpc_out=. --go-grpc_opt=paths=source_relative \
	 $(SRC_DIR)/service.proto

container:
	docker build -t docker.io/ping-grpc-server:v0.0.1 .

clean: 
	rm server

request:
	grpcurl -plaintext -proto api/v1/service.proto ping.dev2.mlife:443 proto.ExampleService/Ping

requests:
	./scripts/create-traffic.sh