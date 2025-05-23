# -------------------------------------------------
# Single-stage Build: NVIDIA AIQToolkit on ARM/macOS M3 Pro
# -------------------------------------------------

# 1. Choose the multi-arch official Python 3.12 slim image
FROM python:3.12-slim-bullseye

# 2. Install system dependencies
RUN apt-get update && \
    apt-get install -y \
            wget git git-lfs npm curl && \
    rm -rf /var/lib/apt/lists/*

# 3. Enable Git LFS
RUN git lfs install

# 4. Install uv (Astral venv manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 5. Add uv to PATH
ENV PATH="/root/.local/bin:${PATH}"

# 7. Create workspace and clone AIQToolkit
WORKDIR /home
RUN git clone https://github.com/Eat-Apple-Again/AIQ_RipplesDetection.git AgentIQ && \
    cd AgentIQ && \
    git submodule update --init --recursive && \
    git lfs fetch && git lfs pull
WORKDIR /home/AgentIQ

# 8. Use uv to create and name venv (.venv) and upgrade pip
RUN uv venv --seed .venv && \
    . .venv/bin/activate && \
    pip install --upgrade pip

# 9. Install all plugins, profiling tools, and AIQ core inside the venv
RUN . .venv/bin/activate && \
    uv sync --all-groups --all-extras

# 10. Set ENTRYPOINT to:
#     - cd into /home/AgentIQ
#     - activate the .venv environment
#     - start an interactive bash shell
ENV AIQ_HOME="/home/AgentIQ"
ENTRYPOINT ["/bin/bash","-lc","cd /home/AgentIQ && source .venv/bin/activate && exec bash"]
