#!/usr/bin/env python3
import os
import time
import psutil  # pip install psutil


def get_cpu_temp():
    """Retorna temperatura da CPU em °C"""
    try:
        with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
            return float(f.read().strip()) / 1000.0
    except:
        try:
            with open('/sys/class/hwmon/hwmon0/temp1_input', 'r') as f:
                return float(f.read().strip()) / 1000.0
        except:
            return None


def monitor_temperature(interval=2):
    """Monitora temperatura continuamente"""
    print("Monitorando temperatura da CPU... (Ctrl+C para sair)\n")
    
    try:
        while True:
            temp = get_cpu_temp()
            
            if temp:
                # Barra visual
                bars = int(temp - 30)  # Ajuste conforme necessário
                bar = "█" * min(bars, 40)
                
                print(f"\r🌡️  {temp:5.1f}°C [{bar:40}]", end="")
            
            time.sleep(interval)
            
    except KeyboardInterrupt:
        print("\n\nMonitoramento encerrado")

if __name__ == "__main__":
    monitor_temperature()

