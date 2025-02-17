try:
	import RPi.GPIO as gpio
except RuntimeError:
	print("Error: Impossible to import GPIO")

import time

#gpio.setmode(gpio.BOARD)
gpio.setmode(gpio.BCM)
gpio.setwarnings(False)

porta = 18
gpio.setup(18, gpio.OUT)


while True:
  gpio.output(18, 0)
  time.sleep(0.1)

  gpio.output(18, 1)
  time.sleep(1)

