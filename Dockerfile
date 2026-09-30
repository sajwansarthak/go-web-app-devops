FROM golang:1.22.5 AS base 

WORKDIR /app

# update the go commands and run them
COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o main .

#Final stage - Distroless image

FROM gcr.io/distroless/base

# Binary must be statically linked, so we need to use the distroless base image
COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]

