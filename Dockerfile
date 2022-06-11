FROM node:18.3.0-alpine AS builder

WORKDIR /app

COPY package*.json .
COPY tsconfig.json .
RUN npm install --save-prod

COPY . .

RUN npm run build

FROM nginx:1.21.6 AS prod 

COPY --from=builder /app/build /usr/share/nginx/html 
COPY nginx.conf /etc/nginx/conf.d/default.conf 

EXPOSE 80 

CMD ["nginx", "-g", "daemon off;"]

