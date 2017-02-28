import time

def readFile():
  while True:
    time.sleep(1)
    with open('file.txt','r+') as f:
      val = f.read(1)
      if not val:
        print ("Error: No Value")
      else:
        content = int(val)
        if content > 0:
          print "Dispensing {} inches".format(content)
          f.seek(0)
          f.write("0")
          f.truncate()


      f.close()


readFile()
