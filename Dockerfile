# Stage 1: Downloader
FROM python:3.9-slim AS model

# Prevent Python from writing .pyc files and buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set build arguments for Hugging Face API token and model name
ARG HF_API_TOKEN
ARG MODEL_NAME=mistralai/Mistral-7B-v0.3

# Install necessary system dependencies, including git-lfs for large model files
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    && git lfs install \
    && rm -rf /var/lib/apt/lists/*π

# Install huggingface_hub which includes snapshot_download
RUN pip install --no-cache-dir huggingface_hub

# Create the models directory under /app/models
RUN mkdir -p /app/models

# Download the model using snapshot_download with token
RUN python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='${MODEL_NAME}', local_dir='/app/models/${MODEL_NAME}', token='${HF_API_TOKEN}')"

RUN if [ ! -f /app/models/consolidated.safetensors ] || [ ! -f /app/models/tokenizer.model.v3 ]; then \
        echo "Essential model files not found. Downloading model..."; \
        python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='${MODEL_NAME}', local_dir='/app/models/${MODEL_NAME}', token='${HF_API_TOKEN}')";\
    else \
        echo "Essential model files already exist. Skipping download." ; \
    fi

# Stage 2: Final Image
FROM python:3.9-slim

# Prevent Python from writing .pyc files and buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set environment variables for runtime
ENV MODEL_NAME=mistralai/Mistral-7B-v0.3
ENV MODELS_DIR=/app/models

# Install necessary system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    && git lfs install \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the downloaded model from the MODEL stage
COPY --from=model /app/models /app/models

# Copy the application code
COPY main.py .

# Expose the port the app runs on
EXPOSE 8000

# Starte die API mit Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--log-level", "debug"]