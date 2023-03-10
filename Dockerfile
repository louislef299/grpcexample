# syntax=docker/dockerfile:1

FROM golang:1.20 AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
COPY main.go ./
COPY ./api api

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/server

FROM gcr.io/distroless/static-debian11

COPY --from=build /app/server .

ENV GRPC_GO_LOG_VERBOSITY_LEVEL=99
ENV GRPC_GO_LOG_SEVERITY_LEVEL=info

EXPOSE 50051

ENTRYPOINT ["./server"]