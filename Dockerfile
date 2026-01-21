FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache git python3 make g++

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY contracts/package*.json ./contracts/
COPY frontend/package*.json ./frontend/

# Install dependencies
RUN cd contracts && npm ci
RUN cd frontend && npm ci

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Default command
CMD ["cd", "frontend", "&&", "npm", "run", "dev"]
