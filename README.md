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

