#!/bin/bash
# auto-upgrade-22-to-24.sh

set -e  # Sai se qualquer comando falhar

echo "=== UPGRADE UBUNTU 22.04 → 24.04 ==="
echo "Iniciando em: $(date)"
echo ""

# 1. Verificar versão atual
echo "1. Verificando versão atual..."
CURRENT_VERSION=$(lsb_release -rs)
if [ "$CURRENT_VERSION" != "22.04" ]; then
    echo "ERRO: Esta script só funciona no Ubuntu 22.04"
    echo "Versão atual: $CURRENT_VERSION"
    exit 1
fi

# 2. Update completo
echo "2. Atualizando sistema atual..."
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt clean

# 3. Instalar ferramentas necessárias
echo "3. Instalando ferramentas de upgrade..."
sudo apt install update-manager-core ubuntu-release-upgrader-core -y

# 4. Configurar
echo "4. Configurando para upgrade LTS..."
sudo sed -i 's/Prompt=normal/Prompt=lts/' /etc/update-manager/release-upgrades
sudo sed -i 's/Prompt=never/Prompt=lts/' /etc/update-manager/release-upgrades

# 5. Iniciar upgrade
echo "5. Iniciando upgrade para 24.04..."
echo "Isto vai levar algum tempo (30-60 minutos)..."
echo ""

# Modo não-interativo (responde automaticamente)
sudo DEBIAN_FRONTEND=noninteractive do-release-upgrade \
    -f DistUpgradeViewNonInteractive \
    -q \
    --allow-third-party

# 6. Pós-upgrade
echo "6. Pós-upgrade..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

echo ""
echo "=== UPGRADE CONCLUÍDO ==="
echo "Concluído em: $(date)"
echo "Nova versão:"
lsb_release -a
echo ""
echo "Reinicie o sistema: sudo reboot"
