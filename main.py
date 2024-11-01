from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
import json
import os

app = FastAPI()

class PlantRequest(BaseModel):
    plant_name: str
    plant_type: str
    season: str
    temperature: float
    humidity: float
    location: str
    light_conditions: str

# Hugging Face API Token aus Umgebungsvariablen
HF_API_TOKEN = os.getenv("HF_API_TOKEN")

# Lade das Modell und den Tokenizer von Hugging Face
model_name = "gpt2-medium"  # Verwende gpt2-medium für bessere Ergebnisse
tokenizer = AutoTokenizer.from_pretrained(model_name, token=HF_API_TOKEN)
model = AutoModelForCausalLM.from_pretrained(model_name, token=HF_API_TOKEN)
model.eval()

# Definiere die Templates für die Prompts
validation_template = (
    "Validiere die folgenden Daten zur Pflanze:\n"
    "Name: {plant_name}\n"
    "Art: {plant_type}\n"
    "Jahreszeit: {season}\n"
    "Temperatur: {temperature}°C\n"
    "Feuchtigkeit: {humidity}%\n"
    "Standort: {location}\n"
    "Lichtverhältnisse: {light_conditions}\n"
    "Antwort nur mit 'Validiert' oder 'Nicht validiert'."
)

identification_template = (
    "Identifiziere die Pflanze basierend auf dem Namen:\n"
    "Name: {plant_name}\n"
    "Antwort nur mit dem wissenschaftlichen Namen."
)

recommendation_template = (
    "Generiere Pflegeempfehlungen für die Pflanze basierend auf den folgenden Daten:\n"
    "Name: {plant_name}\n"
    "Art: {plant_type}\n"
    "Jahreszeit: {season}\n"
    "Temperatur: {temperature}°C\n"
    "Feuchtigkeit: {humidity}%\n"
    "Standort: {location}\n"
    "Lichtverhältnisse: {light_conditions}\n"
    "Antwort als JSON mit Feldern: 'watering_schedule', 'health_status'."
)

def create_prompt(template, **kwargs):
    return template.format(**kwargs)

@app.post("/plant-assistant")
def plant_assistant(request: PlantRequest):
    try:
        # Bestimme das Gerät (MPS für M1/M2 Macs, ansonsten CPU)
        device = torch.device("mps" if torch.has_mps else "cpu")
        model.to(device)

        # Schritt 1: Validierung
        validation_prompt = create_prompt(validation_template, **request.dict())
        inputs = tokenizer(validation_prompt, return_tensors="pt").to(device)
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=20,  # Begrenze die neuen Tokens
                temperature=0.7,
                top_p=0.9,
                num_return_sequences=1,
                eos_token_id=tokenizer.eos_token_id
            )
        validation_result = tokenizer.decode(outputs[0], skip_special_tokens=True).strip()

        # Schritt 2: Identifikation
        identification_prompt = create_prompt(identification_template, **request.dict())
        inputs = tokenizer(identification_prompt, return_tensors="pt").to(device)
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=20,  # Begrenze die neuen Tokens
                temperature=0.7,
                top_p=0.9,
                num_return_sequences=1,
                eos_token_id=tokenizer.eos_token_id
            )
        identification_result = tokenizer.decode(outputs[0], skip_special_tokens=True).strip()

        # Schritt 3: Empfehlung
        recommendation_prompt = create_prompt(recommendation_template, **request.dict())
        inputs = tokenizer(recommendation_prompt, return_tensors="pt").to(device)
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=200,  # Erhöhe die neuen Tokens auf 200
                temperature=0.7,
                top_p=0.9,
                num_return_sequences=1,
                eos_token_id=tokenizer.eos_token_id
            )
        recommendation_result = tokenizer.decode(outputs[0], skip_special_tokens=True).strip()
        print(recommendation_result)

        # Versuch, die Empfehlung als JSON zu parsen
        try:
            recommendation_json = json.loads(recommendation_result)
        except json.JSONDecodeError:
            recommendation_json = {"watering_schedule": recommendation_result, "health_status": "Unbekannt"}

        # Strukturierte JSON-Antwort
        response = {
            "plant_name": request.plant_name,
            "plant_type": request.plant_type,
            "season": request.season,
            "temperature": request.temperature,
            "humidity": request.humidity,
            "location": request.location,
            "light_conditions": request.light_conditions,
            "validation": validation_result,
            "identification": identification_result,
            "recommendation": recommendation_json
        }

        return response

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
