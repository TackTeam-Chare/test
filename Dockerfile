# Step 1: Build Angular app
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Step 2: Serve with NGINX
FROM nginx:stable-alpine

# ✅ Copy build output (เปลี่ยนชื่อให้ตรง angular.json)
COPY --from=builder /app/dist/anguar-test /usr/share/nginx/html

# ✅ ใช้ config ที่ support Angular routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
