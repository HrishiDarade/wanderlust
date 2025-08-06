#!/bin/bash

echo "🔄 Updating frontend environment for Minikube..."

# Get Minikube IP
ipv4_address=192.168.49.2

if [ -z "$ipv4_address" ]; then
    echo "❌ ERROR: Could not get Minikube IP. Is Minikube running?"
    exit 1
fi

# Path to the .env file
file_to_find="../frontend/.env.docker"

# Create file if it doesn't exist
[ ! -f "$file_to_find" ] && touch "$file_to_find"

# Update VITE_API_PATH for API calls (NodePort 31100)
new_url="VITE_API_PATH=\"http://${ipv4_address}:31100\""

if grep -q "VITE_API_PATH" "$file_to_find"; then
    sed -i "s|VITE_API_PATH.*|$new_url|g" "$file_to_find"
else
    echo "$new_url" >> "$file_to_find"
fi

echo "✅ Updated VITE_API_PATH to: http://${ipv4_address}:31100"