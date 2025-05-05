# 🖥️ RustDesk Server - Instalação Automática (Linux)

Este repositório fornece um **script automatizado** para instalar e rodar o **servidor RustDesk (HBBR + HBBS)** usando Docker em sistemas Linux.

> ⚠️ Este script exige **permissões de root** para instalação e configuração do Docker.

---

## 📥 Como usar

### 1. Baixe o script diretamente do GitHub

```bash
curl -O https://raw.githubusercontent.com/henriquelucas/Rustdesk-Server/main/install_rustdesk.sh
```

### 2. Dê permissão de execução ao script

```bash
chmod +x install_rustdesk.sh
```

### 3. Execute o script

```bash
./install_rustdesk.sh
```

---

## 📂 Estrutura Criada

Após a execução do script, será criado um diretório `rustdesk-server` com o seguinte conteúdo:

- `docker-compose.yml`: configuração do servidor RustDesk
- `data/`: pasta persistente onde são salvos os arquivos de chave e ID

---

## 🔑 Como obter o ID e a chave do servidor

Os arquivos de chave serão criados na pasta `rustdesk-server/data/`:

```bash
ls -l rustdesk-server/data/id_ed25519*
```

---

## ✅ Pronto!

Com o servidor RustDesk em execução, você pode configurar clientes apontando para o seu IP com o ID e a chave privada gerados.
Mais se você é do tipo, não quero preocupações na minha e usa um servidor em nuvem, abre as portas também ou solicita ao suporte pra abrirem pra você.

## 🔑 Me diz você é um vida LOKA e ta usando um servidor próprio hospedado em sua empresa, casa ou barraco?
Se sim, então acessa o teu rooteador e libera as portas apontando pra teu servidor aonde o rustdesk foi instalado:

🔐 hbbs (Servidor de Registro/Mediação)
- 21114 (TCP): Usada para o console web, somente disponível na versão Pro.
- 21115 (TCP): Usada para o teste de tipo de NAT (verifica como está configurada sua rede).
- 21116 (TCP/UDP):UDP: Usado para registro de ID e serviço de heartbeat (verifica se o cliente ainda está online). TCP: Usado para perfuração de NAT (hole punching) e serviço de conexão entre cliente e servidor.
- 21118 (TCP): Usada para oferecer suporte a clientes via navegador (web).
🔁 hbbr (Servidor de Revezamento/Relay)
21117 (TCP): Usada para o serviço de revezamento (relay), quando a conexão direta entre clientes não é possível.
21119 (TCP): Também usada para dar suporte a clientes via navegador (web).

## ✅ Agora você quer tudo pronto pra sua equipe trabalhar?
Fala comigo pelo Whatsapp (83) 991086462
