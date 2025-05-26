# Stage 1: Build Angular
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: Serve with http-server
FROM node:18-alpine

RUN npm install -g http-server

# ✅ Copy ONLY the compiled browser output (not root dist)
COPY --from=builder /app/dist/anguar-test/browser /app

ENV PORT 8080
EXPOSE 8080

# ✅ Serve /app instead of /app/browser
CMD ["http-server", "/app", "-p", "8080", "-c-1"]
