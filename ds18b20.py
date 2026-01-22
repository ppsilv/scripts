#!/usr/bin/python3

#Wiring:
#DS18B20 Pin 1 (Left - GND): Connect to Pin 6 (GND) on the Pi.
#DS18B20 Pin 2 (Middle - Data): Connect to Pin 7 (GPIO4) on the Pi.
#DS18B20 Pin 3 (Right - VDD): Connect to Pin 1 (3.3V) on the Pi.

#DS18B20          Orange Pi (GPIO)
#──────────       ────────────────
#VDD (vermelho) → 3.3V (pino 1 ou 17)
#DQ  (amarelo)  → GPIO escolhido (ex: PA7 - pino 7)
#GND (preto)    → GND (pino 6, 9, 14, 20, etc.)


import os
import time
import glob  # Importar o módulo glob

def read_temp():
    # File path for the sensor
    base_dir = '/sys/bus/w1/devices/'
    # Finds the device folder starting with 28-
    device_folders = glob.glob(base_dir + '28*')  # Usar glob.glob()
    
    if not device_folders:  # Verificar se encontrou algum dispositivo
        print("Sensor DS18B20 não encontrado!")
        return None
        
    device_folder = device_folders[0]
    device_file = device_folder + '/w1_slave'
    
    # Read the raw data
    try:
        with open(device_file, 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Arquivo {device_file} não encontrado!")
        return None
    
    # Check if reading is valid
    if lines[0].strip()[-3:] == 'YES':
        equals_pos = lines[1].find('t=')
        if equals_pos != -1:
            temp_string = lines[1][equals_pos+2:]
            temp_c = float(temp_string) / 1000.0
            return temp_c
    return None

while True:
    temp = read_temp()
    if temp is not None:
        print(f"Temperature: {temp:.2f}°C")  # Formatação com 2 casas decimais
    else:
        print("Failed to read temperature")
    time.sleep(1)

