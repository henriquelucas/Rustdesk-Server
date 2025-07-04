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

# Pergunta se deseja ativar o painel web (console)
read -p "Deseja ativar o painel de administração web? (s/N): " ENABLE_CONSOLE

# Variáveis para painel (condicional)
CONSOLE_COMMAND=""
CONSOLE_ENV=""

if [[ "$ENABLE_CONSOLE" =~ ^[sS]$ ]]; then
    read -p "Defina o nome de usuário do painel (default: admin): " PANEL_USER
    read -p "Defina a senha do painel (default: senha123): " PANEL_PASS

    PANEL_USER=${PANEL_USER:-admin}
    PANEL_PASS=${PANEL_PASS:-senha123}

    CONSOLE_COMMAND="--api-enable --api-host 0.0.0.0 --api-port 21114"
    CONSOLE_ENV="      - RUSTDESK_API_USERNAME=$PANEL_USER\n      - RUSTDESK_API_PASSWORD=$PANEL_PASS"
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
    command: hbbs -r $PUBLIC_IP:21117 $CONSOLE_COMMAND
    environment:
$CONSOLE_ENV
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
echo -e "\n✅ Instalação concluída!"
echo "📁 Local de instalação: $INSTALL_DIR"
echo "🔑 Chaves geradas em:"
[[ -f "$DATA_DIR/id_ed25519" ]] && echo "  - Privada: $DATA_DIR/id_ed25519" || echo "  ⚠️ Chave privada não encontrada ainda"
[[ -f "$DATA_DIR/id_ed25519.pub" ]] && echo "  - Pública:  $DATA_DIR/id_ed25519.pub" || echo "  ⚠️ Chave pública não encontrada ainda"

# Instruções finais
echo -e "\n👉 Configure os clientes RustDesk com:"
echo "   - ID Server:    $PUBLIC_IP"
echo "   - Relay Server: $PUBLIC_IP"
echo "   - Key File:     id_ed25519.pub"

if [[ "$ENABLE_CONSOLE" =~ ^[sS]$ ]]; then
    echo -e "\n🧪 Painel Web ativado em: http://$PUBLIC_IP:21114"
    echo "   Usuário: $PANEL_USER"
    echo "   Senha:   $PANEL_PASS"
fi
