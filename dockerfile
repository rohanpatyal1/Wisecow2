# Use multi-stage build to keep image small
# Stage 1: build
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files first to leverage cache
COPY package*.json ./
RUN npm ci --only=production

# Copy app source
COPY . .


RUN npm run build

# Stage 2: runtime
FROM node:18-alpine
WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy production node_modules and app files
COPY --from=build --chown=appuser:appgroup /app /app

ENV NODE_ENV=production
EXPOSE 4499

# update $PORT accordingly
ENV PORT=4499

CMD ["node", "server.js"]
