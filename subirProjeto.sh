#!/bin/bash

# Função para exibir mensagens coloridas
function echo_color {
    echo -e "\e[1;34m$1\e[0m" # Azul
}

# Pede o nome do repositório
echo_color "Digite o nome do repositório:"
read REPO_NAME

# Cria o repositório no GitHub
echo_color "Criando repositório $REPO_NAME no GitHub..."
gh repo create "$REPO_NAME" --public --confirm

# Espera até o repositório estar disponível
echo_color "Aguardando criação do repositório..."
until gh repo view "$REPO_NAME" >/dev/null 2>&1; do
    sleep 3
done

# Inicializa o Git localmente
echo_color "Inicializando repositório Git local..."
git init

# Adiciona todos os arquivos
echo_color "Adicionando arquivos ao staging..."
git add .

# Pede a mensagem do commit
echo_color "Digite a mensagem do commit:"
read COMMIT_MSG

# Faz o commit
echo_color "Fazendo commit..."
git commit -m "$COMMIT_MSG"

# Configura o remote
echo_color "Configurando remote..."
GITHUB_USER=$(gh api user | jq -r '.login')
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Faz o push
echo_color "Enviando para o GitHub..."
git branch -M main
git push -u origin main

echo_color "Repositório configurado e código enviado com sucesso!"
echo_color "URL: https://github.com/$GITHUB_USER/$REPO_NAME"