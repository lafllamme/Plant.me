import logging
import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

# Set up logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Define the model path from environment variables
MODEL_NAME = os.getenv("MODEL_NAME", "mistralai/Mistral-7B-v0.3")
MODELS_DIR = os.getenv("MODELS_DIR", "/app/models")
MODEL_PATH = os.path.join(MODELS_DIR, MODEL_NAME)

# Check if MPS (Metal Performance Shaders) is available for Apple Silicon GPUs
if torch.backends.mps.is_available():
    device = torch.device("mps")
elif torch.cuda.is_available():
    device = torch.device("cuda")
else:
    device = torch.device("cpu")
logger.debug(f"Using device: {device}")

# Initialize the FastAPI app
app = FastAPI()

# Load tokenizer and model from the pre-downloaded model path
logger.info("Loading tokenizer...")
tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH, local_files_only=True)

logger.info("Loading model...")
model = AutoModelForCausalLM.from_pretrained(
    MODEL_PATH,
    local_files_only=True,
    torch_dtype=torch.float16 if device.type != 'cpu' else torch.float32,
    device_map='auto' if device.type != 'cpu' else None
)

# Move model to device if not using device_map
if device.type == 'cpu':
    model.to(device)

# Define the data model for input
class PlantInput(BaseModel):
    plant_name: str
    plant_type: str
    season: str
    temperature: float
    humidity: float
    location: str
    light_conditions: str

def generate_recommendation(prompt):
    inputs = tokenizer(prompt, return_tensors="pt")
    inputs = {key: value.to(device) for key, value in inputs.items()}
    outputs = model.generate(
        **inputs,
        max_new_tokens=512,
        num_beams=5,
        early_stopping=True,
        no_repeat_ngram_size=2
    )
    generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
    # Remove the prompt from the generated text
    response = generated_text[len(prompt):].strip()
    return response

@app.post("/plant-assistant")
async def get_plant_recommendation(plant_input: PlantInput):
    logger.debug(f"Received input: {plant_input}")

    # Create the improved prompt with extended instructions
    prompt = (
        "You are an expert plant care assistant AI specializing in providing detailed and personalized care advice based on the given plant information. "
        "Your response should assess the plant's health status, provide a precise watering schedule, suggest the next watering time, and offer additional care tips. "
        "Ensure that the advice is specific to the plant species and considers the provided environmental conditions. "
        "Avoid irrelevant information and keep the response professional and informative.\n\n"
        "Plant Information:\n"
        f"- Plant Name: {plant_input.plant_name}\n"
        f"- Plant Type: {plant_input.plant_type}\n"
        f"- Season: {plant_input.season}\n"
        f"- Temperature: {plant_input.temperature}°C\n"
        f"- Humidity: {plant_input.humidity}%\n"
        f"- Location: {plant_input.location}\n"
        f"- Light Conditions: {plant_input.light_conditions}\n\n"
        "Please provide the following details:\n"
        "1. **Health Status**: Assess the current health status of the plant based on the information provided.\n"
        "2. **Watering Schedule**: Recommend how often the plant should be watered.\n"
        "3. **Next Watering Time**: Suggest when the next watering should occur.\n"
        "4. **Additional Care Tips**: Offer any additional advice for caring for this plant.\n"
    )
    logger.debug(f"Generated prompt: {prompt}")

    # Generate the recommendation
    try:
        generated_text = generate_recommendation(prompt)
        logger.debug(f"Generated text: {generated_text}")
    except Exception as e:
        logger.error(f"Error during text generation: {e}")
        raise HTTPException(status_code=500, detail="Error generating plant care recommendation.")

    # Return the generated text
    return {"recommendation": generated_text}
