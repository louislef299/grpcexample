# syntax=docker/dockerfile:1

FROM golang:1.18 AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
COPY main.go ./

RUN go mod download

RUN CGO_ENABLED=0 go build -o /app/server

FROM gcr.io/distroless/static-debian11

COPY --from=build /app/server .

EXPOSE 50051

CMD ["./server"]