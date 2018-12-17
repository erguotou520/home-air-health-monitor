# -*- coding: utf-8 -*
import os
import signal
import atexit
from subprocess import call
from flask import Flask, jsonify, Response
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.schedulers import SchedulerNotRunningError
import RPi.GPIO as GPIO
from config import config
from data import read_all_data_onetime
from data import read_all_data

def shutdown(*args):
  try:
    sched.shutdown(wait=False)
  except SchedulerNotRunningError:
    pass
  GPIO.cleanup()

signal.signal(signal.SIGTERM, shutdown)
signal.signal(signal.SIGINT, shutdown)
atexit.register(shutdown)

# scheduler
sched = BackgroundScheduler()
sched.add_job(read_all_data, 'cron', minute=0)
sched.add_job(read_all_data, 'cron', minute=15)
sched.add_job(read_all_data, 'cron', minute=30)
sched.add_job(read_all_data, 'cron', minute=45)

app = Flask(__name__)

@app.route('/')
def home():
  resp = Response('Hello home air health monitor')
  resp.headers['Server'] = 'HomeAirHealth'
  return resp

@app.route('/data')
def get_data():
  data = read_all_data_onetime()
  return jsonify(data)

@app.route('/halt', methods = ['POST'])
def shutdown():
  call('sudo halt', shell = True)

@app.route('/reboot', methods = ['POST'])
def reboot():
  call('sudo reboot', shell = True)

if __name__ == '__main__':
  sched.start()
  app.debug = True
  app.run(config['server']['host'], config['server']['port'])
