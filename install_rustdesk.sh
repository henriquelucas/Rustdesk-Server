#!/bin/bash

# ================================
# Instalação do RustDesk Server
# ================================

INSTALL_DIR="/opt/rustdesk"
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

# Criar docker-compose.yml
echo "📄 Criando arquivo docker-compose.yml..."
cat > "$COMPOSE_FILE" <<EOF
version: '3.8'

services:
  hbbs:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbs
    command: hbbs -r $PUBLIC_IP:21117
    volumes:
      - ./data:/root
    network_mode: "host"
    restart: unless-stopped

  hbbr:
    image: rustdesk/rustdesk-server:latest
    container_name: hbbr
    command: hbbr
    volumes:
      - ./data:/root
    network_mode: "host"
    restart: unless-stopped
EOF

# Iniciar containers
echo "🚀 Iniciando containers Docker..."
docker compose -f "$COMPOSE_FILE" up -d

# Aguarda geração automática das chaves pelo RustDesk
echo "⏳ Aguardando geração automática das chaves pelo RustDesk (10s)..."
sleep 10

# Exibir localização das chaves
echo "\n✅ Instalação concluída!"
echo "📁 Local de instalação: $INSTALL_DIR"
echo "🔑 Chaves geradas em:"
if [[ -f "$DATA_DIR/id_ed25519" ]]; then
    echo "  - Privada: $DATA_DIR/id_ed25519"
else
    echo "  ⚠️ Chave privada não encontrada ainda"
fi
if [[ -f "$DATA_DIR/id_ed25519.pub" ]]; then
    echo "  - Pública:  $DATA_DIR/id_ed25519.pub"
else
    echo "  ⚠️ Chave pública não encontrada ainda"
fi

echo "\n👉 Configure os clientes RustDesk com:"
echo "   - ID Server:    $PUBLIC_IP"
echo "   - Relay Server: $PUBLIC_IP"
echo "   - Key File:     id_ed25519.pub"
