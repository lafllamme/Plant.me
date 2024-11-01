Here’s an improved English version of your `README.md`:

---

# Plant Assistant

A local Plant Assistant that runs on your Mac and uses LangChain and a Large Language Model (LLM) to provide plant care recommendations based on various parameters.

## Prerequisites

- Docker
- Docker Compose
- Hugging Face API Token

## Setup

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/your-username/plant-assistant.git
    cd plant-assistant
    ```

2. **Create a `.env` File for Environment Variables:**

    ```plaintext
    HF_API_TOKEN=your_hugging_face_api_token
    ```

   **Note:** Replace `your_hugging_face_api_token` with your actual Hugging Face API token.

3. **Build and Start the Application with Docker Compose:**

    ```bash
    docker-compose up --build
    ```

   **Optional Flags:**
   - `-d`: Run containers in detached mode.

    ```bash
    docker-compose up --build -d
    ```

4. **Check if the Container is Running:**

    ```bash
    docker-compose ps
    ```

## Usage

The API is now available at `http://localhost:8000/plant-assistant`.

### Example cURL Request:

```bash
curl -X POST "http://localhost:8000/plant-assistant" \
     -H "Content-Type: application/json" \
     -d '{
           "plant_name": "Ficus lyrata",
           "plant_type": "Indoor plant",
           "season": "Summer",
           "temperature": 22.5,
           "humidity": 60,
           "location": "Living room",
           "light_conditions": "Bright indirect light"
         }'
```

---

This improved version is more concise and clear for an English-speaking audience. Let me know if there’s anything else you’d like to add!