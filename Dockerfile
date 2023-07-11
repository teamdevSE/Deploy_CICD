# Stage 1: Build dependencies
FROM node:alpine as deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

# Stage 2: Build the application
FROM node:alpine as builder
WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules
RUN npm run build

# Stage 3: Create production image
FROM node:alpine as production
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 3000
CMD [ "npm", "run", "start" ]