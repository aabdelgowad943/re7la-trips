#Stage 1: Build Angular App
FROM node:18.13.0 as node
WORKDIR /app
COPY . .
RUN npm install --legacy-peer-deps
RUN npm run build

# Stage 2: Set up NGINX with SSL
FROM nginx:alpine

# Copy NGINX configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificates and private key
# COPY --from=node /app/certs /etc/nginx/certs/

# Copy built Angular app
COPY --from=node /app/dist/re7la_frontend/browser /usr/share/nginx/html

# Expose ports
EXPOSE 80
# EXPOSE 443

RUN nginx -t

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
