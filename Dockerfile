# Stage 1: Building the code
FROM node:18 AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Running the application
FROM node:18

WORKDIR /app
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# NextJS uses port 3000 by default
# EXPOSE is for documentation purposes
EXPOSE 8080
# ENV PORT 8080 This is set by Cloud Run automatically

CMD ["npm", "start"]
