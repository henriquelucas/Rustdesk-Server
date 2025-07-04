#!/bin/bash

# ================================
# Instalação do RustDesk Server
# ================================

INSTALL_DIR="/opt/rustdeskserver"
DATA_DIR="$INSTALL_DIR/data"
COMPOSE_FILE="$INSTALL_DIR/docker-compose.yml"

# Solicita o IP público ou domínio
read -p "Digite o IP público ou domínio do servidor: " PUBLIC_IP

# Valida entrada simples
if [[ -z "$PUBLIC_IP" ]]; then
    echo "IP público não informado. Encerrando."
    exit 1
fi

# Criação da estrutura de diretórios
echo "➡️ Criando diretórios em $INSTALL_DIR..."
mkdir -p "$DATA_DIR"
cd "$INSTALL_DIR" || exit 1

# Gerar chave ED25519 (servidor ID/key)
if [ ! -f "$DATA_DIR/id_ed25519" ]; then
    echo "🔐 Gerando chave ED25519..."
    ssh-keygen -t ed25519 -f "$DATA_DIR/id_ed25519" -N ""
else
    echo "🔐 Chave já existente em $DATA_DIR/id_ed25519, pulando geração..."
fi

# Criar docker-compose.yml
echo "📄 Criando arquivo docker-compose.yml..."
cat > "$COMPOSE_FILE" <<EOF
version: '3.8'

services:
  hbbs:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbs
    command: hbbs -r $PUBLIC_IP:21117 -k /data/id_ed25519
    volumes:
      - ./data:/data
    ports:
      - "21115:21115"
      - "21116:21116"
      - "21116:21116/udp"
      - "21118:21118"
    restart: unless-stopped

  hbbr:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbr
    command: hbbr -k /data/id_ed25519
    volumes:
      - ./data:/data
    ports:
      - "21117:21117"
    restart: unless-stopped
EOF

# Iniciar containers
echo "🚀 Iniciando containers Docker..."
docker compose -f "$COMPOSE_FILE" up -d

# Mostrar saída final
echo ""
echo "✅ Instalação concluída!"
echo "📁 Local de instalação: $INSTALL_DIR"
echo "🔑 Chave pública para clientes:"

# Exibe a chave no terminal
if [ -f "$DATA_DIR/id_ed25519.pub" ]; then
    echo ""
    cat "$DATA_DIR/id_ed25519.pub"
    echo ""
else
    echo "❌ Erro: chave pública não encontrada!"
fi

echo ""
echo "👉 Configure os clientes RustDesk com:"
echo "   - ID Server: $PUBLIC_IP"
echo "   - Relay Server: $PUBLIC_IP"
echo "   - Key: (conforme acima)"
