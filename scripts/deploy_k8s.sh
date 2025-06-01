#!/bin/bash

set -e
KUBECTL="microk8s kubectl"

echo "🚀 Aplicando ConfigMaps..."
$KUBECTL apply -f k8s_manifests/configmaps/global-env.yaml
$KUBECTL apply -f k8s_manifests/postgres/initdb-configmap.yaml
$KUBECTL apply -f k8s_manifests/prometheus/configmap.yaml

echo "💾 Desplegando PostgreSQL..."
$KUBECTL apply -f k8s_manifests/postgres/pv.yaml
$KUBECTL apply -f k8s_manifests/postgres/pvc.yaml
$KUBECTL apply -f k8s_manifests/postgres/deployment.yaml
$KUBECTL apply -f k8s_manifests/postgres/service.yaml

echo "🪣 Desplegando MinIO..."
$KUBECTL apply -f k8s_manifests/minio/pv.yaml
$KUBECTL apply -f k8s_manifests/minio/pvc.yaml
$KUBECTL apply -f k8s_manifests/minio/deployment.yaml
$KUBECTL apply -f k8s_manifests/minio/service.yaml

echo "📦 Desplegando MLflow..."
$KUBECTL apply -f k8s_manifests/mlflow/pv.yaml
$KUBECTL apply -f k8s_manifests/mlflow/pvc.yaml
$KUBECTL apply -f k8s_manifests/mlflow/deployment.yaml
$KUBECTL apply -f k8s_manifests/mlflow/service.yaml

echo "⚙️ Desplegando FastAPI..."
$KUBECTL apply -f k8s_manifests/fastapi/deployment.yaml
$KUBECTL apply -f k8s_manifests/fastapi/service.yaml

echo "🖥️ Desplegando Streamlit..."
$KUBECTL apply -f k8s_manifests/streamlit/deployment.yaml
$KUBECTL apply -f k8s_manifests/streamlit/service.yaml

echo "📈 Desplegando Prometheus..."
$KUBECTL apply -f k8s_manifests/prometheus/deployment.yaml
$KUBECTL apply -f k8s_manifests/prometheus/service.yaml

echo "📊 Desplegando Grafana..."
$KUBECTL apply -f k8s_manifests/grafana/pvc.yaml
$KUBECTL apply -f k8s_manifests/grafana/deployment.yaml
$KUBECTL apply -f k8s_manifests/grafana/service.yaml

echo "✅ Todo el stack fue desplegado correctamente en MicroK8s."
