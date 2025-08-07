# Use a Debian-based Node.js image for better compatibility
FROM node:18-bullseye AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker caching
COPY package.json package-lock.json ./

# Install dependencies using npm ci for a clean install
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Use a lightweight web server to serve the static files
FROM nginx:alpine AS production

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for serving the app
EXPOSE 80

# Start the nginx server
CMD ["nginx", "-g", "daemon off;"]