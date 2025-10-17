# Dockerfile - Node.js app
FROM node:18-alpine

WORKDIR /app

# Cache-friendly copy - CORRECTED: Assumes package.json is in the build context root
# COPY package*.json ./
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --only=production

# Copy app code - CORRECTED: Assumes the rest of the application files (e.g., app.js) 
# are in a subdirectory named 'app'
COPY app/ ./ 

# Expose the port the app runs on
EXPOSE 3000

# Start command (matches package.json "start")
CMD ["npm", "start"]
