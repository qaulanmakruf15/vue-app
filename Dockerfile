## NODE Config
FROM node:12.19.0-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn build



## NGINX Config
FROM nginx:stable-alpine
LABEL version="1.0"

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/dist/ .