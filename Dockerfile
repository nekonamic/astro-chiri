# Step 1: Build stage
FROM node:20-alpine AS builder

# Create app directory
WORKDIR /app

# Copy package files & install deps
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Build the Astro app
RUN pnpm build

# Step 2: Runtime stage
FROM node:20-alpine

WORKDIR /app

# Copy built files and only production deps
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

EXPOSE 3000

CMD ["ls", "./dist/"]
