#!/bin/bash

# Verifica autenticação
if ! gh auth status &> /dev/null; then
    echo "ERRO: Execute 'gh auth login' primeiro!"
    exit 1
fi

# Seus 35 repositórios
REPOS=(
"ppsilv/sam-ba_temp"
"ppsilv/schematic"
"ppsilv/scripts"
"ppsilv/sdcc-cpm-example"
"ppsilv/smallc"
"ppsilv/smallc_4_all_platform"
"ppsilv/STK2UPDI"
"ppsilv/STM32F103C8T6"
"ppsilv/svntask"
"ppsilv/Tcp-ip-Server"
"ppsilv/tcpbox68k"
"ppsilv/teste65c02"
"ppsilv/TesteDS18b20"
"ppsilv/TesteHttpConnect"
"ppsilv/TinyBasicPlus"
"ppsilv/tms-rgb"
"ppsilv/TMS9918"
"ppsilv/tools"
"ppsilv/TOTP-Generator"
"ppsilv/triple-des"
"ppsilv/utilis-and-examples"
"ppsilv/UZI180"
"ppsilv/vasm"
"ppsilv/vbcc"
"ppsilv/vga68000"
"ppsilv/vgaPico"
"ppsilv/vgaTerminal"
"ppsilv/VGAtonic"
"ppsilv/VGA_74LSxx"
"ppsilv/vlink"
"ppsilv/x86_kernel"
"ppsilv/YAME"
"ppsilv/Z80-MBC"
"ppsilv/Z80Project"
"ppsilv/Z80_new"
"ppsilv/ZX2020"
)

echo "Criando forks na SUA conta GitHub..."
echo "Total: ${#REPOS[@]} repositórios"

for REPO in "${REPOS[@]}"; do
    echo "-> Forking: $REPO"
    gh repo fork "$REPO" --clone=false
    sleep 2  # Evitar limites da API
done

echo "Concluído!"

