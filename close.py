import RPi.GPIO as GPIO
import time

# Setup Pins and enable H-Bridge
GPIO.setmode(GPIO.BCM)

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


def open():
  GPIO.output(motor1Pin, GPIO.LOW)
  GPIO.output(motor2Pin, GPIO.HIGH)
  return

def close():
  GPIO.output(motor1Pin, GPIO.HIGH)
  GPIO.output(motor2Pin, GPIO.LOW)
  return


# Run Test

GPIO.output(enablePin, GPIO.HIGH)

print "Testing"
initialize()
time.sleep(0.2)

print "Close"
close()
time.sleep(0.2)

# Cleanup GPIO Pins  
GPIO.cleanup()
  

