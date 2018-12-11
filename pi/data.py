# -*- coding: utf-8 -*
import signal
from time import sleep
from sensor.PMSensor import PMSensor
from sensor.Dart import DartSensor
from gpio.Led import Led
from gpio.PassiveBuzzer import PassiveBuzzer
from storage.LeanStorage import LeanStorage

pm25_sensor = PMSensor('/dev/ttyAMA0')
# pm25_sensor.switch_to_passive()
dart = DartSensor('/dev/ttyUSB0')
# dart.switch_to_passive()

def turnLedOn():
  led = Led(11)
  led.start()
  sleep(3)
  led.stop()

def turnBuzzerOn():
  buzzer = PassiveBuzzer(16)
  buzzer.start()
  sleep(3)
  buzzer.stop()

def gpio_alert(data):
  if data['pm25'] > 75:
    turnLedOn()
    if data['pm25'] > 115:
      turnBuzzerOn()
  if data['formaldehyde'] > 0.08:
    turnLedOn()
    if data['formaldehyde'] > 0.10:
      turnBuzzerOn()

def read_all_data_onetime():
  dict1 = pm25_sensor.read_onetime()
  dict2 = dart.read_onetime()
  dict1.update(dict2)
  # gpio_alert(dict1)
  return dict1

def read_all_data():
  dict1 = pm25_sensor.read_average_onetime()
  dict2 = dart.read_average_onetime()
  dict1.update(dict2)
  # gpio_alert(dict1)
  storage = LeanStorage()
  storage.save_daily(dict1)
  return dict1
