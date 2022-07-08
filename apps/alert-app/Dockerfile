# syntax=docker/dockerfile:1

### Build
FROM golang:1.18.3-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

# COPY *.go ./
COPY . .

RUN go build -o ./out .

### Deploy
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /app/out /out

EXPOSE 8080

USER nonroot:nonroot

CMD ["./out"]
