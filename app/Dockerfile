# Stage 1: Builder
# Use a full Node image for building dependencies
FROM node:18-alpine AS builder

WORKDIR /app

# 1. Copy package files first for cache efficiency.
# Assumes package.json and package-lock.json are in the 'app/' directory on the host.
COPY app/package.json app/package-lock.json ./

# 2. Install production dependencies using npm install (Fix for persistent 'npm ci' failure)
# We use '--omit=dev' to ensure only production dependencies are installed.
RUN npm install --omit=dev

# 3. Copy the rest of the application code
COPY app/. .

# 4. Optional: Clean up cache to minimize layer size
RUN npm cache clean --force

# ----------------------------------------------------------------------

# Stage 2: Production
# Use the same base image for consistency and running the application
FROM node:18-alpine AS production

WORKDIR /app

# 1. Copy only the installed dependencies and application code from the builder stage
# This creates a smaller final image by excluding build artifacts and npm cache.
COPY --from=builder /app /app

# 2. Define environment variables and startup command
ENV PORT=3000

EXPOSE 3000

# Execute the application
CMD [ "node", "app.js" ]
