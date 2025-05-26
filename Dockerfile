# Stage 1: Build Angular app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency info
COPY package*.json ./
RUN npm ci

# Copy full source code
COPY . .

# Build Angular app
RUN npm run build

# Stage 2: Use NGINX to serve
FROM nginx:stable-alpine AS runner

# Copy built Angular dist to NGINX html folder
COPY --from=builder /app/dist/anguar-test /usr/share/nginx/html

# Rewrite rules for Angular routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
