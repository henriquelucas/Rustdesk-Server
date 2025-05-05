#!/bin/bash

set -e

echo "🔍 Verificando se o Docker está instalado..."
if ! command -v docker &> /dev/null; then
    echo "🚀 Docker não encontrado. Instalando..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    sudo usermod -aG docker $USER
    echo "⚠️ Docker instalado. É necessário reiniciar a sessão para aplicar permissões."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "⚙️ Instalando docker-compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

echo "📁 Criando arquivos necessários..."
mkdir -p rustdesk-server
cd rustdesk-server

cat <<EOF > docker-compose.yml
version: "3"
services:
  hbbs:
    container_name: hbbs
    image: rustdesk/rustdesk-server:latest
    command: hbbs -r 0.0.0.0:21117
    volumes:
      - ./data:/root
    network_mode: "host"
    depends_on:
      - hbbr
    restart: unless-stopped

  hbbr:
    container_name: hbbr
    image: rustdesk/rustdesk-server:latest
    command: hbbr
    volumes:
      - ./data:/root
    network_mode: "host"
    restart: unless-stopped
EOF

echo "⬇️ Iniciando containers..."
docker-compose up -d

echo "⏳ Aguardando inicialização dos serviços..."
sleep 5

echo "🔑 Exibindo ID e chave (localizados em ./data/id_ed25519*):"
ls -l ./data/id_ed25519* 2>/dev/null || echo "❌ ID/Chave ainda não gerados. Aguarde mais alguns segundos e tente novamente."

echo "✅ Instalação concluída com sucesso!"
