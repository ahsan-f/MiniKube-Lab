# Stage 1: Builder
# Use a full Node image for building dependencies
FROM node:18-alpine AS builder

WORKDIR /app

# 1. Copy package files first for cache efficiency.
# This step REQUIRES both package.json AND package-lock.json to exist on your host machine.
COPY app/package.json app/package-lock.json ./

# 2. Install production dependencies using npm ci for reproducibility
RUN npm ci --only=production

# 3. Copy the rest of the application code
COPY . .

# Stage 2: Production
# Use a minimal base image to run the application
FROM node:18-alpine AS production

WORKDIR /app

# 1. Copy only the installed dependencies and app code from the builder stage
# This step excludes development dependencies and build tools.
COPY --from=builder /app /app

# 2. Define environment variables and startup command
ENV PORT=3000

EXPOSE 3000

# Execute the application
CMD [ "node", "app.js" ]
