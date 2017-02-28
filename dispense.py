import os
import time
import math
import RPi.GPIO as GPIO


GPIO.setmode(GPIO.BCM)
GPIO.setup(22,GPIO.IN, pull_up_down=GPIO.PUD_UP)

def measure(amount):

  # Flow meter vars
  pouring = False
  lastPinState = False
  pinState = 0
  lastPinChange = int(time.time() * 1000)
  #print lastPinChange

  pourStart = 0
  pinChange = lastPinChange
  pinDelta = 0
  hertz = 0
  flow = 0
  litersPoured = 0
  gallonsPoured = 0
  oldGal = 0

  # main loop
  while True:
    currentTime = int(time.time() * 1000)
    if GPIO.input(22):
      pinState = True
    else:
      pinState = False

  # calculate flow rate

    if(pinState != lastPinState and pinState == True):
      if(pouring == False):
        pourStart = currentTime
      pouring = True
    
      pinChange = currentTime
      pinDelta = pinChange - lastPinChange
 
      if(pinDelta != 0):
        if(pinDelta < 1000):
          hertz = 1000.0000 / pinDelta
          flow = hertz / (60 * 7.5)
          litersPoured += flow * (pinDelta / 1000.0000)
          gallonsPoured = litersPoured * 0.264172

    lastPinChange = pinChange
    lastPinState = pinState
  
    if((gallonsPoured - oldGal) > 0.01):
      print gallonsPoured  
      oldGal = gallonsPoured
    
    if(gallonsPoured >= amount):
      return

measure(15)
print "Done"
