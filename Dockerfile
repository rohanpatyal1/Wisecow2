# Dockerfile
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port (check app's port, assuming 3000)
EXPOSE 4499

# Start the application
CMD ["npm", "start"]
