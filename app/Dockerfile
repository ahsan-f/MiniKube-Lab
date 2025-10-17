# Stage 1: Builder
# Use a full Node image for building dependencies
FROM node:18-alpine AS builder

WORKDIR /app

# 1. Copy package files first for cache efficiency.
# REQUIRES: package.json and package-lock.json must be present in the build context root (i.e., in the 'app/' directory on your host).
# This COPY command assumes you are running docker build from the root, targeting app/Dockerfile, 
# and the files are located at app/package.json and app/package-lock.json.
COPY app/package.json app/package-lock.json ./

# 2. Install production dependencies using npm ci for reproducibility
# FIX: Using --omit=dev is the correct way to exclude development dependencies with npm ci.
RUN npm ci --omit=dev

# 3. Copy the rest of the application code
# This copies your app's JavaScript files, including app.js
COPY app/. .

# Stage 2: Production
# Use a minimal base image to run the application
FROM node:18-alpine AS production

WORKDIR /app

# 1. Copy only the installed dependencies and app code from the builder stage
COPY --from=builder /app /app

# 2. Define environment variables and startup command
ENV PORT=3000

EXPOSE 3000

# Execute the application
CMD [ "node", "app.js" ]
