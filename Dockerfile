# Sử dụng Node.js để build
FROM node:20 AS builder

# Thiết lập thư mục làm việc
WORKDIR /usr/app

# Copy package.json và cài đặt dependencies
COPY package*.json ./
RUN npm install

# Copy toàn bộ code vào container
COPY . .

# Build Vue
RUN npm run build

# ---- Production ----
FROM node:20 AS runner

WORKDIR /usr/app

# Cài đặt 'serve' để chạy static files
RUN npm install -g serve

# Copy thư mục build từ stage trước
COPY --from=builder /usr/app/dist ./dist

# Expose cổng 8080 (Vue mặc định chạy ở đây)
EXPOSE 8081

# Chạy app với serve
CMD ["serve", "-s", "dist", "-l", "8081"]
