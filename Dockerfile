# Stage 1: Build Angular app
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code and build
COPY . .
RUN npm run build

# Stage 2: Serve with http-server
FROM node:18-alpine

# Install http-server globally
RUN npm install -g http-server

# Copy built Angular app from builder stage
COPY --from=builder /app/dist/anguar-test /app

# Cloud Run requires PORT=8080
ENV PORT 8080

# Expose port for Cloud Run
EXPOSE 8080

# Start the server
CMD [ "http-server", "/app", "-p", "8080", "-c-1" ]
