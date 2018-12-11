# -*- coding: utf-8 -*
'''
通用串口设备
'''
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)

class Gpio(object):

  def __init__(self, port):
    self.port = port
    GPIO.setup(port, GPIO.OUT)

  def start(self):
    pass

  def stop(self):
    pass
