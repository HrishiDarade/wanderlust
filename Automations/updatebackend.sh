#!/bin/bash

echo "🔄 Updating backend environment for Minikube..."

# Get Minikube IP
ipv4_address=192.168.49.2

if [ -z "$ipv4_address" ]; then
    echo "❌ ERROR: Could not get Minikube IP. Is Minikube running?"
    exit 1
fi

# Path to the .env file
file_to_find="../backend/.env.docker"

if [ ! -f "$file_to_find" ]; then
    echo "❌ ERROR: File not found: $file_to_find"
    exit 1
fi

# Update FRONTEND_URL for CORS (NodePort 31000)
new_url="FRONTEND_URL=\"http://${ipv4_address}:31000\""
sed -i "s|FRONTEND_URL.*|$new_url|g" "$file_to_find"

echo "✅ Updated FRONTEND_URL to: http://${ipv4_address}:31000"