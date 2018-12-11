# -*- coding: utf-8 -*
'''
LeanCloud数据存储
'''
import leancloud
from Model import Daily
from Model import Tar
from config import config

class LeanStorage:

  def __init__(self):
    leancloud.init(config['leancloud']['appid'], config['leancloud']['appkey'])

  def save_daily(self, data):
    daily = Daily()
    for key in data:
      daily.set(key, data[key])
    daily.save()

  def save_tar(self, data):
    tar = Tar()
    for key in data:
      tar.set(key, data[key])
    tar.save()
