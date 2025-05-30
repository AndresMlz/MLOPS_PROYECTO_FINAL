from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime
import pandas as pd
import mlflow
import mlflow.sklearn
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import os

# Configuración de MLflow
MLFLOW_TRACKING_URI = os.getenv("MLFLOW_TRACKING_URI", "http://mlflow:5001")
mlflow.set_tracking_uri(MLFLOW_TRACKING_URI)
EXPERIMENT_NAME = "prediccion_vivienda"

# DAG
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
    'retries': 0
}

dag = DAG(
    'dag_entrenamiento',
    default_args=default_args,
    description='DAG de entrenamiento y registro en MLflow',
    schedule_interval=None,  # Manual
    catchup=False
)

# Funciones simuladas
def recolectar_datos():
    data = pd.DataFrame({
        'bed': [2, 3, 4],
        'bath': [1, 2, 3],
        'house_size': [1000, 1500, 2000],
        'acre_lot': [0.2, 0.3, 0.5],
        'price': [100000, 150000, 200000]
    })
    data.to_csv('/tmp/datos.csv', index=False)

def preprocesar():
    df = pd.read_csv('/tmp/datos.csv')
    X = df[['bed', 'bath', 'house_size', 'acre_lot']]
    y = df['price']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    df_train = pd.concat([X_train, y_train], axis=1)
    df_train.to_csv('/tmp/train.csv', index=False)

def entrenar():
    df = pd.read_csv('/tmp/train.csv')
    X = df[['bed', 'bath', 'house_size', 'acre_lot']]
    y = df['price']

    mlflow.set_experiment(EXPERIMENT_NAME)
    with mlflow.start_run():
        model = LinearRegression()
        model.fit(X, y)

        mlflow.log_param("modelo", "LinearRegression")
        mlflow.log_metric("r2", model.score(X, y))
        mlflow.sklearn.log_model(model, "model")

        mlflow.register_model(
            model_uri="runs:/{}/model".format(mlflow.active_run().info.run_id),
            name="modelo-final"
        )

        client = mlflow.tracking.MlflowClient()
        client.transition_model_version_stage(
            name="modelo-final",
            version=1,
            stage="Production",
            archive_existing_versions=True
        )

# Tareas
t1 = PythonOperator(task_id='recolectar_datos', python_callable=recolectar_datos, dag=dag)
t2 = PythonOperator(task_id='preprocesar', python_callable=preprocesar, dag=dag)
t3 = PythonOperator(task_id='entrenar_y_registrar', python_callable=entrenar, dag=dag)

# Dependencias
t1 >> t2 >> t3
