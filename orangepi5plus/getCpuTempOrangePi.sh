#!/usr/bin/python3
#
#
import os
import glob

def read_cpu_temperature():
    """Lê temperatura da CPU no Orange Pi 5 Plus"""
    
    # Caminhos possíveis para temperatura
    temp_paths = [
        # Orange Pi 5 Plus (Rockchip RK3588)
        '/sys/class/thermal/thermal_zone0/temp',  # Mais comum
        '/sys/class/thermal/thermal_zone1/temp',
        '/sys/class/hwmon/hwmon0/temp1_input',
        '/sys/class/hwmon/hwmon1/temp1_input',
        '/sys/devices/virtual/thermal/thermal_zone0/temp',
    ]
    
    for path in temp_paths:
        if os.path.exists(path):
            try:
                with open(path, 'r') as f:
                    temp_str = f.read().strip()
                
                # Converte de milligraus Celsius para graus
                temp_c = float(temp_str) / 1000.0
                return temp_c, path
                
            except Exception as e:
                print(f"Erro ao ler {path}: {e}")
                continue
    
    return None, None

def read_all_temperatures():
    """Lê todas as zonas térmicas disponíveis"""
    temperatures = {}
    
    # Encontra todas as zonas térmicas
    thermal_zones = glob.glob('/sys/class/thermal/thermal_zone*')
    
    for zone in thermal_zones:
        try:
            # Lê o tipo de sensor
            with open(os.path.join(zone, 'type'), 'r') as f:
                sensor_type = f.read().strip()
            
            # Lê temperatura
            with open(os.path.join(zone, 'temp'), 'r') as f:
                temp_str = f.read().strip()
                temp_c = float(temp_str) / 1000.0
            
            temperatures[sensor_type] = temp_c
            
        except Exception as e:
            print(f"Erro na zona {zone}: {e}")
            continue
    
    return temperatures

def main():
    print("🌡️  Monitor de Temperatura - Orange Pi 5 Plus")
    print("=" * 40)
    
    # Leitura simples
    temp, path = read_cpu_temperature()
    
    if temp is not None:
        print(f"Temperatura CPU: {temp:.1f}°C")
        print(f"Fonte: {path}")
    else:
        print("❌ Não foi possível ler temperatura")
    
    print("\n📊 Todas as zonas térmicas:")
    print("-" * 40)
    
    temps = read_all_temperatures()
    
    if temps:
        for sensor, temp in temps.items():
            print(f"{sensor:20}: {temp:6.1f}°C")
    else:
        print("Nenhuma zona térmica encontrada")
    
    # Informações adicionais
    print("\n🔍 Informações do sistema:")
    print("-" * 40)
    
    # Modelo da placa
    try:
        with open('/proc/device-tree/model', 'r') as f:
            model = f.read().strip()
        print(f"Modelo: {model}")
    except:
        pass
    
    # Kernel
    print(f"Kernel: {os.uname().release}")

if __name__ == "__main__":
    main()
