## NODE Config
FROM node:12.4.0-alpine as builder

WORKDIR /app

COPY package.json package-lock.json ./
COPY . /app
COPY .env /app/.env

RUN yarn \
    && yarn build


## NGINX Config
FROM nginx:stable-alpine
LABEL version="1.0"

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/dist/ .
