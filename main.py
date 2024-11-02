import logging
from fastapi import FastAPI
from pydantic import BaseModel
from transformers import pipeline

# Set up logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)


# Define the data model for input
class PlantInput(BaseModel):
    plant_name: str
    plant_type: str
    season: str
    temperature: float
    humidity: float
    location: str
    light_conditions: str


# Initialize the FastAPI app
app = FastAPI()

# Initialize the language model
# Use a small, efficient model suitable for CPU inference
generator = pipeline('text-generation', model='distilgpt2')


@app.post("/plant-assistant")
async def get_plant_recommendation(plant_input: PlantInput):
    logger.debug(f"Received input: {plant_input}")

    # Create a simple prompt based on the input
    prompt = (
        f"Provide plant care advice for a {plant_input.plant_type} named {plant_input.plant_name} "
        f"located in the {plant_input.location} during {plant_input.season}. "
        f"The temperature is {plant_input.temperature}°C with {plant_input.humidity}% humidity "
        f"and {plant_input.light_conditions}."
    )
    logger.debug(f"Generated prompt: {prompt}")

    # Generate a response using the model
    response = generator(
        prompt,
        max_length=150,
        num_return_sequences=1,
        return_full_text=False,
        truncation=True,
        pad_token_id=generator.tokenizer.eos_token_id or 50256
    )
    logger.debug(f"Full response: {response}")

    # Extract the generated text
    generated_text = response[0]['generated_text']
    logger.debug(f"Generated text is: {generated_text}")

    # Return the generated text
    return {"recommendation": generated_text}
