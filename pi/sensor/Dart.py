# -*- coding: utf-8 -*
'''
dart甲醛检测
'''
from __future__ import division
from Sensor import Sensor
from time import sleep

class DartSensor(Sensor):
  def __init__(self, dev):
    super(DartSensor, self).__init__(dev, 9, 9600)

  def _check_active_head(self):
    return self.data[0] is 0xff and self.data[1] is 0x17

  def _check_passive_head(self):
    return self.data[0] is 0xff and self.data[1] is 0x86

  def _get_check_sum(self, data):
    return Sensor.unsigned(~(sum(data[0: self.data_length - 1])))

  def _check_sum(self):
    return self._get_check_sum(self.data) == self.data[self.data_length - 1]

  def _fill_write_data(self, data):
    data[8] = self._get_check_sum(data)
    return data

  def _parse_active_data(self):
    high = self.data[4]
    low = self.data[5]
    return {
      'formaldehyde': (high * 256 + low) / 1000
    }

  def _parse_passive_data(self):
    high = self.data[6]
    low = self.data[7]
    return {
      'formaldehyde': (high * 256 + low) / 1000
    }

  def switch_to_active(self):
    self.ser.write(self._fill_write_data([0xff, 0x01, 0x78, 0x40, 0x00, 0x00, 0x00, 0x00, None]))

  def switch_to_passive(self):
    self.ser.write(self._fill_write_data([0xff, 0x01, 0x78, 0x41, 0x00, 0x00, 0x00, 0x00, None]))

  def read_active(self):
    return self._read(self._check_active_head, self._parse_active_data)

  def read_passive(self):
    self.ser.write([0xff, 0x01, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79])
    sleep(0.3)
    return self._read(self._check_passive_head, self._parse_passive_data)

if __name__ == '__main__':
  dart = DartSensor('/dev/ttyUSB0')
  # dart.switch_to_active()
  print(dart.read_onetime())
  print(dart.read_average_onetime())
