#!/bin/bash
# Fan control for Orange Pi 5 Plus
# PWM control on PWM0

# Enable PWM0
if [ ! -d "/sys/class/pwm/pwmchip0/pwm0" ]; then
    echo 0 > /sys/class/pwm/pwmchip0/export
    sleep 1
fi

# Configure PWM: period=10000ns (10kHz), duty_cycle=0 (0% initially)
echo 10000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 0 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable

# Control loop
while true; do
    # Read temperature (in millidegrees Celsius)
    TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo "40000")
    
    # Convert to Celsius
    TEMP_C=$((TEMP / 1000))
    
    # Adjust fan speed based on temperature
    if [ $TEMP_C -gt 70 ]; then
        # 100% speed at >70°C
        DUTY=10000
    elif [ $TEMP_C -gt 60 ]; then
        # 75% speed at 60-70°C
        DUTY=7500
    elif [ $TEMP_C -gt 50 ]; then
        # 50% speed at 50-60°C
        DUTY=5000
    elif [ $TEMP_C -gt 40 ]; then
        # 25% speed at 40-50°C
        DUTY=2500
    else
        # 0% speed at <40°C
        DUTY=0
    fi
    
    echo $DUTY > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
    
    # Log temperature every minute
    if [ $((SECONDS % 60)) -eq 0 ]; then
        echo "$(date): Temperature ${TEMP_C}°C - PWM duty: $((DUTY / 100))%"
    fi
    
    sleep 5
done

