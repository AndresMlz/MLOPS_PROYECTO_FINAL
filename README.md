# Proyecto Final de MLOps – Predicción de Precio de Vivienda

Este proyecto implementa un sistema completo de **Machine Learning Operations (MLOps)** para entrenar, versionar y desplegar un modelo de regresión que predice el precio de una vivienda, utilizando herramientas modernas como **Airflow, MLflow, MinIO, FastAPI, Streamlit, Prometheus y Grafana**, orquestados en **MicroK8s (Kubernetes)**.

---

## 🎯 Objetivo

Construir una arquitectura modular y escalable para:

- Automatizar el entrenamiento y registro del modelo (Airflow + MLflow)
- Almacenar artefactos de entrenamiento (MinIO)
- Exponer una API para inferencias (FastAPI)
- Mostrar una interfaz web (Streamlit)
- Monitorear métricas del sistema (Prometheus + Grafana)

---

## 🧱 Componentes Principales

| Componente     | Función                                              |
|----------------|-------------------------------------------------------|
| **Airflow**    | Orquesta el flujo de entrenamiento y registro del modelo |
| **MLflow**     | Registra versiones del modelo, métricas y artefactos  |
| **MinIO**      | Almacén S3-compatible para artefactos                 |
| **PostgreSQL** | Backend para MLflow                                   |
| **FastAPI**    | API REST para servir el modelo y recibir inferencias  |
| **Streamlit**  | Interfaz de usuario para ingresar datos y visualizar resultados |
| **Prometheus** | Recolecta métricas del sistema                        |
| **Grafana**    | Visualiza métricas monitoreadas                       |

---

## 🧪 Entrenamiento del Modelo

El flujo está definido en `airflow_compose/dags/dag_entrenamiento.py` y consiste en:

1. Recolección de datos dummy
2. Preprocesamiento básico
3. Entrenamiento de modelo `LinearRegression`
4. Registro en MLflow como producción (`modelo-final`)

---

## 🚀 Despliegue en MicroK8s

### Paso 1: Construcción de imágenes (opcional)
```bash
chmod +x scripts/build_all.sh
./scripts/build_all.sh
```

### Paso 2: Despliegue del stack completo
```bash
chmod +x scripts/deploy_k8s.sh
./scripts/deploy_k8s.sh
```

---

## 🌐 Acceso a servicios

| Servicio    | URL Interna (ClusterIP)         | Puerto |
|-------------|----------------------------------|--------|
| MLflow      | `http://mlflow:5001`            | 5001   |
| FastAPI     | `http://fastapi:5000`           | 5000   |
| Streamlit   | `http://streamlit:8501`         | 8501   |
| Prometheus  | `http://prometheus:9090`        | 9090   |
| Grafana     | `http://grafana:3000`           | 3000   |

> Accede a estos servicios con port forwarding o NodePort si es necesario.

---

## 📂 Estructura del Proyecto

```plaintext
mlops_proyecto_final/
├── airflow_compose/
│   ├── config/
│   │   └── airflow.cfg
│   ├── dags/
│   │   └── dag_entrenamiento.py
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── .env
├── config/
│   ├── config.yaml
│   └── .env
├── docker/
│   ├── Dockerfile.fastapi
│   ├── Dockerfile.streamlit
│   ├── Dockerfile.mlflow
│   └── Dockerfile.postgres
├── fastapi/
│   └── main.py
├── grafana/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── pvc.yaml
├── k8s_manifests/
│   ├── configmaps/
│   │   └── global-env.yaml
│   ├── fastapi/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── grafana/
│   │   └── (archivos aquí están duplicados en carpeta raíz)
│   ├── minio/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── pvc.yaml
│   │   └── pv.yaml
│   ├── mlflow/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── pvc.yaml
│   │   └── pv.yaml
│   ├── postgres/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── pvc.yaml
│   │   ├── pv.yaml
│   │   └── initdb-configmap.yaml
│   ├── prometheus/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── configmap.yaml
│   ├── streamlit/
│   │   ├── deployment.yaml
│   │   └── service.yaml
├── models/
│   └── README.md
├── notebooks/
│   └── exploracion_inicial.ipynb
├── scripts/
│   ├── build_all.sh
│   └── deploy_k8s.sh
├── streamlit/
│   └── app.py
└── README.md
```

---

## 📌 Consideraciones Importantes

- Asegúrate de crear el bucket `mlflow` en MinIO si no se autogenera.
- El modelo cargado en FastAPI debe estar previamente registrado como `modelo-final` en MLflow con stage `Production`.
- Todos los componentes están desacoplados y corren en microservicios independientes.

---

## Autores

- Santiago Zafra

- Edwin Caro

- Andrés Matallana
---