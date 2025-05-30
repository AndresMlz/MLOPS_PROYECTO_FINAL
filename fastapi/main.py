from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import mlflow.pyfunc
import os

app = FastAPI()

# Cargar el modelo desde MLflow
try:
    model = mlflow.pyfunc.load_model("models:/modelo-final/Production")
except Exception as e:
    model = None
    print("Error cargando modelo:", e)

class InputData(BaseModel):
    bed: int
    bath: int
    house_size: float
    acre_lot: float

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.post("/predict")
def predict(data: InputData):
    if model is None:
        raise HTTPException(status_code=500, detail="Modelo no cargado")
    
    input_df = data.dict()
    prediction = model.predict([list(input_df.values())])
    return {"prediction": prediction[0]}
