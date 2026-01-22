#!/usr/bin/python3
import os
import time
import glob

def find_ds18b20():
    """Encontra automaticamente o sensor DS18B20"""
    base_dir = '/sys/bus/w1/devices/'
    
    # Verifica se o diretório existe
    if not os.path.exists(base_dir):
        print("❌ Interface 1-Wire não habilitada!")
        print("   Execute: sudo modprobe w1-gpio w1-therm")
        return None
    
    # Procura por sensores (começam com 28-)
    sensors = glob.glob(base_dir + '28*')
    
    if not sensors:
        print("❌ Nenhum sensor DS18B20 encontrado!")
        print("   Verifique conexões físicas")
        return None
    
    print(f"✅ Sensor encontrado: {os.path.basename(sensors[0])}")
    return os.path.join(sensors[0], 'w1_slave')

def read_temp(sensor_path=None):
    """Lê temperatura do DS18B20"""
    if sensor_path is None:
        sensor_path = find_ds18b20()
        if sensor_path is None:
            return None
    
    try:
        with open(sensor_path, "r") as f:
            lines = f.readlines()
        
        if len(lines) < 2:
            print("⚠️  Dados incompletos do sensor")
            return None
        
        # Check if the CRC is valid
        if lines[0].strip()[-3:] == "YES":
            equals_pos = lines[1].find("t=")
            if equals_pos != -1:
                temp_string = lines[1][equals_pos+2:]
                temp_c = float(temp_string) / 1000.0
                return temp_c
        
        print("⚠️  CRC inválido ou dados corrompidos")
        return None
        
    except FileNotFoundError:
        print(f"❌ Arquivo não encontrado: {sensor_path}")
        return None
    except Exception as e:
        print(f"❌ Erro na leitura: {e}")
        return None

def main():
    print("🌡️  Monitor DS18B20 - Orange Pi 5 Plus")
    print("=" * 40)
    
    # Encontra sensor uma vez
    sensor_path = find_ds18b20()
    
    if sensor_path is None:
        print("\n🔧 Solução de problemas:")
        print("1. Conecte o sensor:")
        print("   VDD (vermelho) → 3.3V (pino 1 ou 17)")
        print("   DQ  (amarelo)  → GPIO PA7? (verifique diagrama)")
        print("   GND (preto)    → GND (pino 6, 9, etc.)")
        print("2. Adicione resistor 4.7KΩ entre VDD e DQ")
        print("3. Habilite 1-Wire: sudo modprobe w1-gpio w1-therm")
        return
    
    print("\nLendo temperatura... (Ctrl+C para sair)\n")
    
    try:
        while True:
            temp = read_temp(sensor_path)
            if temp is not None:
                print(f"\r🌡️  Temperatura: {temp:.2f}°C", end="", flush=True)
            else:
                print(f"\r❌ Falha na leitura", end="", flush=True)
            
            time.sleep(2)
            
    except KeyboardInterrupt:
        print("\n\n👋 Programa encerrado")

if __name__ == "__main__":
    # Permissões (pode precisar de sudo)
    if os.geteuid() != 0:
        print("⚠️  Executando sem privilégios de root")
        print("   Se falhar, execute com: sudo python3 script.py\n")
    
    main()
