# Stage 1: Build the React Frontend
FROM node:latest AS client-build

WORKDIR /app/client

# Copy the frontend package.json and package-lock.json to the container
COPY client/package*.json ./

# Install frontend dependencies
RUN npm install

# Copy the rest of the frontend application files
COPY client ./

# Build the React frontend
RUN npm run build

# Stage 2: Build the Node.js Backend
FROM node:latest AS server-build

WORKDIR /app

# Copy the backend package.json and package-lock.json to the container
COPY api/package*.json ./

# Install backend dependencies
RUN npm install

# Copy the rest of the backend application files
COPY api ./

# Stage 3: Create the Production Node.js Server
FROM node:latest

WORKDIR /app

# Copy the built frontend from the client-build stage to the /app/public directory
COPY --from=client-build /app/client/build ./public

# Copy the built backend from the server-build stage to the /app directory
COPY --from=server-build /app .

# Install production dependencies for the Node.js server
RUN npm install --production

# Expose the server port (change this to the appropriate port your Node.js server listens on)
EXPOSE 3000

# Start the Node.js server
CMD ["npm", "start"]
