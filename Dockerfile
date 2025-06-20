# Builder
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum to download dependencies first
COPY go.* ./
RUN go mod download

# Copy the rest of aource code
COPY . .

# Build the application for a minimal, static binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags="-w -s" -o app .

# Stage 2: Create the final, minimal image
FROM alpine:latest

# Add a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/app .

# File Owner
USER appuser

# Expose the port and run the application
EXPOSE 8080
CMD ["./app"]