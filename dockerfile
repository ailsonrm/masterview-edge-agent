# ============================================
# 🧠 Edge Agent Dockerfile
# Python 3.12 + OpenCV + dlib + face_recognition
# ============================================

FROM ubuntu:22.04

# Evita prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza sistema e instala dependências nativas
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    pkg-config \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk-3-dev \
    libboost-all-dev \
    libatlas-base-dev \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Define Python 3.12 como padrão
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Diretório da aplicação
WORKDIR /app

# Copia requirements primeiro (melhora cache)
COPY requirements.txt .

# Atualiza pip e instala dependências Python
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copia o código do agente
COPY . .

# Expõe porta (caso queira WebSocket ou API local)
EXPOSE 8000

# Define comando padrão (roda o agente)
CMD ["python", "agent.py"]

