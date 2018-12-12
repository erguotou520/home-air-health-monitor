# -*- coding: utf-8 -*
'''
无源蜂鸣器
'''
import RPi.GPIO as GPIO
import time
from Gpio import Gpio

class PassiveBuzzer(Gpio):
  def __init__(self, port, hz = 60):
    super(PassiveBuzzer, self).__init__(port)
    self.running = False
    self.pwm = GPIO.PWM(port, hz)
    self.pwm.start(0)

  def start (self):
    self.running = True
    print('true')
    while self.running:
      for dc in range(0, 101, 5):
        self.pwm.ChangeDutyCycle(dc)
        time.sleep(0.05)
      for dc in range(100, -1, -5):
        self.pwm.ChangeDutyCycle(dc)
        time.sleep(0.05)

  def stop (self):
    print('false')
    self.running = False
