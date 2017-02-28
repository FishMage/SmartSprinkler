import RPi.GPIO as GPIO
import time
import math
import os

# Setup Pins and enable H-Bridge
GPIO.setmode(GPIO.BCM)
GPIO.setup(22,GPIO.IN, pull_up_down=GPIO.PUD_UP)

motor1Pin = 23
motor2Pin = 24
enablePin = 27


GPIO.setup(motor1Pin, GPIO.OUT)
GPIO.setup(motor2Pin, GPIO.OUT)
GPIO.setup(enablePin, GPIO.OUT)

# Define Functions
def initialize():
  GPIO.output(motor1Pin, GPIO.LOW)
  GPIO.output(motor2Pin, GPIO.LOW)
  return


def openValve():
  GPIO.output(motor1Pin, GPIO.LOW)
  GPIO.output(motor2Pin, GPIO.HIGH)
  return

def closeValve():
  GPIO.output(motor1Pin, GPIO.HIGH)
  GPIO.output(motor2Pin, GPIO.LOW)
  return


def dispense(amount):

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

    if(gallonsPoured - oldGal):
      print gallonsPoured
      oldGal = gallonsPoured

    if(gallonsPoured >= amount):
      return




# Run Test
GPIO.output(enablePin, GPIO.HIGH)

print "Testing"
initialize()
time.sleep(0.5)
try:
  while True:
    time.sleep(1)
    with open('file.txt','r+') as f:
      val = f.read(1)
      if not val:
        print ("Error: No Value")
      else:
        content = float(val)
        if content > 0:
          print "Dispensing {} inches".format(content)

          print "Open"
          openValve()
          time.sleep(0.1)

          print "Dispensing Water"
          if content == 1:
            dispense(0.85)

          if content == 2:
            dispense(1.7)

          if content == 3:
            dispense(2.8)


          print "Close"
          closeValve()
          time.sleep(0.5)

          initialize()

          f.seek(0)
          f.write("0")
          f.truncate()

          #with open('log.txt', 'a') as log:
           # log.seek(0)
           # log.write(time.strftime("%X ") + "{} inches dispensed: ".format(content) + time.strftime(" %x") + "\n")
           # log.close()
      
      f.close()

except KeyboardInterrupt:
  # Cleanup GPIO Pins  
  print "exiting"
  GPIO.cleanup()


 

