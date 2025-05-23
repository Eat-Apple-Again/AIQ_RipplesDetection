# AIQToolkit Hackathon Demo

This repository demonstrates how to deploy NVIDIA AIQToolkit in a Docker container and integrate a custom ripple detection agent. Tested on MacBook Pro with M3 Pro(ARM64).

---

## Environment Setup

1. **Build Docker Image**

   ```bash
   docker build --platform linux/arm64 -t aiq:latest .
   ```

   *(Tested on MacBook Pro with M3 Pro)*

2. **Run Docker Container**

   ```bash
   docker run --name jim_aiq_01 -itd \
     -p 8888:8888 \
     -p 3000:3000 \
     aiq:latest
   ```

3. **Access the Container Shell**

   ```bash
   docker exec -it jim_aiq_01 /bin/bash
   ```

---

## NVIDIA AgentIQ Server

1. **Activate the Python Environment**

   ```bash
   cd AgentIQ
   source .venv/bin/activate
   ```

2. **Configure NVIDIA NIM API Key**  
   Register and generate at: [[NVIDIA Developer Portal]](https://build.nvidia.com)

   * **Option A: Environment Variable**

     ```bash
     export NVIDIA_API_KEY=<YOUR_API_KEY>
     ```
   * **Option B: In Workflow Configuration**

     ```yaml
     llms:
       nim_llm:
         _type: nim
         model_name: meta/llama-3.1-70b-instruct
         temperature: 0.0
         api_key: <YOUR_API_KEY>
     ```

3. **Start the AIQ Server (port 8888)**

   ```bash
   aiq serve --config_file=mine_0511/workflow.yaml --host 0.0.0.0 --port 8888
   ```

---

## Frontend User Interface

### Optional: Specify Host and Port for the UI

* **Approach 1: Modify `package.json`**
  In `AgentIQ/external/aiqtoolkit-opensource-ui/package.json`, update the scripts:

  ```jsonc
  {
    "scripts": {
      "dev": "next dev --hostname 0.0.0.0 --port 3000",
      "start": "next start --hostname 0.0.0.0 --port 3000"
    }
  }
  ```

* **Approach 2: Pass Flags in the Terminal**

  ```bash
  npm run dev -- --hostname 0.0.0.0 --port 3000
  ```

### Configure the AIQ Server URL for the UI

In `AgentIQ/external/aiqtoolkit-opensource-ui/.env`, set:

```dotenv
NEXT_PUBLIC_WEBSOCKET_CHAT_COMPLETION_URL=ws://<HOST_IP>:8888/websocket
NEXT_PUBLIC_HTTP_CHAT_COMPLETION_URL=http://<HOST_IP>:8888/chat/stream
```

### Launch the Frontend

```bash
cd AgentIQ/external/aiqtoolkit-opensource-ui
npm install
npm run dev
```

The UI will be available at `http://localhost:3000` and will connect to the AIQ server.

---

## Ripple Detection Agent Deployment

The ripple detection service is located in the `ripples_api` folder. To run it:
1. Create the Conda environment
   ```bash
   conda create -n ripple_01 python=3.10 -y
   ```
2. Activate the Conda environment:
   ```bash
   conda activate ripple_01
   pip install -r ripples_api/requirements.txt
   ```
3. Install dependencies

4. Start the FastAPI server:
   ```bash
   cd ripples_api
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8005
   ```
5. Check the API docs in the browser:
   ```
   http://localhost:8005/docs
   ```

---
# Try it
http://localhost:3000

# Demo
[![Demo Video](https://img.youtube.com/vi/8bzHJ8E2kgE/0.jpg)](https://youtu.be/8bzHJ8E2kgE)