# Dockerfile - Node.js app
FROM node:18-alpine

WORKDIR /app

# Cache-friendly copy
COPY app/package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy app code
COPY app/ ./

# Expose the port the app runs on
EXPOSE 3000

# Start command (matches package.json "start")
CMD ["npm", "start"]
