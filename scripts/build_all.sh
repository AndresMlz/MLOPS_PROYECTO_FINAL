#!/bin/bash

set -e

echo "🔧 Construyendo imagen de FastAPI..."
docker build -f docker/Dockerfile.fastapi -t andrsmlz/fastapi:latest .

echo "📤 Subiendo imagen de FastAPI..."
docker push andrsmlz/fastapi:latest

echo "🔧 Construyendo imagen de Streamlit..."
docker build -f docker/Dockerfile.streamlit -t andrsmlz/streamlit:latest .

echo "📤 Subiendo imagen de Streamlit..."
docker push andrsmlz/streamlit:latest

# Descomenta si usas imagen personalizada de MLflow
# echo "🔧 Construyendo imagen de MLflow..."
# docker build -f docker/Dockerfile.mlflow -t andrsmlz/mlflow:latest .
# echo "📤 Subiendo imagen de MLflow..."
# docker push andrsmlz/mlflow:latest

echo "✅ Todas las imágenes fueron construidas y subidas con éxito."
