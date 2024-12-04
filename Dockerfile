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

# Run stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .

EXPOSE 8080
CMD [ "/app/main" ]