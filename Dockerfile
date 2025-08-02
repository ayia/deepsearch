FROM node:20.18.0-slim AS builder

WORKDIR /home/perplexica

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --network-timeout 600000

# Copy source files
COPY tsconfig.json next.config.mjs next-env.d.ts postcss.config.js drizzle.config.ts tailwind.config.ts ./
COPY src ./src
COPY public ./public
COPY drizzle ./drizzle

# Create data directory
RUN mkdir -p /home/perplexica/data

# Build the application
RUN yarn build

# Build migrator
RUN yarn add --dev @vercel/ncc
RUN yarn ncc build ./src/lib/db/migrate.ts -o migrator

# Production stage
FROM node:20.18.0-slim

WORKDIR /home/perplexica

# Copy built application
COPY --from=builder /home/perplexica/public ./public
COPY --from=builder /home/perplexica/.next/static ./public/_next/static
COPY --from=builder /home/perplexica/.next/standalone ./
COPY --from=builder /home/perplexica/data ./data
COPY --from=builder /home/perplexica/migrator/build ./build
COPY --from=builder /home/perplexica/migrator/index.js ./migrate.js

# Create uploads directory in data volume
RUN mkdir -p /home/perplexica/data/uploads

# Copy entrypoint script
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Expose port
EXPOSE 3000

# Start the application
CMD ["./entrypoint.sh"] 