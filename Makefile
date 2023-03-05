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
	docker build -t ping-grpc-server .

clean: 
	rm server