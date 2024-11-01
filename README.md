<p align="center">
  <img src="https://example.com/plant-assistant-logo.png" width="120" alt="Plant Assistant logo"/>
</p>

<h1 align="center">🌱 Plant Assistant 🌱</h1>

<p align="center">
  A local Plant Assistant that runs on your Mac, using LangChain and a Large Language Model (LLM) to provide plant care recommendations based on various parameters.
</p>

<p align="center">
  <a href="https://github.com/lafllamme/Plant.me/actions"><img src="https://github.com/lafllamme/Plant.me/workflows/CI/badge.svg" alt="CI Status"></a>
  <a href="https://github.com/lafllamme/Plant.me/commits/main"><img src="https://img.shields.io/github/last-commit/lafllamme/Plant.me" alt="Last Commit"></a>
  <a href="https://github.com/lafllamme/Plant.me/issues"><img src="https://img.shields.io/github/issues/lafllamme/Plant.me" alt="Open Issues"></a>
  <a href="https://github.com/lafllamme/Plant.me/pulls"><img src="https://img.shields.io/github/issues-pr/lafllamme/Plant.me" alt="Open Pull Requests"></a>
  <a href="https://github.com/lafllamme/Plant.me"><img src="https://img.shields.io/github/license/lafllamme/Plant.me" alt="License"></a>
</p>

## 🛠 Prerequisites

Make sure you have the following installed:

- **Docker**
- **Docker Compose**
- **Hugging Face API Token**

## 🚀 Setup

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/your-username/plant-assistant.git
    cd plant-assistant
    ```

2. **Create a `.env` File for Environment Variables:**

    In the root directory, create a `.env` file and add your Hugging Face API token:

    ```plaintext
    HF_API_TOKEN=your_hugging_face_api_token
    ```

   > **Note:** Replace `your_hugging_face_api_token` with your actual Hugging Face API token.

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

## 🌐 Usage

Once the setup is complete, the API will be available at `http://localhost:8000/plant-assistant`.

### Example cURL Request

To get plant care recommendations, use the following sample request:

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

## 📚 Learn More

- **[LangChain Documentation](https://langchain.com/docs/)** - Learn more about LangChain’s capabilities for language model applications.
- **[Docker Documentation](https://docs.docker.com/)** - Explore Docker’s powerful containerization.
- **[Hugging Face API](https://huggingface.co/docs/api)** - Discover the range of models available through Hugging Face.

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request. Please follow the [Code of Conduct](https://github.com/lafllamme/Plant.me/blob/main/CODE_OF_CONDUCT.md) when contributing.

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

<p align="center">Made with ❤️ by <a href="https://github.com/lafllamme">lafllamme</a></p>
