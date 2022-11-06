FROM golang:1.19-buster as builder

WORKDIR /app

COPY go.* ./

COPY app.yaml ./

RUN go mod download

COPY . ./

RUN go build -v -o /k8s-example-app

FROM debian:buster-slim

RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/k8s-example-app /app/k8s-example-app
  
EXPOSE 3000

CMD [ "/app/k8s-example-app" ]