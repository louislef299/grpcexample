package main

import (
	"context"
	"log"
	"net"
	"os"
	"os/signal"

	pb "github.com/louislef299/grpcexample/api/v1"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/emptypb"
)

const port = ":50051"

type server struct {
	pb.UnimplementedExampleServiceServer
}

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterExampleServiceServer(s, &server{})

	go func() { // Graceful shutdown
		<-ctx.Done()
		log.Println("context canceled, exiting")
		s.GracefulStop()
	}()

	log.Printf("Starting gRPC listener on port " + port)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

// grpcurl -plaintext -proto api/v1/service.proto localhost:50051 proto.ExampleService/Ping
func (s *server) Ping(ctx context.Context, in *emptypb.Empty) (*pb.PingResponse, error) {
	return &pb.PingResponse{
		Msg: "Pong",
	}, nil
}

// grpcurl -plaintext -proto api/v1/service.proto https://127.0.0.1:54164/api/v1/namespaces/default/services/ping-grpc-server:80 proto.ExampleService/Ping
