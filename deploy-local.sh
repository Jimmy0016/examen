#!/bin/bash

# Local deployment script for testing
set -e

echo "Building Docker image locally..."
docker build -t espinoza:1.0.5 .

echo "Stopping existing containers..."
docker stop espinoza-container 2>/dev/null || true
docker rm espinoza-container 2>/dev/null || true

echo "Running new container..."
docker run -d --name espinoza-container -p 5000:5000 espinoza:1.0.5

echo "Waiting for container to start..."
sleep 5

echo "Testing health endpoint..."
curl -f http://localhost:5000/health || echo "Health check failed"

echo "Container is running on http://localhost:5000"
echo "Test the AI endpoint with: curl -X POST -H 'Content-Type: application/json' -d '{\"prompt\":\"Hello\"}' http://localhost:5000/api/reply"