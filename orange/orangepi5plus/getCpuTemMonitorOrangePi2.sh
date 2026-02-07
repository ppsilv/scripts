#!/usr/bin/env python3
import os
import time
import psutil

def get_cpu_temp():
    """Retorna temperatura da CPU em °C"""
    paths = [
        '/sys/class/thermal/thermal_zone0/temp',
        '/sys/class/thermal/thermal_zone1/temp',
        '/sys/class/hwmon/hwmon0/temp1_input',
        '/sys/class/hwmon/hwmon1/temp1_input',
    ]
    
    for path in paths:
        if os.path.exists(path):
            try:
                with open(path, 'r') as f:
                    return float(f.read().strip()) / 1000.0
            except:
                continue
    return None

def monitor_system(interval=2):
    """Monitora temperatura e uso do sistema"""
    print("🖥️  Monitor do Sistema - Orange Pi 5 Plus")
    print("=" * 50)
    
    try:
        while True:
            # Temperatura
            temp = get_cpu_temp()
            
            # Uso da CPU via psutil
            cpu_percent = psutil.cpu_percent(interval=0.1)
            
            # Memória
            memory = psutil.virtual_memory()
            
            if temp:
                # Barra de temperatura
                bars = int((temp - 30) / 1.25)  # 30-80°C -> 0-40 barras
                bars = max(0, min(bars, 40))
                temp_bar = "█" * bars + " " * (40 - bars)
                
                # Barra de CPU
                cpu_bars = int(cpu_percent / 2.5)  # 0-100% -> 0-40 barras
                cpu_bars = max(0, min(cpu_bars, 40))
                cpu_bar = "█" * cpu_bars + " " * (40 - cpu_bars)
                
                print(f"\r🌡️  {temp:5.1f}°C [{temp_bar}] | "
                      f"📊 CPU: {cpu_percent:4.1f}% [{cpu_bar}] | "
                      f"💾 RAM: {memory.percent:4.1f}%", end="", flush=True)
            else:
                print(f"\r❌ Temperatura não disponível | "
                      f"CPU: {cpu_percent:4.1f}% | "
                      f"RAM: {memory.percent:4.1f}%", end="", flush=True)
            
            time.sleep(interval)
            
    except KeyboardInterrupt:
        print("\n\n👋 Monitoramento encerrado")
    except ImportError:
        print("\n❌ Biblioteca psutil não encontrada")
        print("Instale com: sudo apt install python3-psutil")

if __name__ == "__main__":
    monitor_system()



