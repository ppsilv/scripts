#!/bin/bash

echo "Exportando lista de forks..."

# SOLUÇÃO 1: Usar API diretamente (funciona melhor)

gh api user/repos --paginate --jq '.[] | select(.fork == true) | .full_name' > forks_lista.txt

echo "Forks exportados para forks_lista.txt"
echo "Conteúdo:"
cat forks_lista.txt

