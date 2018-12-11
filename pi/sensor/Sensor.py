# -*- coding: utf-8 -*
'''
通用串口设备
'''
from __future__ import division
import serial
import sys
import binascii
from time import sleep

class Sensor(object):

  def __init__(self, dev, data_length, baud_rate = 9600):
    self.dev = dev
    self.baud_rate = baud_rate
    self.data_length = data_length
    self.data = []
    try:
      self.ser = serial.Serial(dev, baud_rate)
    except ValueError:
      exit(-1)

  @staticmethod
  def unsigned (n):
    return n & 0xFF

  def _check_active_head(self):
    pass

  def _check_passive_head(self):
    pass

  def _get_check_sum(self, data):
    pass

  def _check_sum(self):
    pass

  def _parse_active_data(self):
    pass

  def _parse_passive_data(self):
    pass

  def switch_to_active(self):
    pass

  def switch_to_passive(self):
    pass

  def _read(self, head_check_func, parse_func):
    self.data = []
    for val in self.ser.read(self.data_length):
      self.data.append(int(binascii.b2a_hex(val), 16))
    # print(self.data)
    if head_check_func() is False:
      print(self.data)
      return (False, 'Error head data')
    if self._check_sum() is False:
      print(self.data)
      return (False, 'Error data when checksum')
    return (True, parse_func())

  def read_active(self):
    pass

  def read_passive(self):
    pass

  def read_onetime(self):
    ret = False
    while ret is False:
      data = self.read_passive()
      if data[0] is True:
        return data[1]

  def read_average_onetime(self):
    ret = {}
    i = 0
    while i < 10:
      data = self.read_passive()
      if data[0] is True:
        i = i + 1
        for key in data[1]:
          if key in ret:
            ret[key] += data[1][key]
          else:
            ret[key] = data[1][key]
        sleep(0.3)
    for key in ret:
      ret[key] = round(ret[key] * 1000) / 10000
    return ret
