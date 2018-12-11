# -*- coding: utf-8 -*
'''
PM2.5+温湿度传感器
'''
from __future__ import division
from Sensor import Sensor
from time import sleep

class PMSensor(Sensor):
  def __init__(self, dev):
    super(PMSensor, self).__init__(dev, 32, 9600)

  def _check_active_head(self):
    return self.data[0] is 0x42 and self.data[1] is 0x4d

  def _check_passive_head(self):
    return self._check_active_head()

  def _get_check_sum(self, data):
    return sum(data[0:self.data_length-2])

  def _check_sum(self):
    return self._get_check_sum(self.data) == self.data[self.data_length-2] * 256 + self.data[self.data_length-1]

  def _parse_active_data(self):
    pm25_h = self.data[12]
    pm25_l = self.data[13]
    temp_h = self.data[24]
    temp_l = self.data[25]
    humidity_h = self.data[26]
    humidity_l = self.data[27]
    return {
      'pm25': pm25_h * 256 + pm25_l,
      'temperature': (temp_h * 256 + temp_l)/10,
      'humidity': (humidity_h * 256 + humidity_l)/10
    }

  def _parse_passive_data(self):
    return self._parse_active_data()

  def switch_to_active(self):
    self.ser.write([0x42, 0x4d, 0xe1, 0x00, 0x01, 0x01, 0x71])

  def switch_to_passive(self):
    self.ser.write([0x42, 0x4d, 0xe1, 0x00, 0x00, 0x01, 0x70])

  def read_active(self):
    return self._read(self._check_active_head, self._parse_active_data)

  def read_passive(self):
    self.ser.write([0x42, 0x4d, 0xe2, 0x00, 0x00, 0x01, 0x71])
    sleep(0.3)
    return self._read(self._check_passive_head, self._parse_passive_data)

if __name__ == '__main__':
  pm25_sensor = PMSensor('/dev/ttyAMA0')
  # pm25_sensor.switch_to_passive()
  print(pm25_sensor.read_onetime())
  print(pm25_sensor.read_average_onetime())
