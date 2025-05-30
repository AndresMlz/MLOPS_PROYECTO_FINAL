import streamlit as st
import requests

st.set_page_config(page_title="Predicción de Precio de Vivienda", layout="centered")

st.title("Predicción de precio de vivienda")
st.markdown("Ingrese las características de la propiedad:")

# Formulario
bed = st.number_input("Número de habitaciones", min_value=0, value=3)
bath = st.number_input("Número de baños", min_value=0, value=2)
house_size = st.number_input("Tamaño de la casa (ft²)", min_value=0.0, value=1200.0)
acre_lot = st.number_input("Tamaño del terreno (acres)", min_value=0.0, value=0.1)

if st.button("Predecir precio"):
    input_data = {
        "bed": bed,
        "bath": bath,
        "house_size": house_size,
        "acre_lot": acre_lot
    }

    try:
        response = requests.post("http://fastapi:5000/predict", json=input_data)
        if response.status_code == 200:
            pred = response.json()["prediction"]
            st.success(f"Precio estimado: ${pred:,.2f}")
        else:
            st.error(f"Error en la predicción: {response.text}")
    except Exception as e:
        st.error(f"No se pudo conectar a la API: {e}")
