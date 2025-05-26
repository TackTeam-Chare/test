# Stage 1: Build Angular
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:stable-alpine AS runner

# ✅ Important: change NGINX to listen on port 8080
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ✅ Copy build output
COPY --from=builder /app/dist/anguar-test /usr/share/nginx/html

# ✅ Cloud Run requires EXPOSE 8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
