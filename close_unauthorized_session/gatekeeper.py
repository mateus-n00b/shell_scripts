#!/usr/bin/env python
from Tkinter import *
from threading import Thread
import os,time

p = Tk()
Clicks = 0 # total of clicks
PASS = 6 # your pass
TTL = 14 # time to die

def gatekeeper():
    try:
        initial_pos = p.winfo_pointerxy()
        while 1:
            posxy = p.winfo_pointerxy()
            if posxy != initial_pos:
                t = Thread(None, target=tic_tac)
                t.start()

                widget = Button(None, text="Click-me or I'll close your session :)")
                widget.pack()
                widget.bind('<Button-1>', check_clicks)
                widget.mainloop()

            time.sleep(0.5)
    except:
           os.system("gnome-session-quit --force")


def check_clicks(event):
    global Clicks
    if Clicks == PASS:
        print "You're welcome!"
        exit(-1)
    else:
        Clicks+=1

def tic_tac():
    time.sleep(TTL) # Death time
    os.system("gnome-session-quit --force")

if __name__ == '__main__':
    gatekeeper()
