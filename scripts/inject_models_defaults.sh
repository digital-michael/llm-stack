#!/bin/bash
set -e

CONTAINER_NAME="llm-ollama"

# ----------------------------------------
# Default model list
# ----------------------------------------
DEFAULT_MODELS=("llama3" "qwen:0.5b" "qwen:1.8b")

# ----------------------------------------
# Use CLI arguments if provided
# ----------------------------------------
if [ "$#" -gt 0 ]; then
  MODELS=("$@")
  echo "📦 Using user-specified models: ${MODELS[*]}"
else
  MODELS=("${DEFAULT_MODELS[@]}")
  echo "📦 Using default models: ${MODELS[*]}"
fi

# ----------------------------------------
# Wait for the container to be running
# ----------------------------------------

echo "🔍 Waiting for $CONTAINER_NAME to be ready..."

until docker exec "$CONTAINER_NAME" ollama list >/dev/null 2>&1; do
  sleep 1
  echo "⏳ Waiting for Ollama inside container..."
done

echo "✅ Ollama is responsive inside container."

# ----------------------------------------
# Pull each model inside the container
# ----------------------------------------

for model in "${MODELS[@]}"; do
  echo "⬇️  Pulling $model inside container..."
  docker exec "$CONTAINER_NAME" ollama pull "$model"
done

echo "✅ Model pull complete."

