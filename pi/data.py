# -*- coding: utf-8 -*
import signal
from time import sleep
from sensor.PMSensor import PMSensor
from sensor.Dart import DartSensor
from gpio.Led import Led
from gpio.PassiveBuzzer import PassiveBuzzer
from storage.LeanStorage import LeanStorage
import thread

pm25_sensor = PMSensor('/dev/ttyAMA0')
# pm25_sensor.switch_to_passive()
dart = DartSensor('/dev/ttyUSB0')
# dart.switch_to_passive()

led = Led(11)
buzzer = PassiveBuzzer(16)

def turnLedOn():
  led.start()

def turnLedOff(name):
  sleep(3)
  led.stop()

def turnBuzzerOn():
  buzzer.start()

def turnBuzzerOff(name):
  sleep(3)
  buzzer.stop()

def gpio_alert(data):
  if data['pm25'] > 75 or data['formaldehyde'] > 0.08:
    turnLedOn()
    thread.start_new_thread(turnLedOff, ('led-thread',))
    if data['pm25'] > 115 or data['formaldehyde'] > 0.12:
      turnBuzzerOn()
      thread.start_new_thread(turnBuzzerOff, ('buzzer-thread',))

def read_all_data_onetime():
  dict1 = pm25_sensor.read_onetime()
  dict2 = dart.read_onetime()
  dict1.update(dict2)
  gpio_alert(dict1)
  return dict1

def read_all_data():
  dict1 = pm25_sensor.read_average_onetime()
  dict2 = dart.read_average_onetime()
  dict1.update(dict2)
  gpio_alert(dict1)
  storage = LeanStorage()
  storage.save_daily(dict1)
  return dict1
