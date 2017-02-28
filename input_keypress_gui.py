#!/usr/bin/python3
import sys 

from tkinter import *

from tkinter import messagebox

import tkinter # note that module name has changed from Tkinter in Python 2 to tkinter in Python 3
top = Tk()
top.geometry("480x640")
top.configure(background='white')

def disperse(key):
    with open('file.txt','r+') as f:
        f.seek(0)
        f.write(key)
        f.close()

def disperse1():
    disperse("1")

def disperse2():
    disperse("2")
	
def disperse3():
    disperse("3")

def END():
    sys.exit()
	
button1 = Button(top, text="Dispense 1", command = disperse1)
button2 = Button(top, text="Dispense 2", command = disperse2)
button3 = Button(top, text="Dispense 3", command = disperse3)
buttonEnd = Button(top, text="END", command = END)


var = StringVar()
label = Label(top, textvariable=var, relief=RAISED )

var.set("IOT Project - Smart Sprinkler")
label.pack()


button1.place(x=60,y=50)
button2.place(x=200,y=50)
button3.place(x=340,y=50)
buttonEnd.place(x=0,y=615,width = 480)

top.mainloop()

