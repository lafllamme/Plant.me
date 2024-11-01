# Verwende ein offizielles Python-Image als Basis, das ARM unterstützt
FROM python:3.9-slim

# Installiere notwendige System-Abhängigkeiten
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Setze das Arbeitsverzeichnis
WORKDIR /app

# Kopiere die Anforderungen und installiere sie
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kopiere den restlichen Anwendungscode
COPY . .

# Exponiere den Port, auf dem die API laufen wird
EXPOSE 8000

# Starte die API mit Uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
