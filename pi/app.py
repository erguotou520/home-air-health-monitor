# -*- coding: utf-8 -*
import signal
from flask import Flask, jsonify
import RPi.GPIO as GPIO
from config import config
from data import read_all_data_onetime

def cleanup():
  GPIO.cleanup()

signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT, cleanup)

app = Flask(__name__)

@app.route("/")
def home():
  return "Hello home air health monitor"

@app.route("/data")
def get_data():
  data = read_all_data_onetime()
  return jsonify(data)

if __name__ == '__main__':
  # read_all_data_onetime()
  app.debug = True
  app.run(config['server']['host'], config['server']['port'])
