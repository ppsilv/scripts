#!/usr/bin/env python3
import subprocess
import re
import sys
import logging
import logging.handlers

# Configurar logger para syslog
logger = logging.getLogger('apt_upgrade')
logger.setLevel(logging.DEBUG)
handler = logging.handlers.SysLogHandler(address='/dev/log')
formatter = logging.Formatter('%(name)s[%(process)d]: %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)



def extract_packages_from_apt():
    """Executa apt upgrade e extrai os pacotes listados"""
    try:
        # Executa apt upgrade em modo dry-run
        result = subprocess.run(
            ['sudo', 'apt', 'upgrade', '--dry-run'],
            capture_output=True,
            text=True,
            check=False
        )
        
        # Procura por pacotes na saída
        packages = []
        lines = result.stdout.split('\n')
        
        # Padrão para encontrar linhas com pacotes
        for line in lines:
            if 'libmagickcore' in line or 'libzvbi' in line or 'imagemagick' in line or \
               'libcjson' in line or 'libsvn' in line or 'subversion' in line:
                # Extrai nomes de pacotes (simplificado)
                words = line.split()
                for word in words:
                    if word.startswith(('lib', 'imagemagick', 'subversion')) and not word.endswith(':'):
                        # Remove caracteres especiais
                        clean_word = word.strip(',.:;')
                        if clean_word and clean_word not in packages:
                            packages.append(clean_word)
        
        # Se não encontrou, tenta um método alternativo
        if not packages:
            # Executa apt list --upgradable
            result = subprocess.run(
                ['apt', 'list', '--upgradable'],
                capture_output=True,
                text=True,
                check=False
            )
            
            for line in result.stdout.split('\n'):
                if '/' in line and 'upgradable' in line:
                    package = line.split('/')[0]
                    packages.append(package)
        
        return list(set(packages))  # Remove duplicatas
        
    except Exception as e:
        print(f"Erro: {e}")
        return []

def upgrade_specific_packages(packages):
    """Atualiza pacotes específicos"""
    if not packages:
        print("Nenhum pacote para atualizar.")
        return
    
    print(f"Pacotes a serem atualizados: {', '.join(packages)}")
    print(f"Total: {len(packages)} pacotes\n")
    logger.info(f"Pacotes a serem atualizados: {', '.join(packages)}")
    logger.info(f"Total: {len(packages)} pacotes\n")
    
    # Atualiza todos de uma vez
    cmd = ['sudo', 'apt', 'install', '--only-upgrade', '-y'] + packages
    print(f"Executando: {' '.join(cmd)}")
    logger.info(f"Executando: {' '.join(cmd)}") 
    try:
        subprocess.run(cmd, check=True)
        print("\nAtualização concluída!")
        logger.info("\nAtualização concluída!")
    except subprocess.CalledProcessError as e:
        print(f"\nErro na atualização: {e}")
        logger.info(f"\nErro na atualização: {e}")
        # Tenta atualizar um por um em caso de erro
        print("\nTentando atualizar pacotes individualmente...")
        logger.info("\nTentando atualizar pacotes individualmente...")
        for package in packages:
            try:
                subprocess.run(['sudo', 'apt', 'install', '--only-upgrade', '-y', package], check=True)
                print(f"✓ {package}")
                logger.info(f"✓ {package}")
            except:
                print(f"✗ Falha em {package}")
                logger.info(f"✗ Falha em {package}")

def main():
    print("=== Atualizador de Pacotes Ubuntu ===\n")
    logger.info("=== Atualizador de Pacotes Ubuntu ===\n")
    
    # Extrai pacotes da saída do apt
    packages = extract_packages_from_apt()
    
    if packages:
        print(packages)    
        logger.info(packages)    
        upgrade_specific_packages(packages)
    else:
        print("Não foi possível detectar pacotes para atualização.")
        logger.info("Nao tem pacotes especiais para ser atualizado.")
        print("Execute manualmente:")
        print("sudo apt update && sudo apt list --upgradable")

if __name__ == "__main__":
    main()

