# Multi-stage build for production
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY client/package*.json ./client/
COPY server/package*.json ./server/

# Install dependencies
RUN npm ci --only=production
RUN cd client && npm ci --only=production
RUN cd server && npm ci --only=production

# Copy source code
COPY client/ ./client/
COPY server/ ./server/

# Build client
RUN cd client && npm run build

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Copy server and built client
COPY --from=build /app/server ./server
COPY --from=build /app/client/dist ./client/dist

# Expose port
EXPOSE 3001

# Start server
CMD ["npm", "start"]