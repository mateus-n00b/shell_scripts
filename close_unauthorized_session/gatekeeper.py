#!/usr/bin/env python
from Tkinter import *
from threading import Thread
import os,time

p = Tk()
Clicks = 0

def gatekeeper():
    time.sleep(15)
    try:
        initial_pos = p.winfo_pointerxy()
        while 1:
            posxy = p.winfo_pointerxy()
            if posxy != initial_pos:
                os.system("gnome-session-quit --force")
            time.sleep(0.5)
    except:
           os.system("gnome-session-quit --force")


def check_clicks(event):
    global Clicks
    if Clicks == 5:
        print "You're welcome!"
        exit(-1)
    else:
        Clicks+=1

if __name__ == '__main__':
    t = Thread(None, target=gatekeeper)
    t.start()

    widget = Button(None, text="Click-me or I'll close your session :)")
    widget.pack()
    widget.bind('<Button-1>', check_clicks)
    widget.mainloop()
