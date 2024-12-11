# Build stage
FROM golang:1.22-alpine3.20 AS builder
#declare the current working dir inside the image
WORKDIR /app 

# The first dot means that copy everything from current folder,
# Where we run the docker build command to build the image.
# In this case, we will build from the root of our project,
# So everything under the simple bank folder will be copied to the image.
# The second dot is the current working directory inside the image,
# Where the files and folders are being copied to.
# As we’ve already stated that the current WORKDIR is /app before,
# that will be the place to store the copied data.
COPY . .
RUN go build -o main main.go
RUN apk --no-cache add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.18.1/migrate.linux-amd64.tar.gz | tar xvz \
    && mv migrate migrate.linux-amd64


# Run stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]