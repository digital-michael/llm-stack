#!/bin/bash
set -e

GPU_ENABLED=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --gpu) GPU_ENABLED=true; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
done

echo "🔧 Preparing environment..."

if $GPU_ENABLED; then
    echo "🟢 GPU support enabled (NVIDIA runtime)"
    export GPU_RUNTIME=nvidia
else
    echo "⚪ GPU support disabled (default runtime)"
    export GPU_RUNTIME=runc
fi

docker compose --env-file .env up -d