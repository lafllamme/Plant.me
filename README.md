# Pflanzenassistent

Ein lokaler Pflanzenassistent, der auf deinem Mac läuft und mithilfe von LangChain und einem Large Language Model (LLM) Pflegeempfehlungen für Pflanzen basierend auf verschiedenen Parametern gibt.

## Voraussetzungen

- Docker
- Docker Compose
- Hugging Face API Token

## Einrichtung

1. **Clone das Repository:**

    ```bash
    git clone https://github.com/dein-benutzername/plant-assistant.git
    cd plant-assistant
    ```

2. **Erstelle eine `.env` Datei für Umgebungsvariablen:**

    ```plaintext
    HF_API_TOKEN=dein_hugging_face_api_token
    ```

   **Hinweis:** Ersetze `dein_hugging_face_api_token` mit deinem tatsächlichen Hugging Face API Token.

3. **Baue und starte die Anwendung mit Docker Compose:**

    ```bash
    docker-compose up --build
    ```

   **Optionale Flags:**
   - `-d`: Starte die Container im Hintergrund (detached mode).

    ```bash
    docker-compose up --build -d
    ```

4. **Überprüfe, ob der Container läuft:**

    ```bash
    docker-compose ps
    ```

## Nutzung

Die API ist nun unter `http://localhost:8000/plant-assistant` erreichbar.

### Beispielhafte cURL Anfrage:

```bash
curl -X POST "http://localhost:8000/plant-assistant" \
     -H "Content-Type: application/json" \
     -d '{
           "plant_name": "Ficus lyrata",
           "plant_type": "Zimmerpflanze",
           "season": "Sommer",
           "temperature": 22.5,
           "humidity": 60,
           "location": "Wohnzimmer",
           "light_conditions": "Helles indirektes Licht"
         }'
