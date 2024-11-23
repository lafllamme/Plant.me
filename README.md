<p align="center">
  <img src="https://i.imgur.com/uky5Etv.png" width="120" alt="Plant Assistant"/>
</p>

<h1 align="center">🌱 Plant Assistant 🌱</h1>

<p align="center">
  A local Plant Assistant that runs on your Mac, using LangChain and the <a href="https://ollama.ai/library/mistral">Mistral</a> Large Language Model (LLM) via <a href="https://ollama.ai/">Ollama</a> to provide plant care recommendations based on various parameters.
</p>

<p align="center">
  <a href="https://github.com/lafllamme/Plant.me/commits/main"><img src="https://img.shields.io/github/last-commit/lafllamme/Plant.me" alt="Last Commit"></a>
  <a href="https://github.com/lafllamme/Plant.me/issues"><img src="https://img.shields.io/github/issues/lafllamme/Plant.me" alt="Open Issues"></a>
  <a href="https://github.com/lafllamme/Plant.me/pulls"><img src="https://img.shields.io/github/issues-pr/lafllamme/Plant.me" alt="Open Pull Requests"></a>
  <a href="https://github.com/lafllamme/Plant.me"><img src="https://img.shields.io/github/license/lafllamme/Plant.me" alt="License"></a>
  <a href="https://github.com/ollama/ollama"><img src="https://img.shields.io/badge/Ollama-GitHub-blue" alt="Ollama GitHub"></a>
  <a href="https://github.com/lafllamme/Plant.me/actions"><img src="https://github.com/lafllamme/Plant.me/workflows/CI/badge.svg" alt="CI Status"></a>
</p>

## 🛠 Prerequisites

Make sure you have the following installed:

- **Docker**
- **Docker Compose**
- **Make**

## 🚀 Setup

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/lafllamme/Plant.me.git
    cd Plant.me
    ```

2. **Create a `.env` File for Environment Variables:**

    In the root directory, create a `.env` file and add the following:

    ```plaintext
    OLLAMA_MODEL=mistral
    ```

    > **Note:** The `OLLAMA_MODEL` variable specifies which model to use. In this case, we're using the [Mistral](https://ollama.ai/library/mistral) model.

3. **Build and Start the Application with Make:**

    ```bash
    make build
    make start
    ```

    > **Note:** The `make start` command brings up the services and waits for the Ollama server to become healthy.

4. **Check if the Container is Running:**

    ```bash
    docker-compose ps
    ```

## 🌐 Usage

Once the setup is complete, the API will be available at `http://localhost:8000/plant-assistant`.

### Example API Request using Ollama and Mistral

You can interact with the Ollama API directly using the Mistral model. Here's an example of how to generate a response using a `POST` request:

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "mistral",
  "prompt": "Why is the sky blue?",
  "stream": false
}' -H "Content-Type: application/json"
```

**Response:**

```json
{
  "model": "mistral",
  "created_at": "2024-11-22T15:36:02.583064Z",
  "response": " The sky appears blue because molecules in the Earth's atmosphere scatter sunlight in all directions, and blue light is scattered more than other colors due to its shorter wavelength.",
  "done": true,
  "total_duration": 8493852375,
  "load_duration": 6589624375,
  "prompt_eval_count": 14,
  "prompt_eval_duration": 119039000,
  "eval_count": 110,
  "eval_duration": 1779061000
}
```

### Using the Plant Assistant API

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

## 🧠 Supported Models and Hardware Requirements

Our application supports different models depending on your hardware capabilities. Here's a table of available models sorted by parameters in ascending order:

| Model                    | Parameters | Size    | Command                            |
|--------------------------|------------|---------|------------------------------------|
| **Llama 3.2 (1B)**       | 1B         | 1.3GB   | `ollama run llama3.2:1b`           |
| **Moondream 2**          | 1.4B       | 829MB   | `ollama run moondream`             |
| **Gemma 2 (2B)**         | 2B         | 1.6GB   | `ollama run gemma2:2b`             |
| **Llama 3.2**            | 3B         | 2.0GB   | `ollama run llama3.2`              |
| **Phi 3 Mini**           | 3.8B       | 2.3GB   | `ollama run phi3`                  |
| **Code Llama**           | 7B         | 3.8GB   | `ollama run codellama`             |
| **Llama 2 Uncensored**   | 7B         | 3.8GB   | `ollama run llama2-uncensored`     |
| **Mistral**              | 7B         | 4.1GB   | `ollama run mistral`               |
| **Neural Chat**          | 7B         | 4.1GB   | `ollama run neural-chat`           |
| **Starling**             | 7B         | 4.1GB   | `ollama run starling-lm`           |
| **LLaVA**                | 7B         | 4.5GB   | `ollama run llava`                 |
| **Llama 3.1**            | 8B         | 4.7GB   | `ollama run llama3.1`              |
| **Gemma 2**              | 9B         | 5.5GB   | `ollama run gemma2`                |
| **Solar**                | 10.7B      | 6.1GB   | `ollama run solar`                 |
| **Llama 3.2 Vision**     | 11B        | 7.9GB   | `ollama run llama3.2-vision`       |
| **Phi 3 Medium**         | 14B        | 7.9GB   | `ollama run phi3:medium`           |
| **Gemma 2 (27B)**        | 27B        | 16GB    | `ollama run gemma2:27b`            |
| **Llama 3.1 (70B)**      | 70B        | 40GB    | `ollama run llama3.1:70b`          |
| **Llama 3.2 Vision**     | 90B        | 55GB    | `ollama run llama3.2-vision:90b`   |
| **Llama 3.1 (405B)**     | 405B       | 231GB   | `ollama run llama3.1:405b`         |

> **⚠️ Note:** Larger models require more RAM. Approximate hardware requirements:
>
> - **1B - 3B parameters**: at least **4 GB RAM**
> - **7B parameters**: at least **8 GB RAM**
> - **14B parameters**: at least **16 GB RAM**
> - **27B parameters**: at least **32 GB RAM**
> - **70B parameters**: at least **64 GB RAM**
> - **90B parameters**: at least **128 GB RAM**
> - **405B parameters**: at least **256 GB RAM**

## 📚 Learn More

- **[LangChain Documentation](https://langchain.com/docs/)** - Learn more about LangChain’s capabilities for language model applications.
- **[Ollama Documentation](https://ollama.ai/docs/)** - Explore how Ollama simplifies running LLMs locally.
- **[Mistral Model](https://ollama.ai/library/mistral)** - Discover more about the Mistral model used in this project.
- **[Docker Documentation](https://docs.docker.com/)** - Dive into Docker’s powerful containerization.
- **[Ollama GitHub Repository](https://github.com/ollama/ollama)** - Check out Ollama on GitHub.

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request. Please follow the [Code of Conduct](https://github.com/lafllamme/Plant.me/blob/main/CODE_OF_CONDUCT.md) when contributing.

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

<p align="center">Made with ❤️ by <a href="https://github.com/lafllamme">lafllamme</a></p>

---
