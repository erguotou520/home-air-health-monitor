# -*- coding: utf-8 -*
'''
led灯控制
'''
import RPi.GPIO as GPIO
from Gpio import Gpio

class Led(Gpio):
  def __init__(self, port):
    super(Led, self).__init__(port)

  def start (self):
    GPIO.output(self.port, True)

  def stop (self):
    GPIO.output(self.port, False)
