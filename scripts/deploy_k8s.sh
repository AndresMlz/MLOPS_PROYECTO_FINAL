#!/bin/bash

set -e

echo "🚀 Aplicando ConfigMaps..."
kubectl apply -f k8s_manifests/configmaps/global-env.yaml
kubectl apply -f k8s_manifests/postgres/initdb-configmap.yaml
kubectl apply -f k8s_manifests/prometheus/configmap.yaml

echo "💾 Desplegando PostgreSQL..."
kubectl apply -f k8s_manifests/postgres/pv.yaml
kubectl apply -f k8s_manifests/postgres/pvc.yaml
kubectl apply -f k8s_manifests/postgres/deployment.yaml
kubectl apply -f k8s_manifests/postgres/service.yaml

echo "🪣 Desplegando MinIO..."
kubectl apply -f k8s_manifests/minio/pv.yaml
kubectl apply -f k8s_manifests/minio/pvc.yaml
kubectl apply -f k8s_manifests/minio/deployment.yaml
kubectl apply -f k8s_manifests/minio/service.yaml

echo "📦 Desplegando MLflow..."
kubectl apply -f k8s_manifests/mlflow/pv.yaml
kubectl apply -f k8s_manifests/mlflow/pvc.yaml
kubectl apply -f k8s_manifests/mlflow/deployment.yaml
kubectl apply -f k8s_manifests/mlflow/service.yaml

echo "⚙️ Desplegando FastAPI..."
kubectl apply -f k8s_manifests/fastapi/deployment.yaml
kubectl apply -f k8s_manifests/fastapi/service.yaml

echo "🖥️ Desplegando Streamlit..."
kubectl apply -f k8s_manifests/streamlit/deployment.yaml
kubectl apply -f k8s_manifests/streamlit/service.yaml

echo "📈 Desplegando Prometheus..."
kubectl apply -f k8s_manifests/prometheus/deployment.yaml
kubectl apply -f k8s_manifests/prometheus/service.yaml

echo "📊 Desplegando Grafana..."
kubectl apply -f k8s_manifests/grafana/pvc.yaml
kubectl apply -f k8s_manifests/grafana/deployment.yaml
kubectl apply -f k8s_manifests/grafana/service.yaml

echo "✅ Todo el stack fue desplegado correctamente en Kubernetes."
