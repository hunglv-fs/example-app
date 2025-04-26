# Sử dụng Node.js 18 làm base image
FROM node:18

# Đặt thư mục làm việc
WORKDIR /app

# Copy package.json trước
COPY package.json .

# Cài dependencies
RUN npm install

# Copy toàn bộ code
COPY . .

# Mở cổng
EXPOSE 3000

# Lệnh chạy app
CMD ["node", "index.js"]
