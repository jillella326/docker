# Stage 1: Build the Go application
FROM golang:1.19 AS go-build

WORKDIR /app
COPY main.go go.mod ./
RUN go mod download
RUN go build -o my-go-app

# Stage 2: Build the Python application
FROM python:3.10 AS python-build

WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py ./

# Stage 3: Create a minimal final image
FROM alpine:latest

WORKDIR /app
COPY --from=go-build /app/my-go-app ./my-go-app
COPY --from=python-build /app/main.py ./
COPY --from=python-build /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

# Set the entrypoint for your application (modify as needed)
CMD ["sh", "-c", "./my-go-app & python main.py"]
