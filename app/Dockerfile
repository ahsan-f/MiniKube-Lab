# Use a Node.js base image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
# IMPORTANT: These paths assume the build context is the root of the repository.
COPY app/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code, including the necessary app.js file
COPY app/ ./

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application (must match the script in package.json)
CMD [ "npm", "start" ]
